#include "KTTRootListController.h"

@implementation KTTRootListController
- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        self.hb_appearanceSettings = appearanceSettings;
    }

    return self;
}


- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)killkakaotalk:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "KakaoTalk", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)resetprefs:(id)sender {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.peterdev.kakaotalktools"];
    [prefs removeAllObjects];

    [self respring:sender];
}

- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
@end
