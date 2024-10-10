on get_res()
    tell application "Finder"
        set screen_resolution to bounds of window of desktop
    end tell
    log screen_resolution
    return screen_resolution
end get_res

on activate(appName)
    -- Get the number of windows
    tell application "System Events"
        tell process appName
            set windowCount to count windows
        end tell
    end tell

    -- Open a window if there aren't any currently, and activate the app
    tell application appName
        if windowCount = 0 then
            reopen
        end if
        activate
    end tell
end activate

on minify(appName)
--on run {appName}
    set screenRes to get_res()

    activate(appName)
    
    -- Minify the app
    tell application "System Events"
        tell process appName
            tell window 1
                set level to 3
                set size to {800, 500}
                set position to {24, (item 4 of screenRes) - 500 - 24}
            end tell
        end tell
    end tell
    --set appWindow to current application's window 1
    --set appWindow's hidesOnDeactivate to true
--end run
end minify
