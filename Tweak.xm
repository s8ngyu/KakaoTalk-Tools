static BOOL Storage = NO; // Default value

%hook KAODiskMonitor
- (long long)freeSpaceInBytes {
    if(Storage)
    {
        return 256000000000;
    }
    return %orig;
}
%end

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.peterdev.kakaotalktools.plist"];
    if(prefs)
    {
        Storage = ( [prefs objectForKey:@"kStorage"] ? [[prefs objectForKey:@"kStorage"] boolValue] : Storage );
    }
    [prefs release];
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.peterdev.kakaotalktools/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
