#include "KTTRootListController.h"

//Root List
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


//About List
@interface KTTAboutListController : HBRootListController
@end

//Features List
@interface KTTFeaturesListController : HBRootListController
@end

//About
@implementation KTTAboutListController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"About" target:self] retain];
    }

    return _specifiers;
}
@end

//Features List
@implementation KTTFeaturesListController
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Features" target:self] retain];
    }

    return _specifiers;
}
- (void)killkakaotalk:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "KakaoTalk", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}


- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
@end
