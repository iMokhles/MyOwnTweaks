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
#import <substrate.h>

#import "TTOpenInAppActivity.h"

#define kPreferencesPath @"/User/Library/Preferences/com.imokhles.WAOpenIN.plist"
#define kPreferencesChanged "com.imokhles.WAOpenIN.preferences-changed"


#define kEnablePhotos @"enablePhotos"
#define kEnableVideos @"enableVideos"

#define WAELANGUAGE [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0]

static BOOL enablePhotos;
static BOOL enableVideos;

static void WAOpenINInitPrefs() {
    NSDictionary *WAOpenINSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    NSNumber *WAOpenINEnableOptionKey = WAOpenINSettings[kEnablePhotos];
    enablePhotos = WAOpenINEnableOptionKey ? [WAOpenINEnableOptionKey boolValue] : 1;

    NSNumber *WAOpenINEnableVideosOptionKey = WAOpenINSettings[kEnableVideos];
    enableVideos = WAOpenINEnableVideosOptionKey ? [WAOpenINEnableVideosOptionKey boolValue] : 1;

}

@interface WAMessage : NSObject <UIActivityItemSource>
{
    BOOL _observingSendState;
    struct dispatch_group_s *_sendDispatchGroup;
    struct dispatch_group_s *_locationInfoDispatchGroup;
    BOOL _messageSendInProgress;
    NSString *_mediaThumbnailCacheKey;
    struct dispatch_group_s *_thumbnailLoadingDispatchGroup;
    int _loadRequestsInProgress;
    UIImage *_loadedThumbnail;
    BOOL _offlineStorage;
    BOOL _sending;
    int _multiSendMediaIndex;
    int _multiSendMediaCount;
    NSString *_participantJID;
    NSData *_xmppThumbnailData;
}

+ (id)chatThumbnailCache;
+ (id)mediaBrowserThumbnailForUnknownMedia;
+ (id)mediaThumbnailCache;
+ (id)mediaDirectoryForFilename:(id)arg1 JID:(id)arg2;
+ (id)relativeLibraryPathFromAbsolutePath:(id)arg1;
+ (void)createNewOutgoingMessageWithPlace:(id)arg1 inChatSession:(id)arg2 completion:(id)arg3;
+ (void)createNewOutgoingMessageWithVideoURL:(id)arg1 inChatSession:(id)arg2 completion:(id)arg3;
+ (void)createNewOutgoingMessageWithAudioTrack:(id)arg1 inChatSession:(id)arg2 completion:(id)arg3;
+ (void)createNewOutgoingMessageWithImage:(id)arg1 inChatSession:(id)arg2 imageIndex:(int)arg3 totalImageCount:(int)arg4 completion:(id)arg5;
+ (void)createNewOutgoingMessageWithMedia:(id)arg1 inChatSession:(id)arg2 imageRepresentation:(id)arg3 messageType:(unsigned int)arg4 mediaOrigin:(unsigned int)arg5 completion:(id)arg6;
+ (unsigned int)orphanedMessagesCount;
+ (id)mediaSectionIDForMessage:(id)arg1 usingDateFormatter:(id)arg2;
+ (id)dateFormatterForMediaSectionID;
@property(retain, nonatomic) NSData *xmppThumbnailData; // @synthesize xmppThumbnailData=_xmppThumbnailData;
@property(copy, nonatomic) NSString *participantJID; // @synthesize participantJID=_participantJID;
@property(nonatomic, getter=isSending) BOOL sending; // @synthesize sending=_sending;
@property(nonatomic) int multiSendMediaCount; // @synthesize multiSendMediaCount=_multiSendMediaCount;
@property(nonatomic) int multiSendMediaIndex; // @synthesize multiSendMediaIndex=_multiSendMediaIndex;

