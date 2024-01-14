local themeWatcher = hs.distributednotifications.new(function(_, _, _)
    os.execute(os.getenv('HOME') .. '/.config/kitty/sync-theme')
end, 'AppleInterfaceThemeChangedNotification')
themeWatcher:start()
