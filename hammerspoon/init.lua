local yabai = "/opt/homebrew/bin/yabai" -- adjust if needed
local tickWatcher, mouseWatcher
local lastObservedApp

local function runYabai(...)
    hs.task.new(yabai, nil, function()
        return false
    end, {"-m", ...}):start()
end

local function frontmostAppName()
    local app = hs.application.frontmostApplication()
    return app and app:name() or nil
end

local function stopMouseWatcher()
    if mouseWatcher then
        mouseWatcher:stop()
        mouseWatcher = nil
    end
end

local function startMouseWatcher(win)
    stopMouseWatcher()
    if not win then
        return
    end
    local frame = win:frame()
    if not frame then
        return
    end
    local frameRight = frame.x + frame.w
    local frameBottom = frame.y + frame.h
    mouseWatcher = hs.eventtap.new({hs.eventtap.event.types.mouseMoved}, function()
        local pt = hs.mouse.absolutePosition()
        if pt.x < frame.x or pt.x > frameRight or pt.y < frame.y or pt.y > frameBottom then
            runYabai("config", "focus_follows_mouse", "autoraise")
            stopMouseWatcher()
        end
    end):start()
end

tickWatcher = hs.window.filter.new(false)
tickWatcher:setAppFilter("TickTick", {
    allowTitles = {"TickTick"}
})
tickWatcher:subscribe(hs.window.filter.windowFocused, function(win, appName, event)
    local title = win and win:title() or "<no title>"
    hs.printf("[TickTick watcher] event=%s app=%s title=%s", event or "windowFocused", appName or "<no app>", title)
    runYabai("config", "focus_follows_mouse", "off")
    startMouseWatcher(win)
    lastObservedApp = appName or frontmostAppName()
end)
tickWatcher:subscribe({hs.window.filter.windowDestroyed, hs.window.filter.windowUnfocused,
                       hs.window.filter.windowMinimized, hs.window.filter.windowHidden}, function(win, appName, event)
    if not win then
        return
    end
    local title = win:title()

    if title ~= "TickTick" then
        return
    end
    hs.printf("[TickTick watcher] event=%s app=%s title=%s currentApp=%s lastObservedApp=%s", event or "<no event>",
        appName or "<no app>", title, currentApp, lastObservedApp)

    local currentApp = frontmostAppName()
    if currentApp ~= lastObservedApp then

        lastObservedApp = currentApp
        runYabai("config", "focus_follows_mouse", "autoraise")
        stopMouseWatcher()
    end
end)
lastObservedApp = frontmostAppName()