- (id)activityViewController:(id)arg1 dataTypeIdentifierForActivityType:(id)arg2;
- (id)activityViewController:(id)arg1 subjectForActivityType:(id)arg2;
- (id)activityViewController:(id)arg1 itemForActivityType:(id)arg2;
- (id)activityViewControllerPlaceholderItem:(id)arg1;
@property(readonly, nonatomic) NSString *stringRepresentation;
@property(retain) UIImage *imageRepresentation;
@property(readonly) UIImage *blurredImage;
@property(readonly) UIImage *xmppImage;
- (void)fetchRequiredDataForIncomingLocationWithCompletion:(id)arg1;
- (void)fetchRequiredDataForWAPlace:(id)arg1 withCompletion:(id)arg2;
- (void)repeatedlyFetchBetterThumbnailsWithBlock:(id)arg1;
- (struct CGSize)chatThumbnailSize;
- (id)chatThumbnailReturningPermanentState:(char *)arg1;
- (id)cachedChatThumbnail;
- (void)generateMediaBrowserThumbnailWithCompletionHandler:(id)arg1;
- (void)fetchMediaBrowserThumbnailWithCompletionHandler:(id)arg1;
- (id)cachedMediaBrowserThumbnail;
- (id)mediaPathForIncomingMediaWithFilename:(id)arg1;
- (id)uniqueMediaPathWithPathExtension:(id)arg1;
@property(readonly, nonatomic) NSString *mediaPath;
@property(readonly, nonatomic) NSString *chatThumbnailPath;
@property(readonly, nonatomic) NSString *xmppThumbnailPath;
@property(readonly, nonatomic) NSString *mediaBrowserThumbnailPath;
- (void)attachIncomingXMPPThumbnailData:(id)arg1;
- (void)attachIncomingMediaWithFilename:(id)arg1 data:(id)arg2 completion:(id)arg3;
- (void)populateChildMessage:(id)arg1;
- (id)addChildMessagesIfNeeded;
- (void)prepareThumbnails:(unsigned int)arg1 completion:(id)arg2;
- (void)performBlockAfterSendMessageAttempt:(id)arg1;
- (void)markSendAsCompletedIfNecessary;
- (void)markSendAsStartedIfNecessary;
@property(readonly, nonatomic, getter=isValid) BOOL valid;
- (void)unsetFlag:(unsigned int)arg1;
- (void)setFlag:(unsigned int)arg1;
- (BOOL)hasFlag:(unsigned int)arg1;
@property(retain, nonatomic) NSNumber *messageStatus; // @dynamic messageStatus;
@property(retain, nonatomic) NSString *text; // @dynamic text;
@property(nonatomic) BOOL offlineStorage; // @synthesize offlineStorage=_offlineStorage;
- (void)freeCachedData;
- (BOOL)turnMediaItemIntoFaultIfPossible;
- (BOOL)turnIntoFaultIfPossible;
- (void)generateMediaThumbnailCacheKey;
- (id)fromName;
- (void)updateMediaSectionID;
- (void)didTurnIntoFault;
- (void)awakeFromInsert;
- (void)awakeFromFetch;

// Remaining properties
@property(retain, nonatomic) NSSet *childMessages; // @dynamic childMessages;
@property(retain, nonatomic) NSNumber *childMessagesDeliveredCount; // @dynamic childMessagesDeliveredCount;
@property(retain, nonatomic) NSNumber *childMessagesPlayedCount; // @dynamic childMessagesPlayedCount;
@property(retain, nonatomic) NSNumber *childMessagesReadCount; // @dynamic childMessagesReadCount;
@property(retain, nonatomic) NSNumber *filteredRecipientCount; // @dynamic filteredRecipientCount;
@property(retain, nonatomic) NSNumber *flags; // @dynamic flags;
@property(retain, nonatomic) NSString *fromJID; // @dynamic fromJID;
@property(retain, nonatomic) NSNumber *groupEventType; // @dynamic groupEventType;
@property(retain, nonatomic) NSNumber *isFromMe; // @dynamic isFromMe;
@property(retain, nonatomic) NSString *mediaSectionID; // @dynamic mediaSectionID;
@property(retain, nonatomic) NSDate *messageDate; // @dynamic messageDate;
@property(retain, nonatomic) NSNumber *messageType; // @dynamic messageType;
@property(retain, nonatomic) NSString *pushName; // @dynamic pushName;
@property(retain, nonatomic) NSNumber *sort; // @dynamic sort;
@property(retain, nonatomic) NSString *stanzaID; // @dynamic stanzaID;
@property(retain, nonatomic) NSString *toJID; // @dynamic toJID;
@property(retain, nonatomic) NSSet *words; // @dynamic words;

@end



@interface WAMediaObject : NSObject
@property(readonly, nonatomic) unsigned int type;
@property(readonly, nonatomic) NSString *path;
@property(retain, nonatomic) NSString *fromName;
@property(retain, nonatomic) UIImage *thumbnail;
@end

