#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define kPreferencesPath @"/User/Library/Preferences/com.imokhles.InstaCopyTXT.plist"
#define kPreferencesChanged "com.imokhles.InstaCopyTXT.preferences-changed"


#define kEnableCPTxt @"enableCPTxt"
static BOOL enableCPTxt;

static void instaCopyTXTInitPrefs() {
    NSDictionary *InstaCopyTXTSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    NSNumber *InstaCopyTXTEnableOptionKey = InstaCopyTXTSettings[kEnableCPTxt];
    enableCPTxt = InstaCopyTXTEnableOptionKey ? [InstaCopyTXTEnableOptionKey boolValue] : 1;

}

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    BOOL _handledPushNoteInDidFinishLaunching;
    UIWindow *_window;
}

@property(nonatomic) BOOL handledPushNoteInDidFinishLaunching; // @synthesize handledPushNoteInDidFinishLaunching=_handledPushNoteInDidFinishLaunching;
@property(retain, nonatomic) UIWindow *window; // @synthesize window=_window;
- (void)registerForPush;
- (BOOL)application:(id)arg1 openURL:(id)arg2 sourceApplication:(id)arg3 annotation:(id)arg4;
- (BOOL)application:(id)arg1 handleOpenURL:(id)arg2;
- (void)userLogout:(id)arg1;
- (void)userLoginCompleted:(id)arg1;
- (void)startMainAppWithMainFeedSource:(id)arg1 animated:(BOOL)arg2;
- (void)setUpInstagramNotifications;
- (void)setUpDefaults;
- (void)applicationLifecycleChange:(id)arg1;
- (void)applicationWillTerminate:(id)arg1;
- (void)applicationDidEnterBackground:(id)arg1;
- (void)applicationDidBecomeActive:(id)arg1;
- (void)applicationWillEnterForeground:(id)arg1;
- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
@end

@interface IGStyledString : NSObject {
    NSMutableDictionary *_heightCache;
    NSMutableAttributedString *_attributedString;
}
+ (id)createWithCacheKey:(id)arg1 creationBlock:(id)arg2;
@property(retain, nonatomic) NSMutableAttributedString *attributedString; // @synthesize attributedString=_attributedString;
- (int)heightForWidth:(int)arg1;
- (void)applyBaseStyleToAttributedString:(id)arg1;
- (void)appendAnnotatedString:(id)arg1;
- (void)appendAttributedString:(id)arg1;
- (void)appendString:(id)arg1;
- (id)initWithBaseStyle:(id)arg1;
- (id)init;
- (void)appendLinkedTitleString:(id)arg1;
- (void)appendLinkedString:(id)arg1;

@end

@interface IGCoreTextView : UIView
{
    UIColor *_shadowColor;
    float _shadowOffset;
    BOOL _heightIsValid;
    struct CGPoint _touchPoint;
    BOOL _longTapHandled;
    IGStyledString *_styledString;
}

@property(retain, nonatomic) IGStyledString *styledString; // @synthesize styledString=_styledString;
- (void)drawRect:(struct CGRect)arg1;
- (BOOL)handleTapAtIndex:(int)arg1 forTouchEvent:(unsigned int)arg2 fromLongTap:(BOOL)arg3;
- (BOOL)handleTapAtIndex:(int)arg1 forTouchEvent:(unsigned int)arg2;
- (BOOL)handleTapAtPoint:(struct CGPoint)arg1 forTouchEvent:(unsigned int)arg2 fromLongTap:(BOOL)arg3;
- (BOOL)handleTapAtPoint:(struct CGPoint)arg1 forTouchEvent:(unsigned int)arg2;
- (void)handleLongTap;
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;
- (void)touchesCancelled:(id)arg1 withEvent:(id)arg2;
- (void)touchesBegan:(id)arg1 withEvent:(id)arg2;
- (float)height;
- (void)setFrame:(struct CGRect)arg1;
- (id)initWithWidth:(float)arg1;
@end

@interface IGCoreTextView (InstaCopyTXT_Tweak) <UIPopoverPresentationControllerDelegate>
@end

%hook IGCoreTextView
- (void)layoutSubviews {
	if (enableCPTxt) {
		UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    	[doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    	[self addGestureRecognizer:doubleTapGestureRecognizer];
    
    	// UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    	// [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    	// // Wait for failed doubleTapGestureRecognizer
    	// [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    	// [self addGestureRecognizer:singleTapGestureRecognizer];
	}
	%orig;
}
%new
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    // Insert your own code to handle doubletap
    UIWindow *mainAppWindow = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
        UIActivityViewController *activController;
        activController = [[UIActivityViewController alloc] initWithActivityItems:@[self.styledString.attributedString.string] applicationActivities:nil];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            UIPopoverPresentationController *presentPOP = activController.popoverPresentationController;
            activController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
            activController.popoverPresentationController.sourceView = self;
            presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
            presentPOP.delegate = self;
            presentPOP.sourceRect = CGRectMake(700,80,0,0);
            presentPOP.sourceView = self;
            // openInAppActivity.superViewController = presentPOP;
            [mainAppWindow.rootViewController presentViewController:activController animated:YES completion:NULL];
        } else {
            // UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.layoutManager.messageAttributedString.string] applicationActivities:nil];
            [mainAppWindow.rootViewController presentViewController:activController animated:YES completion:NULL];
        }
}

// %new
// - (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
//     // Insert your own code to handle singletap
//     [myButton removeFromSuperview];
//     [tabBarView setHidden:YES];
//     %orig;
// }
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)instaCopyTXTInitPrefs, CFSTR(kPreferencesChanged), NULL, CFNotificationSuspensionBehaviorCoalesce);
    instaCopyTXTInitPrefs();
}