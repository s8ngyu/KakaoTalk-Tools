
static BOOL kStorage = NO; // Default value
static BOOL kDarkKeyBoard = NO;

%hook KAODiskMonitor
- (long long)freeSpaceInBytes {     //350MB 알림 삭제
    if(kStorage)
    {
        return 256000000000;
    }
    return %orig;
}
%end

%hook UITextInputTraits
- (int)keyboardAppearance {          //키보드 다크모드
  if(kDarkKeyBoard)
  {
    return 1;
  }
    return %orig;
}
%end

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.peterdev.kakaotalktools.plist"];
    if(prefs)
    {
        kStorage = ( [prefs objectForKey:@"kStorage"] ? [[prefs objectForKey:@"kStorage"] boolValue] : kStorage );
        kDarkKeyBoard = ( [prefs objectForKey:@"kDarkKeyBoard"] ? [[prefs objectForKey:@"kDarkKeyBoard"] boolValue] : kDarkKeyBoard );
    }
    [prefs release];
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.peterdev.kakaotalktools/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
