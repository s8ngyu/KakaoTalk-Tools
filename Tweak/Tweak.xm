
static BOOL kStorage = NO;          // 기본값
static BOOL kDarkKeyBoard = NO;
static BOOL kSnowFlake = NO;
static BOOL kHideGameTab = NO;
static BOOL kEnable = YES;

%hook KAODiskMonitor
- (long long)freeSpaceInBytes {    //350MB 알림 삭제
  if(kEnable)
  {
    if(kStorage)
    {
        return 256000000000;
    }
    return %orig;
  }
  return %orig;
}
%end

%hook UITextInputTraits
- (int)keyboardAppearance {         //키보드 다크모드
  if(kEnable)
  {
  if(kDarkKeyBoard)
  {
    return 1;
  }
    return %orig;
  }
  return %orig;
}
%end

%hook KakaoProperties
- (bool)isSnowFlakeAvailable {      //눈내리는 채팅방
  if(kEnable)
  {
  if(kSnowFlake)
  {
    return 1;
  }
  return %orig;
}
return %orig;
}

- (bool)isGameTabAvailable {        //게임탭 삭제
  if(kEnable)
  {
  if(kHideGameTab)
  {
    return 0;
  }
  return %orig;
}
return %orig;
}
%end

%hook KUIBackgroundView
- (bool)canShowSnowFlake {          //눈내리는 채팅방
  if(kEnable)
  {
  if(kSnowFlake)
  {
    return 1;
  }
  return %orig;
}
return %orig;
}
%end

%hook KAOSnowAccumlatingScene       //눈내리는 채팅방
- (id)touchPoint {
  if(kEnable)
  {
  if(kSnowFlake)
  {
    return %orig;
  }
  return %orig;
}
return %orig;
}

- (void)setTouchPoint:(id)arg1 {     //눈내리는 채팅방
  if(kEnable)
  {
  if(kSnowFlake)
  {
    arg1 = NULL;
    %orig;
  }
  return %orig;
}
return %orig;
}

- (double)bottomOffset {             //눈내리는 채팅방
  if(kEnable)
  {
  if(kSnowFlake)
  {
    return %orig;
  }
  return %orig;
}
return %orig;
}

- (void)setBottomOffset:(double)arg1 {//눈내리는 채팅방
  if(kEnable)
  {
  if(kSnowFlake)
  {
    arg1 = -100;
    %orig;
  }
  return %orig;
  }
return %orig;
}

%end


static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.peterdev.kakaotalktools.plist"];
    if(prefs)
    {
        kEnable = ( [prefs objectForKey:@"kEnable"] ? [[prefs objectForKey:@"kEnable"] boolValue] : kEnable );
        kStorage = ( [prefs objectForKey:@"kStorage"] ? [[prefs objectForKey:@"kStorage"] boolValue] : kStorage );
        kDarkKeyBoard = ( [prefs objectForKey:@"kDarkKeyBoard"] ? [[prefs objectForKey:@"kDarkKeyBoard"] boolValue] : kDarkKeyBoard );
        kSnowFlake = ( [prefs objectForKey:@"kSnowFlake"] ? [[prefs objectForKey:@"kSnowFlake"] boolValue] : kSnowFlake );
        kHideGameTab = ( [prefs objectForKey:@"kHideGameTab"] ? [[prefs objectForKey:@"kHideGameTab"] boolValue] : kHideGameTab );
    }
    [prefs release];
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.peterdev.kakaotalktools/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
