#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define kPreferencesPath @"/User/Library/Preferences/com.imokhles.FBCopyTXT.plist"
#define kPreferencesChanged "com.imokhles.FBCopyTXT.preferences-changed"


#define kEnableCPTxt @"enableCPTxt"
static BOOL enableCPTxt;

@interface FBAppDelegate : NSObject <UIApplicationDelegate>
{
    int _mainThreadTimesharingDisableCount;
    BOOL _inLaunchResumeRunLoop;
    NSString *_lastMode;
}

@property(nonatomic) BOOL inLaunchResumeRunLoop; // @synthesize inLaunchResumeRunLoop=_inLaunchResumeRunLoop;
@property(retain, nonatomic) NSString *lastMode; // @synthesize lastMode=_lastMode;
- (void)fbapplication:(id)arg1 handleEventsForBackgroundURLSession:(id)arg2 completionHandler:(id)arg3;
- (void)fbApplicationDidEnterBackground:(id)arg1;
- (void)fbApplicationWillEnterForeground:(id)arg1;
- (void)fbApplicationWillResignActive:(id)arg1;
- (void)fbApplicationDidBecomeActive:(id)arg1;
- (BOOL)fbApplication:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
- (BOOL)fbApplication:(id)arg1 willFinishLaunchingWithOptions:(id)arg2;
- (void)application:(id)arg1 handleEventsForBackgroundURLSession:(id)arg2 completionHandler:(id)arg3;
- (void)applicationDidEnterBackground:(id)arg1;
- (void)applicationWillEnterForeground:(id)arg1;
- (void)applicationWillResignActive:(id)arg1;
- (void)applicationDidBecomeActive:(id)arg1;
- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
- (BOOL)application:(id)arg1 willFinishLaunchingWithOptions:(id)arg2;
- (id)backgroundTaskHandler;
- (void)endDisablingMainThreadTimesharing;
- (void)beginDisablingMainThreadTimesharing;
- (void)addThreadPriorityObserver;
- (id)init;
@property(retain, nonatomic) UIWindow *window;

@end

@interface FBFeedViewController : UIActivityViewController
@end

@interface FBFeedStoryMessageLayoutManager : NSObject {
    struct CGSize _messageSize;
    BOOL _messageIsInSubstoryScroller;
    NSAttributedString *_messageAttributedString;
}

@property(retain, nonatomic) NSAttributedString *messageAttributedString; // @synthesize messageAttributedString=_messageAttributedString;
@property(nonatomic) BOOL messageIsInSubstoryScroller; // @synthesize messageIsInSubstoryScroller=_messageIsInSubstoryScroller;
- (void)layoutSublayersOfLayer:(id)arg1;
- (struct CGSize)calculateSizeThatFitsWithConstraint:(struct CGSize)arg1 config:(id)arg2;

@end

@interface FBFeedStoryMessageLayer : UIView {
    FBFeedStoryMessageLayoutManager *_layoutManager;
    id _storyViewModel;
    id _parentStoryViewModel;
}

@property(retain, nonatomic) id parentStoryViewModel; // @synthesize parentStoryViewModel=_parentStoryViewModel;
@property(retain, nonatomic) id storyViewModel; // @synthesize storyViewModel=_storyViewModel;
@property(retain, nonatomic) FBFeedStoryMessageLayoutManager *layoutManager; // @synthesize layoutManager=_layoutManager;
- (id)accessibilityIdentifier;
- (id)accessibilityLabel;
- (void)layoutSubviews;
- (void)configure:(id)arg1;
- (void)invalidate;
- (void)dealloc;
- (id)initWithSession:(id)arg1;
@end

@interface FBFeedStoryMessageLayer (FBCopyTXT_Tweak) <UIPopoverPresentationControllerDelegate>
@end

@interface FBRichTextView : UIControl
@property(copy, nonatomic) NSAttributedString *attributedString; // @synthesize attributedString=_attributedString;
@end

@interface FBRichTextView (FBCopyTXT_Tweak) <UIPopoverPresentationControllerDelegate>
@end

@interface FBRichTextLayer : CALayer
@property(copy) NSAttributedString *attributedString;
@end

static void fbCopyTXTInitPrefs() {
    NSDictionary *FBCopyTXTSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    NSNumber *FBCopyTXTEnableOptionKey = FBCopyTXTSettings[kEnableCPTxt];
    enableCPTxt = FBCopyTXTEnableOptionKey ? [FBCopyTXTEnableOptionKey boolValue] : 1;

}

