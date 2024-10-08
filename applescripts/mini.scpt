set targetApp to "Arc"
set screenRes to get_res()
tell application targetApp to activate
tell application "System Events"
  tell process "Arc" 
    tell window 1
      set level to 3
      set size to {800, 500}
      set position to {24, item 4 of screenRes - 500 - 24}

      --set hides when deactivated to false
    end tell
  end tell
end tell

on get_res()
  tell application "Finder"
    set screen_resolution to bounds of window of desktop
  end tell
  log screen_resolution
  return screen_resolution
end get_res
