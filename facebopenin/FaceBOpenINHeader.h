//
//  DecFile.h
//  Rendarya
//
//  Created by iMokhles on 3/23/14.
//
//

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

@interface UIWindow ()
+(id)keyWindow;
@end

@class TGModernConversationController;

OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;

#define kPreferencesPath @"/User/Library/Preferences/com.imokhles.FaceBOpenIN.plist"
#define kPreferencesChanged "com.imokhles.FaceBOpenIN.preferences-changed"


#define kEnablePhotos @"enablePhotos"

static BOOL enablePhotos;
static UIPopoverController *activityPopoverController;

// Facebook Declarations


@interface FBPhotoView : UIView {
}

+ (unsigned int)photoViewImageFlag:(id)arg1;
@property(copy, nonatomic) NSString *module;
- (id)initWithFrame:(struct CGRect)arg1;
- (id)initWithFrame:(struct CGRect)arg1 desiredImageFlag:(unsigned int)arg2 session:(id)arg3;

@end

@interface FBRichPhotoView : UIView  {
    UIButton *_retryButton;
    float _lastProgress;
    BOOL _showingTags;
    unsigned short _moduleTag;
    unsigned int _minimumViewablePhotoImageFlag;
    NSDate *_spinnerDisplayTime;
    BOOL _canEditTag;
    BOOL _canSyncTaggables;
    BOOL _isPhotoEntityCompleted;
    NSMutableSet *_newTags;
    double _loadTime;
    BOOL _showFaceboxesByDefault;
    BOOL _needsToDelegateDidSetTags;
    FBPhotoView *_photoView;
    struct CGSize _photoSize;
}

@property(copy, nonatomic) NSString *focusedFaceboxFBID; // @synthesize focusedFaceboxFBID=_focusedFaceboxFBID;
@property(copy, nonatomic) NSString *sessionID; // @synthesize sessionID=_sessionID;
@property(retain, nonatomic) NSTimer *hideTapToTagLabelTimer; // @synthesize hideTapToTagLabelTimer=_hideTapToTagLabelTimer;
@property(nonatomic) BOOL needsToDelegateDidSetTags; // @synthesize needsToDelegateDidSetTags=_needsToDelegateDidSetTags;
@property(nonatomic) struct CGSize photoSize; // @synthesize photoSize=_photoSize;
@property(retain, nonatomic) NSDate *spinnerDisplayTime; // @synthesize spinnerDisplayTime=_spinnerDisplayTime;
@property(readonly, nonatomic) UIButton *retryButton; // @synthesize retryButton=_retryButton;
@property(nonatomic) float lastProgress; // @synthesize lastProgress=_lastProgress;
@property(nonatomic) BOOL showFaceboxesByDefault; // @synthesize showFaceboxesByDefault=_showFaceboxesByDefault;
@property(nonatomic) unsigned int viewTagMode; // @synthesize viewTagMode=_viewTagMode;
@property(copy, nonatomic, getter=getNewTags) NSSet *newTags; // @synthesize newTags=_newTags;
@property(nonatomic) BOOL canSyncTaggables; // @synthesize canSyncTaggables=_canSyncTaggables;
@property(nonatomic) BOOL canEditTag; // @synthesize canEditTag=_canEditTag;
@property(nonatomic) float zoomScale; // @synthesize zoomScale=_zoomScale;
@property(readonly, nonatomic) FBPhotoView *photoView; // @synthesize photoView=_photoView;
@property(nonatomic) BOOL tagGuideEnabled;
@property(readonly, nonatomic) BOOL isZoomedIn;
@property(readonly, nonatomic) BOOL isZoomed;
@property(readonly, nonatomic) BOOL isSpinnerOn;
- (void)layoutSubviews;
- (id)initWithFrame:(struct CGRect)arg1 referrer:(id)arg2 session:(id)arg3;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface FBPhotoViewController : UIViewController  {
    FBRichPhotoView *_photoView2K;
}

@property(nonatomic) FBRichPhotoView *photoView2K; // @synthesize photoView2K=_photoView2K;
@end

@interface FBPhotoViewController (FaceBOpenIN_Tweak) <UIPopoverPresentationControllerDelegate>
@end
