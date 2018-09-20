%hook KAODiskMonitor  //카카오톡 탈옥 우회시 350MB 알림 제거
- (long long)freeSpaceInBytes {
    return 256000000000;
}
%end
