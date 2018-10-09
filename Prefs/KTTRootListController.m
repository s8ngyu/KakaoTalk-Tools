#include "KTTRootListController.h"

bool kDarkModeSettings;

#define kSettingsIconPath	@"/Library/PreferenceBundles/KakaoTalkToolsPrefs.bundle/icon@2x.png"

//Root List
@implementation KTTRootListController

- (void)setTitle:(id)title {
	[super setTitle:title];

	UIImage *icon = [[UIImage alloc] initWithContentsOfFile:kSettingsIconPath];
	if (icon) {
		UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
		iconView.layer.cornerRadius = iconView.frame.size.height /2;
		iconView.layer.borderWidth = 0;
		self.navigationItem.titleView = iconView;
	}
}


- (instancetype)init {
    loadPrefs();
    self = [super init];

    if (self) {
      if(kDarkModeSettings) {
              HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        			appearanceSettings.navigationBarTintColor = [UIColor whiteColor];
        			appearanceSettings.navigationBarTitleColor = [UIColor whiteColor];
        			appearanceSettings.statusBarTintColor = [UIColor whiteColor];
        			appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithRed:0.24 green:0.25 blue:0.32 alpha:0];
        			appearanceSettings.translucentNavigationBar = NO;
        			appearanceSettings.tintColor = [UIColor colorWithRed:0.38 green:0.45 blue:0.64 alpha:1.0];
        			appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed:0.27 green:0.28 blue:0.35 alpha:1.0];
        			appearanceSettings.tableViewCellTextColor = [UIColor whiteColor];
        			appearanceSettings.tableViewCellBackgroundColor = [UIColor colorWithRed:0.27 green:0.28 blue:0.35 alpha:1.0];
        			appearanceSettings.tableViewCellSelectionColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.35 alpha:1.0];
        			appearanceSettings.tableViewBackgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.21 alpha:1.0];
        			self.hb_appearanceSettings = appearanceSettings;
      } else {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        appearanceSettings.tintColor = [UIColor colorWithRed:1 green:0.7569 blue:0.0275 alpha:1];
        self.hb_appearanceSettings = appearanceSettings;
      }
    }

    return self;
}


- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
    loadPrefs();
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

static void loadPrefs()
{
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.peterdev.kakaotalktools.plist"];
  if(prefs)
  {
    kDarkModeSettings = [[prefs objectForKey:@"kDarkModeSettings"] boolValue];
  }
  [prefs release];
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
