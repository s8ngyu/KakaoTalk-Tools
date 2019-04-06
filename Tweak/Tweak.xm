#import <substrate.h>
#include <sys/stat.h>	//탈옥감지 우회 기능구현 필수 헤더 

bool kEnable;
bool kBypassJB;	//탈옥감지 우회 기능 추가
bool kStorage;
bool kDarkKeyBoard;
bool kSnowFlake;
bool kHideGameTab;
bool kHideSharpSearch;
bool kHideBirthdayFriends;
bool kMakeItRounds;

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

/*여기서부터 탈옥감지 우회 기능 시작! */
/*** KakaoTalk v8.3.2 ***/
/** Framework: org.cocoapods.Kakaopay **/
/* bool __cdecl +[PayAppIntegrityInternal isExistPath:](PayAppIntegrityInternal_meta *self, SEL a2, id a3) */
/* bool __cdecl +[PayAppIntegrityInternal isSafeByXFiles](PayAppIntegrityInternal_meta *self, SEL a2) */
/* bool __cdecl +[PayAppIntegrityInternal isExistLink:](PayAppIntegrityInternal_meta *self, SEL a2, id a3) */
/* bool __cdecl +[PayAppIntegrityInternal isSafeByXLinks](PayAppIntegrityInternal_meta *self, SEL a2) */
/* bool __cdecl +[PayAppIntegrityInternal isSafeByXWriting](PayAppIntegrityInternal_meta *self, SEL a2) */
/* bool __cdecl +[PayAppIntegrityInternal isSafeByXFork](PayAppIntegrityInternal_meta *self, SEL a2) */
%hook NSString 
- (BOOL)writeToFile:(NSString *)path  {
	if(kEnable && kBypassJB) {
		if([path isEqualToString:@"/private/test_ks.txt"]) {
					return NO;
				}
				else {
					return %orig;
					}
				}
  	return %orig;
}
%end

%hook NSFileManager
- (BOOL)removeItemAtPath:(NSString *)path {
	if(kEnable && kBypassJB) {
		if([path isEqualToString:@"/private/test_ks.txt"]) {
					return NO;
				} 
				else {
					return %orig;
					}
				}
  	return %orig;
}
%end

static int (*orig_stat)(const char * file_name, struct stat *buf);
int new_stat(const char * file_name, struct stat *buf) {
    if (strcmp(file_name, "/bin/bash") == 0 || strcmp(file_name, "/usr/sbin/sshd") == 0 || strcmp(file_name, "/Applications/Cydia.app") == 0 || strcmp(file_name, "/private/var/lib/apt") == 0 || strcmp(file_name, "/pangueaxe") == 0 || strcmp(file_name, "/System/Library/LaunchDaemons/io.pangu.axe.untether.plist") == 0 || strcmp(file_name, "/Library/MobileSubstrate/MobileSubstrate.dylib") == 0 || strcmp(file_name, "/usr/libexec/sftp-server") == 0 || strcmp(file_name, "/private/var/stash") == 0) {  
        return -1;
    }
    return orig_stat(file_name, buf);
}

static int (*orig_lstat)(const char *path, struct stat *buf);
int new_lstat(const char *path, struct stat *buf) {
    if (strcmp(path, "/Library/Ringtones") == 0 || strcmp(path, "/Library/Wallpaper") == 0 || strcmp(path, "/usr/arm-apple-darwin9") == 0 || strcmp(path, "/usr/include") == 0 || strcmp(path, "/usr/libexec") == 0 || strcmp(path, "/usr/share") == 0 || strcmp(path, "/Applications") == 0) {
        return -1;
    }
    return orig_lstat(path, buf);
}

MSHook(pid_t, fork) {
    return -1;
}

/*여기까지가 탈옥감지 우회 기능 끝... %ctor 참고 바람 */

%hook KAODiskMonitor
- (long long)freeSpaceInBytes {   // 저장공간 알림 제거
  if(kEnable && kStorage) {
    return 256000000000;
  }
  return %orig;
}
%end

%group DM
%hook KAODM
- (long long)freeSpaceInBytes {   // 8.3.0 이후 다운로드 관련 문제 해결
  if(kEnable && kStorage) {
    return 256000000000;
  }
  return %orig;
}
-(void)requestUserNotificationIfRestrictionWarningNeeded {   // 8.3.0 이후 저장공간 알림 제거
  if(!(kEnable && kStorage)) {
    %orig;
  }
}
%end
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

%group PIV
%hook SquircleProfileImageView
- (void)layoutSubviews {
  if (kEnable & kMakeItRounds) {
    #define self ((UIView*) self)
  %orig;
  if (self.frame.size.width == 58 & self.frame.size.height == 58) {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 30;
  }

  if (self.frame.size.width == 50 & self.frame.size.height == 50) {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 25;
  }

  if (self.frame.size.width == 41 & self.frame.size.height == 41) {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 20;
  }

  if (self.frame.size.width == 34 & self.frame.size.height == 34) {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 17;
  }
  #undef self
  } else {
    %orig;
  }
}
%end

%hook UIImageView
- (void)layoutSubviews {
  if (kEnable & kMakeItRounds) {
    if (self.frame.size.width == 24 & self.frame.size.height == 24) {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 12;
    }

    if (self.frame.size.width == 100 & self.frame.size.height == 100) {
      self.layer.cornerRadius = 50;
    }
  } else {
  %orig;
  }
}
%end
%end

static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.peterdev.kakaotalktools.plist"];
  if(prefs)
  {
    kEnable = [[prefs objectForKey:@"kEnable"] boolValue];
    kBypassJB = [[prefs objectForKey:@"kBypassJB"] boolValue];
    kStorage = [[prefs objectForKey:@"kStorage"] boolValue];
    kDarkKeyBoard = [[prefs objectForKey:@"kDarkKeyBoard"] boolValue];
    kSnowFlake = [[prefs objectForKey:@"kSnowFlake"] boolValue];
    kHideGameTab = [[prefs objectForKey:@"kHideGameTab"] boolValue];
    kHideSharpSearch = [[prefs objectForKey:@"kHideSharpSearch"] boolValue];
    kHideBirthdayFriends = [[prefs objectForKey:@"kHideBirthdayFriends"] boolValue];
    kMakeItRounds = [[prefs objectForKey:@"kMakeItRounds"] boolValue];
  }
  [prefs release];
}

%ctor {
  %init;
  %init(PIV, SquircleProfileImageView = objc_getClass("TalkAppBase.SquircleProfileImageView"));
  %init(DM, KAODM = objc_getClass("TalkAppBase.DiskMonitor"));
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.peterdev.kakaotalktools/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
	if(kEnable && kBypassJB) {
			MSHookFunction((void *)stat, (void *)new_stat, (void **)&orig_stat);
			MSHookFunction((void *)lstat, (void *)new_lstat, (void **)&orig_lstat);
			MSHookFunction(fork, MSHake(fork));
	}
}
