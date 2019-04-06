#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>


@interface KTTRootListController : HBRootListController
    - (void)killkakaotalk:(id)sender;
    - (void)respring:(id)sender;
    - (void)resetprefs:(id)sender;
@end
