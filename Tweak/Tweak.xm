bool kEnable;
bool kStorage;
bool kDarkKeyBoard;
bool kSnowFlake;
bool kHideGameTab;
bool kHideSharpSearch;
bool kHideBirthdayFriends;

%hook TalkAppDelegate               //DRM
-(void)applicationDidBecomeActive:(id)arg1 {
if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.peterdev.kakaotalktools.list"])      //패키지 검사
{
  %orig;
}
else
{
  %orig;
  UIAlertView *drmalert = [[UIAlertView alloc]initWithTitle:@"KakaoTalk Tools" message:@"You're using pirate version of KakaoTalk Tools, Use the Official version" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];

  [drmalert show];                //DRM메시지 보이기
}
}
%end

%hook KAODiskMonitor
- (long long)freeSpaceInBytes {   // 저장공간 알림 제거
  if(kEnable && kStorage) {
    return 256000000000;
  }
  return %orig;
}
%end

%hook UITextInputTraits
- (int)keyboardAppearance {         //키보드 다크모드
  if(kEnable && kDarkKeyBoard) {
    return 1;
  }
  return %orig;
}
%end

%hook KakaoProperties
- (bool)isSnowFlakeAvailable {      //눈내리는 채팅방
  if(kEnable && kSnowFlake) {
    return 1;
  }
  return %orig;
}

- (bool)isGameTabAvailable {        //게임탭 삭제
  if(kEnable && kHideGameTab) {
    return 0;
  }
  return %orig;
}

- (bool)isSharpSearchAvailable {      //샵검색 삭제
  if(kEnable && kHideSharpSearch) {
    return 0;
  }
  return %orig;
}

- (bool)showBirthdayFriends {       //생일친구 삭제
  if(kEnable && kHideBirthdayFriends) {
    return 0;
  }
  return %orig;
}
%end

%hook KUIBackgroundView
- (bool)canShowSnowFlake {          //눈내리는 채팅방
  if(kEnable && kSnowFlake) {
    return 1;
  }
  return %orig;
}
%end

%hook KAOSnowAccumlatingScene       //눈내리는 채팅방
- (id)touchPoint {
  if(kEnable && kSnowFlake) {
    return %orig;
  }
  return %orig;
}

- (void)setTouchPoint:(id)arg1 {     //눈내리는 채팅방
  if(kEnable && kSnowFlake)
  {
    arg1 = NULL;
    %orig;
  }
  return %orig;
}

- (double)bottomOffset {             //눈내리는 채팅방
  if(kEnable && kSnowFlake)
  {
    return %orig;
  }
  return %orig;
}

- (void)setBottomOffset:(double)arg1 {//눈내리는 채팅방
  if(kEnable && kSnowFlake)
  {
    arg1 = -100;
    %orig;
  }
  return %orig;
}
%end

static void loadPrefs()
{
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.peterdev.kakaotalktools.plist"];
  if(prefs)
  {
    kEnable = [[prefs objectForKey:@"kEnable"] boolValue];
    kStorage = [[prefs objectForKey:@"kStorage"] boolValue];
    kDarkKeyBoard = [[prefs objectForKey:@"kDarkKeyBoard"] boolValue];
    kSnowFlake = [[prefs objectForKey:@"kSnowFlake"] boolValue];
    kHideGameTab = [[prefs objectForKey:@"kHideGameTab"] boolValue];
    kHideSharpSearch = [[prefs objectForKey:@"kHideSharpSearch"] boolValue];
    kHideBirthdayFriends = [[prefs objectForKey:@"kHideBirthdayFriends"] boolValue];
  }
  [prefs release];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.peterdev.kakaotalktools/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}
