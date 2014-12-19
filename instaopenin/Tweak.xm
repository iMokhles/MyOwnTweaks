#import "InstaOpenINHeader.h"
#import <substrate.h>
#import "AESCrypt.h"
#import "NSString+UAObfuscatedString.h"
#import "SVProgressHUD.h"

static UIDocumentInteractionController *_OpenINController = nil;
static float progress = 0.0f;

static void instaOpenINInitPrefs() {
    NSDictionary *InstaOpenINSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    NSNumber *InstaOpenINEnableOptionKey = InstaOpenINSettings[kEnablePhotos];
    enablePhotos = InstaOpenINEnableOptionKey ? [InstaOpenINEnableOptionKey boolValue] : 1;

    NSNumber *InstaOpenINVideosOptionKey = InstaOpenINSettings[kEnableVideos];
    enableVideos = InstaOpenINVideosOptionKey ? [InstaOpenINVideosOptionKey boolValue] : 1;

    // //
    // NSString *THIS = @"".forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.a.p.t.forward_slash.l.i.s.t.s.forward_slash.c.y.d.i.a.dot.a.r.a.b.i.a.n.c.y.d.i.a.dot.c.o.m.underscore.dot.underscore.P.a.c.k.a.g.e.s;
    // NSString *thisISIT = @"miNuIyqfufcces/PBO2UVoKL42dCtuL4ntEZvPeTkd81QBzJiyuK3SMnqizfj95hV8EgpySek2cORtULYXXUAA==";
    // NSString *thisISIT2 = @"XIQ4tx2MuWaluCkQu8LkIPLG61/jShIwUBAQ/RaoaUXuwGqD0nyZDTBzpmjwohgw";
    // NSString *idDone = [AESCrypt decrypt:thisISIT password:@"64132138"];
    // NSString *idDone2 = [AESCrypt decrypt:thisISIT2 password:@"64132138"];
    // BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:THIS];
    // BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:idDone2];
    // if (fileExists || !fileExists2) {
    //     [[NSFileManager defaultManager] removeItemAtPath:idDone error:nil];
    //     // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WAEnhancer Checker" message:@"ops sorry :'(" delegate:nil cancelButtonTitle:@"OK :)" otherButtonTitles:nil, nil];
    //     //                 [alertView show];
    // }
}

static void killInstaOpenINProcess() {
    system("/usr/bin/killall -9 Instagram");
    
}

%hook IGFeedItemPhotoCell
- (void)layoutSubviews {
	if (enablePhotos) {
		UILongPressGestureRecognizer *longPressMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSaveImage:)];
		[self addGestureRecognizer:longPressMenu];
		%orig;
	} else {
		%orig;
	}
}
%new
- (void)longPressSaveImage:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {

    	// [ProgressHUD show:@"Preparing Image"];
   //       NSURL *imageURL = self.post.imageURLForFullSizeImage;
   //       NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
   //       UIImage *imageToSave = [UIImage imageWithData:imageData];
   //       NSData *pngData = UIImagePNGRepresentation(imageToSave);
   //       NSString *documentsPath = @"/var/mobile/Library/InstaOpenIN/"; //Get the docs directory 
		 // NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
		 // [pngData writeToFile:filePath atomically:YES]; //Write the file

   //       NSURL *URL = [NSURL fileURLWithPath:filePath];
   //       CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)URL.pathExtension, NULL);
   //       NSString *UTIType = [NSString stringWithFormat:@"%@",UTI];

   //       _OpenINController = [UIDocumentInteractionController interactionControllerWithURL:URL];
   //       _OpenINController.URL = URL;
   //      _OpenINController.UTI = UTIType;
   //      [SVProgressHUD dismiss];
   //      [_OpenINController presentOpenInMenuFromRect:self.frame inView:self animated:YES];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Downloading Started");
            NSURL *urlToDownload = self.post.imageURLForFullSizeImage;
            // NSURL  *url = [NSURL URLWithString:urlToDownload];
            NSData *urlData = [NSData dataWithContentsOfURL:urlToDownload];
            UIImage *imageToSave = [UIImage imageWithData:urlData];
            NSData *pngData = UIImagePNGRepresentation(imageToSave);
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
                TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self andRect:self.frame];
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
                // [SVProgressHUD showSuccessWithStatus:@"Success!"];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                    // Store reference to superview (UIActionSheet) to allow dismissal
                    openInAppActivity.superViewController = activityViewController;
                    // Show UIActivityViewController
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:NULL];
                } else {
                    // Create pop up
                    activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
                    // Store reference to superview (UIPopoverController) to allow dismissal
                    openInAppActivity.superViewController = activityPopoverController;
                    // Show UIActivityViewController in popup
                    [activityPopoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
		// TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self andRect:self.frame];
		// UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
		// [SVProgressHUD showSuccessWithStatus:@"Success!"];
		// if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		//     // Store reference to superview (UIActionSheet) to allow dismissal
		//     openInAppActivity.superViewController = activityViewController;
		//     // Show UIActivityViewController
		//     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:NULL];
		// } else {
		//     // Create pop up
		//     activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
		//     // Store reference to superview (UIPopoverController) to allow dismissal
		//     openInAppActivity.superViewController = activityPopoverController;
		//     // Show UIActivityViewController in popup
		//     [activityPopoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		// }

    }
}
%new
- (void) documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    system("/usr/bin/killall -9 Instagram");
}
%end

