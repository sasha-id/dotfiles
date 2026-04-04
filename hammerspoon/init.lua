local log = hs.logger.new("ticktick", "debug")
local yabai = "/opt/homebrew/bin/yabai" -- adjust if needed
local tickWatcher, mouseWatcher
local lastObservedApp

local function runYabai(...)
  local args = { "-m", ... }
  log.df("yabai %s", table.concat(args, " "))
  hs.task.new(yabai, nil, function() return false end, args):start()
end

local function frontmostAppName()
  local app = hs.application.frontmostApplication()
  return app and app:name() or nil
end

local function stopMouseWatcher()
  if mouseWatcher then
    log.d("stopping mouse watcher")
    mouseWatcher:stop()
    mouseWatcher = nil
  end
end

local function startMouseWatcher(win)
  stopMouseWatcher()
  if not win then return end
  local frame = win:frame()
  if not frame then return end
  local frameRight = frame.x + frame.w
  local frameBottom = frame.y + frame.h
  log.df("starting mouse watcher for frame x=%d y=%d w=%d h=%d", frame.x, frame.y, frame.w, frame.h)
  mouseWatcher = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, function()
    local pt = hs.mouse.absolutePosition()
    if pt.x < frame.x or pt.x > frameRight or pt.y < frame.y or pt.y > frameBottom then
      log.d("mouse left TickTick window → re-enabling autoraise")
      runYabai("config", "focus_follows_mouse", "autoraise")
      stopMouseWatcher()
    end
  end):start()
end

tickWatcher = hs.window.filter.new(false)
tickWatcher:setAppFilter("TickTick", { allowTitles = {"TickTick"} })

tickWatcher:subscribe(hs.window.filter.windowFocused, function(win, appName, event)
  log.df("event=%s app=%s → disabling focus_follows_mouse", event, appName)
  runYabai("config", "focus_follows_mouse", "off")
  startMouseWatcher(win)
  lastObservedApp = appName or frontmostAppName()
end)

tickWatcher:subscribe({
  hs.window.filter.windowDestroyed,
  hs.window.filter.windowUnfocused,
  hs.window.filter.windowMinimized,
  hs.window.filter.windowHidden,
}, function(win, appName, event)
  log.df("event=%s app=%s → restoring autoraise", event, appName)

  -- Always re-enable on destroy — window object may be stale/nil
  if event == "windowDestroyed" then
    runYabai("config", "focus_follows_mouse", "autoraise")
    stopMouseWatcher()
    lastObservedApp = frontmostAppName()
    return
  end

  if not win then return end
  local title = win:title()
  if not title or title ~= "TickTick" then return end

  lastObservedApp = frontmostAppName()
  runYabai("config", "focus_follows_mouse", "autoraise")
  stopMouseWatcher()
end)

lastObservedApp = frontmostAppName()
log.f("init.lua loaded — watching TickTick (frontmost: %s)", lastObservedApp or "none")
