#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TTOpenInAppActivity.h"

#define kPreferencesPath @"/User/Library/Preferences/com.imokhles.BBMOpenIN.plist"
#define kPreferencesChanged "com.imokhles.BBMOpenIN.preferences-changed"


#define kEnablePhotos @"enablePhotos"

static BOOL enablePhotos;

static void BBMOpenINInitPrefs() {
    NSDictionary *BBMOpenINSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    NSNumber *BBMOpenINEnableOptionKey = BBMOpenINSettings[kEnablePhotos];
    enablePhotos = BBMOpenINEnableOptionKey ? [BBMOpenINEnableOptionKey boolValue] : 1;

}
@interface BBMPictureController : UIViewController //<BBMTabBarDelegate, BBMAssetPickerDelegate, BBMRightMenuDelegate, BBMChannelsViewControllerCommon, UIScrollViewDelegate>
{
    BOOL isObservingUserAvatar;
    UIActivityViewController *_activityController;
    BOOL _isCurrentUserAvatar;
    UIImageView *_theImageView;
    UIImage *_picture;
    NSString *_pictureURL;
    NSString *_fileName;
    UIScrollView *_scrollView;
    NSString *_thirdPartyImagePath;
    NSString *_channelUri;
    NSString *_postIdentifier;
}

@property(retain, nonatomic) NSString *postIdentifier; // @synthesize postIdentifier=_postIdentifier;
@property(retain, nonatomic) NSString *channelUri; // @synthesize channelUri=_channelUri;
@property BOOL isCurrentUserAvatar; // @synthesize isCurrentUserAvatar=_isCurrentUserAvatar;
@property(retain) NSString *thirdPartyImagePath; // @synthesize thirdPartyImagePath=_thirdPartyImagePath;
// @property(nonatomic) __weak UIScrollView *scrollView; // @synthesize scrollView=_scrollView;
@property(retain) NSString *fileName; // @synthesize fileName=_fileName;
@property(copy, nonatomic) NSString *pictureURL; // @synthesize pictureURL=_pictureURL;
@property(retain) UIImage *picture; // @synthesize picture=_picture;
// @property(nonatomic) __weak UIImageView *theImageView; // @synthesize theImageView=_theImageView;
- (BOOL)isViewControllerForChannelUri:(id)arg1 andPostIdentifier:(id)arg2;
- (BOOL)isViewControllerForChannelUri:(id)arg1;
- (void)selectedMenuItem:(int)arg1;
- (void)addSidebarItems;
- (void)tabBarItemSelected:(int)arg1 selectedItem:(id)arg2;
- (void)assetWasPicked:(id)arg1;
- (void)showAvatarPicker;
- (void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void *)arg4;
- (void)share;
- (void)viewWillDisappear:(BOOL)arg1;
- (void)updateAvatarImage;
- (void)viewWillAppear:(BOOL)arg1;
- (void)didRotateFromInterfaceOrientation:(int)arg1;
- (void)willRotateToInterfaceOrientation:(int)arg1 duration:(double)arg2;
- (void)close;
- (void)swipeBack:(id)arg1;
- (void)addTabBar;
- (void)toggleBars:(id)arg1;
- (void)addGestures;
- (void)setupNavbar;
- (id)viewForZoomingInScrollView:(id)arg1;
- (void)viewDidLoad;

@end

@interface BBMPictureController (BBMOpenIN_Tweak) <UIPopoverPresentationControllerDelegate>
@end

%hook BBMPictureController
- (void)share {
	if (enablePhotos) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	            NSLog(@"Downloading Started");
	                TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
	                UIActivityViewController *activityViewController;
	                NSURL *URL;
	                if (self.pictureURL == nil) {
	                		NSData *pngData = UIImagePNGRepresentation(self.picture);
	                		NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			                NSString  *documentsDirectory = [paths objectAtIndex:0];
			                NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"image.png"];
			                //saving is done on main thread
			                dispatch_async(dispatch_get_main_queue(), ^{
			                    [pngData writeToFile:filePath atomically:YES];
			                    // [ProgressHUD dismiss];
			                		NSLog(@"File Saved !");
			            		});
	                		URL = [NSURL fileURLWithPath:filePath];
	                		activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
	                } else {
	                		URL = [NSURL fileURLWithPath:self.pictureURL];
	                		activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
	                }
	                // [SVProgressHUD showSuccessWithStatus:@"Success!"];
	                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
	                    // Store reference to superview (UIActionSheet) to allow dismissal
	                    openInAppActivity.superViewController = activityViewController;
	                    // Show UIActivityViewController
	                    [self presentViewController:activityViewController animated:YES completion:NULL];
	                } else {
	                    // Create pop up
	                    UIPopoverPresentationController *presentPOP = activityViewController.popoverPresentationController;
			            activityViewController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
			            activityViewController.popoverPresentationController.sourceView = self.view;
			            presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
			            presentPOP.delegate = self;
			            presentPOP.sourceRect = CGRectMake(700,80,0,0);
			            presentPOP.sourceView = self.view;
			            openInAppActivity.superViewController = presentPOP;
			            [self presentViewController:activityViewController animated:YES completion:NULL];

	                    // activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
	                    // // Store reference to superview (UIPopoverController) to allow dismissal
	                    // openInAppActivity.superViewController = activityPopoverController;
	                    // // Show UIActivityViewController in popup
	                    // [activityPopoverController presentPopoverFromRect:imgView.frame inView:imgView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	                }

	        });
	} else {
		%orig;
	}
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)BBMOpenINInitPrefs, CFSTR(kPreferencesChanged), NULL, CFNotificationSuspensionBehaviorCoalesce);
    BBMOpenINInitPrefs();
}