@interface WAMediaViewController : UIViewController
- (WAMediaObject *)currentMedia;
- (void)assignImageToContact;
- (void)saveCurrentVideo;
- (void)saveCurrentImage;
- (void)forwardMediaViaEmail;
- (void)showPersonPickerForMediaForwardViaWhatsApp;
- (void)setProfilePhoto;
- (void)assignCurrentImageToGroup;
@end

@interface WAMediaViewController (WAEnhancer) <UIActionSheetDelegate, UIAlertViewDelegate, UIPopoverPresentationControllerDelegate>
- (void)saveToMusicLibrary;
- (void)sharePhotosTo;
- (void)shareVideosTo;
@end

%hook WAMediaViewController
- (void)showMediaActions:(id)arg1 {
    
    //NSLog (@"**********WAOpenIN************* %@", self.currentMedia.path);
    //NSLog (@"**********WAOpenIN************* %d", self.currentMedia.type);
    //Action Sheet
    WAMessage *currentMessage = MSHookIvar<WAMessage *>(self, "_currentMessage");
    NSString *actionSheetTitle = @""; //Action Sheet Title
    //Action Sheet Button Titles
           NSString *FDEmail;
    NSString *FDWhats;
    NSString *SVVideo;
    NSString *SVImage;
    NSString *ASContact;
    NSString *SETProfile;
    // NSString *SVMusic;
    NSString *SETGroup;
    NSString *cancelTitle;
    NSString *SHPhotos;
    NSString *SHVideos;
    if ([WAELANGUAGE isEqualToString:@"ar"]) {
       FDEmail = @"مشاركة بواسطة الايميل";
       FDWhats = @"مشاركة بواسطة الواتس اب";
       SVVideo = @"مشاركة الفيديو";
       SVImage = @"حفظ الصورة";
       ASContact = @"تعين لجهة اتصال";
       SETProfile = @"تعين كا صورة شخصية";
       // SVMusic = @"مشاركة الصوتيات";
       SETGroup = @"تعين للجروب";
       cancelTitle = @"الغاء";
       SHPhotos = @"مشاركة الصورة";
       SHVideos = @"مشاركة الفيديو";
    } else {
       FDEmail = @"Forward via Email";
       FDWhats = @"Forward via WhatsApp";
       SVVideo = @"Save Video";
       SVImage = @"Save Image";
       ASContact = @"Assign to Contact";
       SETProfile = @"Set as Profile Photo";
       // SVMusic = @"Share Music";
       SETGroup = @"Assign to Group";
       cancelTitle = @"Cancel";
       SHPhotos = @"Share Photo";
       SHVideos = @"Share Video";
    }


    //UIBarButtonItem *actionButton = MSHookIvar<UIBarButtonItem *>(self, "_actionButton");
    //NSURL *outURL = [NSURL fileURLWithPath:self.currentMedia.path];
    if ([currentMessage.messageType intValue] == 1) {
            //Photos
            NSLog (@"**********WAOpenIN*************PHOTOS");
            if (enablePhotos) {
            	UIActionSheet *actionSheet = [[UIActionSheet alloc]
	                                          initWithTitle:actionSheetTitle
	                                          delegate:self
	                                          cancelButtonTitle:cancelTitle
	                                          destructiveButtonTitle:nil
	                                          otherButtonTitles:SHPhotos, SVImage, ASContact, SETGroup, SETProfile, FDEmail, FDWhats, nil];
	            
	            [actionSheet showInView:self.view];
            } else {
            	%orig;
            }
            
        } else if ([currentMessage.messageType intValue] == 2) {
            //Videos
            NSLog (@"**********WAOpenIN*************VIDEOS");
            
            if (enableVideos) {
            	UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:SHVideos, SVVideo, FDEmail, FDWhats, nil];
            
            	[actionSheet showInView:self.view];
            } else {
            	%orig;
            }
            
        } else if ([currentMessage.messageType intValue] == 3) {
            //Musics
            // NSLog (@"**********WAOpenIN*************MUSICS");
            // UIActionSheet *actionSheet = [[UIActionSheet alloc]
            //                               initWithTitle:actionSheetTitle
            //                               delegate:self
            //                               cancelButtonTitle:cancelTitle
            //                               destructiveButtonTitle:nil
            //                               otherButtonTitles:SVMusic, FDEmail, FDWhats, nil];
            
            // [actionSheet showInView:self.view];
            %orig;
            
        }
}
// %new(v@:@@)
// - (void)saveToMusicLibrary {
//     WAMessage *currentMessage = MSHookIvar<WAMessage *>(self, "_currentMessage");
//     NSString *musicPath = currentMessage.mediaPath;
//     NSURL *outURL = [NSURL fileURLWithPath:musicPath];
//     UIBarButtonItem *actionButton = MSHookIvar<UIBarButtonItem *>(self, "_actionButton");
    
