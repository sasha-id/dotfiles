local yabai = "/opt/homebrew/bin/yabai" -- adjust if needed
local tickWatcher, mouseWatcher

local function runYabai(...)
  hs.task.new(yabai, nil, function() return false end, { "-m", ... }):start()
end

local function stopMouseWatcher()
  if mouseWatcher then mouseWatcher:stop() mouseWatcher = nil end
end

local function startMouseWatcher(win)
  stopMouseWatcher()
  local frame = win:frame()
  mouseWatcher = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, function()
    local pt = hs.mouse.absolutePosition()
    if not hs.geometry.rect(frame):contains(pt) then
      runYabai("config", "focus_follows_mouse", "autoraise")
      stopMouseWatcher()
    end
  end):start()
end

tickWatcher = hs.window.filter.new(false)
tickWatcher:setAppFilter("TickTick", { allowTitles = true })
tickWatcher:subscribe(hs.window.filter.windowFocused, function(win)
  runYabai("config", "focus_follows_mouse", "off")
  startMouseWatcher(win)
end)
tickWatcher:subscribe({
  hs.window.filter.windowDestroyed,
  hs.window.filter.windowUnfocused,
  hs.window.filter.windowMinimized,
  hs.window.filter.windowHidden,
}, function()
  runYabai("config", "focus_follows_mouse", "autoraise")
  stopMouseWatcher()
end)