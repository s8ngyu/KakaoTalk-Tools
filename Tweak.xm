#define PLIST_PATH @"/var/mobile/Library/Preferences/KakaoTalkToolsPrefs.plist" //plist of preference bundle

inline bool GetPrefBool(NSString *key)
{
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}


//Start Class
%hook KAODiskMonitor               //카카오톡 디스크 모니터 후크
- (long long)freeSpaceInBytes {    //카카오톡 탈옥 우회시 350MB 알림 제거
  if(GetPrefBool(@"kStorage")){    //kStorage를 받으면 작동
    return 256000000000;
  }
    return %orig;
  }
%end