//     NSArray *activitesApp;
//     NSArray *activitesItem;
//     //NSLog (@"**********WAOpenIN*************MUSICS URL: %@", outURL);
//     NSLog(@"**[ WAOpenIN ] Music pressed");
//     EGYOpenInActivity *EgyOpenIN = [[EGYOpenInActivity alloc] initWithView:self.view andBarButtonItem:actionButton];
//     activitesApp = @[EgyOpenIN];
//     activitesItem = @[outURL];
    
//     UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
//     EgyOpenIN.superViewController = activityController;
//     [self presentViewController:activityController animated:YES completion:^{}];
// }

%new(v@:@@)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    
    NSString *FDEmail;
    NSString *FDWhats;
    NSString *SVVideo;
    NSString *SVImage;
    NSString *ASContact;
    NSString *SETProfile;
    // NSString *SVMusic;
    NSString *SETGroup;
    NSString *cancelTitle;
    NSString *SHPhotos;
    NSString *SHVideos;
    if ([WAELANGUAGE isEqualToString:@"ar"]) {
       FDEmail = @"مشاركة بواسطة الايميل";
       FDWhats = @"مشاركة بواسطة الواتس اب";
       SVVideo = @"مشاركة الفيديو";
       SVImage = @"حفظ الصورة";
       ASContact = @"تعين لجهة اتصال";
       SETProfile = @"تعين كا صورة شخصية";
       // SVMusic = @"مشاركة الصوتيات";
       SETGroup = @"تعين للجروب";
       cancelTitle = @"الغاء";
       SHPhotos = @"مشاركة الصورة";
       SHVideos = @"مشاركة الفيديو";
    } else {
       FDEmail = @"Forward via Email";
       FDWhats = @"Forward via WhatsApp";
       SVVideo = @"Save Video";
       SVImage = @"Save Image";
       ASContact = @"Assign to Contact";
       SETProfile = @"Set as Profile Photo";
       // SVMusic = @"Share Music";
       SETGroup = @"Assign to Group";
       cancelTitle = @"Cancel";
       SHPhotos = @"Share Photo";
       SHVideos = @"Share Video";
    }

    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:FDEmail]) {
        NSLog(@"**[ WAOpenIN ] Email pressed");
        [self forwardMediaViaEmail];
    }
    if ([buttonTitle isEqualToString:FDWhats]) {
        NSLog(@"**[ WAOpenIN ] Whats pressed");
        [self showPersonPickerForMediaForwardViaWhatsApp];
    }
    if ([buttonTitle isEqualToString:SVVideo]) {
        NSLog(@"**[ WAOpenIN ] Video pressed");
        WAMessage *currentMessage = MSHookIvar<WAMessage *>(self, "_currentMessage");
        NSString *photoPath = currentMessage.mediaPath;
        NSURL *sourceURL = [NSURL fileURLWithPath:photoPath];
        NSURLSessionTask *download = [[NSURLSession sharedSession] downloadTaskWithURL:sourceURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
            NSURL *tempURL = [documentsURL URLByAppendingPathComponent:[sourceURL lastPathComponent]];
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
            UISaveVideoAtPathToSavedPhotosAlbum(tempURL.path, nil, NULL, NULL);
        }];
        [download resume];
    }
    if ([buttonTitle isEqualToString:SVImage]) {
        NSLog(@"**[ WAOpenIN ] Image pressed");
        WAMessage *currentMessage = MSHookIvar<WAMessage *>(self, "_currentMessage");
        NSString *photoPath = currentMessage.mediaPath;
        UIImage *image = [UIImage imageWithContentsOfFile:photoPath];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    if ([buttonTitle isEqualToString:ASContact]) {
        NSLog(@"**[ WAOpenIN ] Contact pressed");
        [self assignImageToContact];
    }
    if ([buttonTitle isEqualToString:SETProfile]) {
        NSLog(@"**[ WAOpenIN ] Profile pressed");
        [self setProfilePhoto];
    }
    if ([buttonTitle isEqualToString:SETGroup]) {
        NSLog(@"**[ WAOpenIN ] Group pressed");
        [self assignCurrentImageToGroup];
    }
    // if ([buttonTitle isEqualToString:SVMusic]) {
    //     NSLog(@"**[ WAOpenIN ] Music pressed");
    //     [self saveToMusicLibrary];
    // }
    if ([buttonTitle isEqualToString:SHPhotos]) {
        [self sharePhotosTo];
    }
    if ([buttonTitle isEqualToString:SHVideos]) {
        [self shareVideosTo];
    }
}
%new(v@:@@)
- (void)sharePhotosTo {
    WAMessage *currentMessage = MSHookIvar<WAMessage *>(self, "_currentMessage");
    NSString *photoPath = currentMessage.mediaPath;
    // NSURL *outURL = [NSURL fileURLWithPath:photoPath];
    // UIBarButtonItem *actionButton = MSHookIvar<UIBarButtonItem *>(self, "_actionButton");
    
    // NSArray *activitesApp;
    // NSArray *activitesItem;
    // //NSLog (@"**********WAOpenIN*************Photo URL: %@", outURL);
    // NSLog(@"**[ WAOpenIN ] Photo pressed");
    // EGYOpenInActivity *EgyOpenIN = [[EGYOpenInActivity alloc] initWithView:self.view andBarButtonItem:actionButton];
    // activitesApp = @[EgyOpenIN];
    // activitesItem = @[outURL];
    
    // UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
    // EgyOpenIN.superViewController = activityController;
    // [self presentViewController:activityController animated:YES completion:^{}];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	            NSLog(@"Downloading Started");
	                NSURL *URL = [NSURL fileURLWithPath:photoPath];
	                TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
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

	});
}
%new(v@:@@)
- (void)shareVideosTo {
    WAMessage *currentMessage = MSHookIvar<WAMessage *>(self, "_currentMessage");
    NSString *videoPath = currentMessage.mediaPath;
    // NSURL *outURL = [NSURL fileURLWithPath:videoPath];
    // UIBarButtonItem *actionButton = MSHookIvar<UIBarButtonItem *>(self, "_actionButton");
    
    // NSArray *activitesApp;
    // NSArray *activitesItem;
    // //NSLog (@"**********WAOpenIN*************Video URL: %@", outURL);
    // NSLog(@"**[ WAOpenIN ] Videos pressed");
    // EGYOpenInActivity *EgyOpenIN = [[EGYOpenInActivity alloc] initWithView:self.view andBarButtonItem:actionButton];
    // activitesApp = @[EgyOpenIN];
    // activitesItem = @[outURL];
    
    // UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
    // EgyOpenIN.superViewController = activityController;
    // [self presentViewController:activityController animated:YES completion:^{}];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	            NSLog(@"Downloading Started");
	                NSURL *URL = [NSURL fileURLWithPath:videoPath];
	                TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
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

	});
}

