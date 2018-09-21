
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

//%hook KakaoProperties                //눈내리는 채팅방
//- (bool)isSnowFlakeAvailable {
//  if(kSnowFlake)
//  {
//    return 1;
//  }
//    return %orig;
//}
//%end

//%hook KUIBackgroundView              //눈내리는 채팅방
//- (bool)canShowSnowFlake {
//  if(kSnowFlake)
//  {
//    return 1;
//  }
//    return %orig;
//}
//%end

//%hook KAOSnowAccumlatingScene        //눈내리는 채팅방
//- (id)touchPoint {
//  if(kSnowFlake)
//  {
//    return %orig;
//  }
//}
//%end

//%hook KAOSnowAccumlatingScene        //눈내리는 채팅방
//- (void)setTouchPoint:(id)arg1 {
//  if(kSnowFlake)
//  {
//    arg1 = NULL;
//    %orig;
//  }
//    return %orig;
//}
//%end

//%hook KAOSnowAccumlatingScene        //눈내리는 채팅방
//- (double)bottomOffset {
//  if(kSnowFlake)
//  {
//    return %orig;
//  }
//}
//%end

//%hook KAOSnowAccumlatingScene        //눈내리는 채팅방
//- (void)setBottomOffset:(double)arg1 {
//  if(kSnowFlake)
//  {
//    arg1 = -100;
//    %orig;
//  }
//    return %orig;
//}
//%end

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.peterdev.kakaotalktools.plist"];
    if(prefs)
    {
        kStorage = ( [prefs objectForKey:@"kStorage"] ? [[prefs objectForKey:@"kStorage"] boolValue] : kStorage );
        kDarkKeyBoard = ( [prefs objectForKey:@"kDarkKeyBoard"] ? [[prefs objectForKey:@"kDarkKeyBoard"] boolValue] : kDarkKeyBoard );
//        kSnowFlake = ( [prefs objectForKey:@"kSnowFlake"] ? [[prefs objectForKey:@"kSnowFlake"] boolValue] : kSnowFlake );
    }
    [prefs release];
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.peterdev.kakaotalktools/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
