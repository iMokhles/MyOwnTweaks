#import "FaceBOpenINHeader.h"


static void faceBOpenINInitPrefs() {
    NSDictionary *FaceBOpenINSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    NSNumber *FaceBOpenINEnableOptionKey = FaceBOpenINSettings[kEnablePhotos];
    enablePhotos = FaceBOpenINEnableOptionKey ? [FaceBOpenINEnableOptionKey boolValue] : 1;

}

@interface UIView (FaceBOpenIN_Tweak)
+ (UIImage *)captureView:(UIView *)view withArea:(CGRect)screenRect;
@end

@implementation UIView
+ (UIImage *)captureView:(UIView *)view withArea:(CGRect)screenRect {
	UIGraphicsBeginImageContext(screenRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
	[view.layer renderInContext:ctx];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}
@end

OBJC_EXTERN UIImage *_UICreateScreenUIImage(void) NS_RETURNS_RETAINED;


%hook FBPhotoViewController
- (void)_handleLongPress:(id)arg1 {
	UIView *imgView = self.photoView2K.photoView;
	if (enablePhotos) {
		UIImage *imageToShre = [UIView captureView:imgView withArea:imgView.bounds];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	            NSLog(@"Downloading Started");
	            // NSURL *urlToDownload = self.post.imageURLForFullSizeImage;
	            // NSURL  *url = [NSURL URLWithString:urlToDownload];
	            // NSData *urlData = [NSData dataWithContentsOfURL:urlToDownload];
	            // UIImage *imageToSave = [UIImage imageWithData:urlData];
	            NSData *pngData = UIImagePNGRepresentation(imageToShre);
	            if ( pngData ) {
	                NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	                NSString  *documentsDirectory = [paths objectAtIndex:0];
	                NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"image.png"];
	                //saving is done on main thread
	                dispatch_async(dispatch_get_main_queue(), ^{
	                    [pngData writeToFile:filePath atomically:YES];
	                    // [ProgressHUD dismiss];
	                NSLog(@"File Saved !");
	            });
	                NSURL *URL = [NSURL fileURLWithPath:filePath];
	                TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:imgView andRect:imgView.frame];
	                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
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
	            //  CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)URL.pathExtension, NULL);
	            //  NSString *UTIType = [NSString stringWithFormat:@"%@",UTI];

	            //  _OpenINController = [UIDocumentInteractionController interactionControllerWithURL:URL];
	            //  _OpenINController.delegate = self;
	            //  _OpenINController.URL = URL;
	            // _OpenINController.UTI = UTIType;
	            // [_OpenINController presentOpenInMenuFromRect:self.frame inView:self animated:YES];
	            }

	        });
	} else {
		%orig;
	} 
	
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)faceBOpenINInitPrefs, CFSTR(kPreferencesChanged), NULL, CFNotificationSuspensionBehaviorCoalesce);
    faceBOpenINInitPrefs();
}