%end

// - (void)share {
// 	if (enablePhotos) {
// 		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
// 	            NSLog(@"Downloading Started");
// 	                NSURL *URL = [NSURL fileURLWithPath:self.pictureURL];
// 	                TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
// 	                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
// 	                // [SVProgressHUD showSuccessWithStatus:@"Success!"];
// 	                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
// 	                    // Store reference to superview (UIActionSheet) to allow dismissal
// 	                    openInAppActivity.superViewController = activityViewController;
// 	                    // Show UIActivityViewController
// 	                    [self presentViewController:activityViewController animated:YES completion:NULL];
// 	                } else {
// 	                    // Create pop up
// 	                    UIPopoverPresentationController *presentPOP = activityViewController.popoverPresentationController;
// 			            activityViewController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
// 			            activityViewController.popoverPresentationController.sourceView = self.view;
// 			            presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
// 			            presentPOP.delegate = self;
// 			            presentPOP.sourceRect = CGRectMake(700,80,0,0);
// 			            presentPOP.sourceView = self.view;
// 			            openInAppActivity.superViewController = presentPOP;
// 			            [self presentViewController:activityViewController animated:YES completion:NULL];

// 	                    // activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
// 	                    // // Store reference to superview (UIPopoverController) to allow dismissal
// 	                    // openInAppActivity.superViewController = activityPopoverController;
// 	                    // // Show UIActivityViewController in popup
// 	                    // [activityPopoverController presentPopoverFromRect:imgView.frame inView:imgView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
// 	                }

// 	        });
// 	} else {
// 		%orig;
// 	}
// }
// %end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)WAOpenINInitPrefs, CFSTR(kPreferencesChanged), NULL, CFNotificationSuspensionBehaviorCoalesce);
    WAOpenINInitPrefs();
}