// static void killInstaOpenINProcess() {
//     system("/usr/bin/killall -9 Instagram");
    
// }
%hook FBFeedStoryMessageLayer
- (void)layoutSubviews {
	if (enableCPTxt) {
		UILongPressGestureRecognizer *longPressMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moreOptionsText:)];
		[self addGestureRecognizer:longPressMenu];
		%orig;
	} else {
		%orig;
	}
}
%new
- (void)moreOptionsText:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {

        UIWindow *mainAppWindow = [(FBAppDelegate *)[[UIApplication sharedApplication] delegate] window];
        UIActivityViewController *activController;
        activController = [[UIActivityViewController alloc] initWithActivityItems:@[self.layoutManager.messageAttributedString.string] applicationActivities:nil];
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
        // FBFeedViewController *rootController =[(%cFBFeedViewController*)[(FBAppDelegate*)[[UIApplication sharedApplication]delegate] window] rootViewController];
    }
}
%end

%hook FBRichTextView

// - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//     UIView *hitView = %orig;

//     // If the hitView is THIS view, return nil and allow hitTest:withEvent: to
//     // continue traversing the hierarchy to find the underlying view.
//     // if (hitView == self) {
//     //     return hitView;
//     // }
//     // Else return the hitView (as it could be one of this view's buttons):
//     return hitView;
// }
- (id)initWithFrame:(struct CGRect)arg1 {
    id selfOrig = %orig;
    if (selfOrig) {
        UILongPressGestureRecognizer *longPressMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moreOptionsText:)];
        [self addGestureRecognizer:longPressMenu];
    }
    return selfOrig;
}
- (void)layoutSubviews {
	// CGRect textViewFrame = CGRectMake(20.0f, 20.0f, 280.0f, 124.0f);
	// UITextView *textView = [[UITextView alloc] initWithFrame:self.frame];
	// textView.returnKeyType = UIReturnKeyDone;
	// textView.text = self.attributedString.string;
	// textView.editable = NO;
	UILongPressGestureRecognizer *longPressMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moreOptionsText:)];
	[self addGestureRecognizer:longPressMenu];
    self.userInteractionEnabled = YES;
	// [self addSubview:textView];
	%orig;
}
%new
- (void)moreOptionsText:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {

        UIWindow *mainAppWindow = [(FBAppDelegate *)[[UIApplication sharedApplication] delegate] window];
        UIActivityViewController *activController;
        activController = [[UIActivityViewController alloc] initWithActivityItems:@[self.attributedString.string] applicationActivities:nil];
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
        // FBFeedViewController *rootController =[(%cFBFeedViewController*)[(FBAppDelegate*)[[UIApplication sharedApplication]delegate] window] rootViewController];
    }
}
%end

// %hook FBRichTextLayer

// %new
// - (void)moreOptionsText:(UILongPressGestureRecognizer*)gesture {
//     if ( gesture.state == UIGestureRecognizerStateEnded ) {

//         UIWindow *mainAppWindow = [(FBAppDelegate *)[[UIApplication sharedApplication] delegate] window];
//         UIActivityViewController *activController;
//         activController = [[UIActivityViewController alloc] initWithActivityItems:@[self.attributedString.string] applicationActivities:nil];
//         if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//             UIPopoverPresentationController *presentPOP = activController.popoverPresentationController;
//             activController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
//             activController.popoverPresentationController.sourceView = self;
//             presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
//             presentPOP.delegate = self;
//             presentPOP.sourceRect = CGRectMake(700,80,0,0);
//             presentPOP.sourceView = self;
//             // openInAppActivity.superViewController = presentPOP;
//             [mainAppWindow.rootViewController presentViewController:activController animated:YES completion:NULL];
//         } else {
//             // UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.layoutManager.messageAttributedString.string] applicationActivities:nil];
//             [mainAppWindow.rootViewController presentViewController:activController animated:YES completion:NULL];
//         }
//         // FBFeedViewController *rootController =[(%cFBFeedViewController*)[(FBAppDelegate*)[[UIApplication sharedApplication]delegate] window] rootViewController];
//     }
// }
// %end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)fbCopyTXTInitPrefs, CFSTR(kPreferencesChanged), NULL, CFNotificationSuspensionBehaviorCoalesce);
    fbCopyTXTInitPrefs();
}