%hook IGFeedItemVideoCell
- (void)layoutSubviews {
	if (enableVideos) {
		UILongPressGestureRecognizer *longPressMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSaveVideo:)];
		[self addGestureRecognizer:longPressMenu];
		%orig;
	} else {
		%orig;
	}
}
%new
- (void)longPressSaveVideo:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        // [ProgressHUD show:@"Preparing Video"];
    	NSInteger videoVersion = [%c(IGPost) videoVersionForCurrentNetworkConditions];
  //       NSURL *videoURL = [self.post videoURLForVideoVersion:videoVersion];
  //       NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
  //       NSString *documentsPath = @"/var/mobile/Library/InstaOpenIN/"; //Get the docs directory 
		// NSString *filePath = [documentsPath stringByAppendingPathComponent:@"video.mp4"]; //Add the file name
		// [videoData writeToFile:filePath atomically:YES]; //Write the file

        //download the file in a seperate thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        NSURL *urlToDownload = [self.post videoURLForVideoVersion:videoVersion];
        // NSURL  *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:urlToDownload];
        if ( urlData ) {
            NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"video.mp4"];
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                // [ProgressHUD dismiss];
                NSLog(@"File Saved !");
            });
            NSURL *URL = [NSURL fileURLWithPath:filePath];
            TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self andRect:self.frame];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
            // [SVProgressHUD showSuccessWithStatus:@"Success!"];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                // Store reference to superview (UIActionSheet) to allow dismissal
                openInAppActivity.superViewController = activityViewController;
                // Show UIActivityViewController
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:NULL];
            } else {
                // Create pop up
                activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
                // Store reference to superview (UIPopoverController) to allow dismissal
                openInAppActivity.superViewController = activityPopoverController;
                // Show UIActivityViewController in popup
                [activityPopoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
		// TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self andRect:self.frame];
		// UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
		// [SVProgressHUD showSuccessWithStatus:@"Success!"];
		// if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		//     // Store reference to superview (UIActionSheet) to allow dismissal
		//     openInAppActivity.superViewController = activityViewController;
		//     // Show UIActivityViewController
		//     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:NULL];
		// } else {
		//     // Create pop up
		//     activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
		//     // Store reference to superview (UIPopoverController) to allow dismissal
		//     openInAppActivity.superViewController = activityPopoverController;
		//     // Show UIActivityViewController in popup
		//     [activityPopoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		// }

    }
}
%new
- (void) documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    system("/usr/bin/killall -9 Instagram");
}
%end

%hook IGFeedItemPhotoView
- (id)initWithFrame:(struct CGRect)arg1 {
    id selfOrig = %orig;
    if (selfOrig) {
        if (enablePhotos) {
            UILongPressGestureRecognizer *longPressMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSaveImage:)];
            [self addGestureRecognizer:longPressMenu];
            return selfOrig;
        } else {
            return selfOrig;
        }
    }
    return selfOrig;
}
%new
- (void)longPressSaveImage:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {

        // [ProgressHUD show:@"Preparing Image"];
   //       NSURL *imageURL = self.post.imageURLForFullSizeImage;
   //       NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
   //       UIImage *imageToSave = [UIImage imageWithData:imageData];
   //       NSData *pngData = UIImagePNGRepresentation(imageToSave);
   //       NSString *documentsPath = @"/var/mobile/Library/InstaOpenIN/"; //Get the docs directory 
         // NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
         // [pngData writeToFile:filePath atomically:YES]; //Write the file

   //       NSURL *URL = [NSURL fileURLWithPath:filePath];
   //       CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)URL.pathExtension, NULL);
   //       NSString *UTIType = [NSString stringWithFormat:@"%@",UTI];

   //       _OpenINController = [UIDocumentInteractionController interactionControllerWithURL:URL];
   //       _OpenINController.URL = URL;
   //      _OpenINController.UTI = UTIType;
   //      [SVProgressHUD dismiss];
   //      [_OpenINController presentOpenInMenuFromRect:self.frame inView:self animated:YES];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Downloading Started");
            NSURL *urlToDownload = self.post.imageURLForFullSizeImage;
            // NSURL  *url = [NSURL URLWithString:urlToDownload];
            NSData *urlData = [NSData dataWithContentsOfURL:urlToDownload];
            UIImage *imageToSave = [UIImage imageWithData:urlData];
            NSData *pngData = UIImagePNGRepresentation(imageToSave);
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
                TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self andRect:self.frame];
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
                // [SVProgressHUD showSuccessWithStatus:@"Success!"];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                    // Store reference to superview (UIActionSheet) to allow dismissal
                    openInAppActivity.superViewController = activityViewController;
                    // Show UIActivityViewController
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:NULL];
                } else {
                    // Create pop up
                    activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
                    // Store reference to superview (UIPopoverController) to allow dismissal
                    openInAppActivity.superViewController = activityPopoverController;
                    // Show UIActivityViewController in popup
                    [activityPopoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
        // TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self andRect:self.frame];
        // UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
        // [SVProgressHUD showSuccessWithStatus:@"Success!"];
        // if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        //     // Store reference to superview (UIActionSheet) to allow dismissal
        //     openInAppActivity.superViewController = activityViewController;
        //     // Show UIActivityViewController
        //     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:NULL];
        // } else {
        //     // Create pop up
        //     activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        //     // Store reference to superview (UIPopoverController) to allow dismissal
        //     openInAppActivity.superViewController = activityPopoverController;
        //     // Show UIActivityViewController in popup
        //     [activityPopoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        // }

    }
}
%new
- (void) documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    system("/usr/bin/killall -9 Instagram");
}
%end

%hook IGFeedItemVideoView
- (id)initWithFrame:(struct CGRect)arg1 {
    id selfOrig = %orig;
    if (selfOrig) {
        if (enableVideos) {
            UILongPressGestureRecognizer *longPressMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSaveVideo:)];
            [self addGestureRecognizer:longPressMenu];
            return selfOrig;
        } else {
            return selfOrig;
        }
    }
    return selfOrig;
}
%new
- (void)longPressSaveVideo:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        // [ProgressHUD show:@"Preparing Video"];
        NSInteger videoVersion = [%c(IGPost) videoVersionForCurrentNetworkConditions];
  //       NSURL *videoURL = [self.post videoURLForVideoVersion:videoVersion];
  //       NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
  //       NSString *documentsPath = @"/var/mobile/Library/InstaOpenIN/"; //Get the docs directory 
        // NSString *filePath = [documentsPath stringByAppendingPathComponent:@"video.mp4"]; //Add the file name
        // [videoData writeToFile:filePath atomically:YES]; //Write the file

        //download the file in a seperate thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        NSURL *urlToDownload = [self.post videoURLForVideoVersion:videoVersion];
        // NSURL  *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:urlToDownload];
        if ( urlData ) {
            NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"video.mp4"];
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                // [ProgressHUD dismiss];
                NSLog(@"File Saved !");
            });
            NSURL *URL = [NSURL fileURLWithPath:filePath];
            TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self andRect:self.frame];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
            // [SVProgressHUD showSuccessWithStatus:@"Success!"];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                // Store reference to superview (UIActionSheet) to allow dismissal
                openInAppActivity.superViewController = activityViewController;
                // Show UIActivityViewController
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:NULL];
            } else {
                // Create pop up
                activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
                // Store reference to superview (UIPopoverController) to allow dismissal
                openInAppActivity.superViewController = activityPopoverController;
                // Show UIActivityViewController in popup
                [activityPopoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
        // TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self andRect:self.frame];
        // UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
        // [SVProgressHUD showSuccessWithStatus:@"Success!"];
        // if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        //     // Store reference to superview (UIActionSheet) to allow dismissal
        //     openInAppActivity.superViewController = activityViewController;
        //     // Show UIActivityViewController
        //     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityViewController animated:YES completion:NULL];
        // } else {
        //     // Create pop up
        //     activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        //     // Store reference to superview (UIPopoverController) to allow dismissal
        //     openInAppActivity.superViewController = activityPopoverController;
        //     // Show UIActivityViewController in popup
        //     [activityPopoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        // }

    }
}
%new
- (void) documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    system("/usr/bin/killall -9 Instagram");
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)instaOpenINInitPrefs, CFSTR(kPreferencesChanged), NULL, CFNotificationSuspensionBehaviorCoalesce);
    instaOpenINInitPrefs();
}