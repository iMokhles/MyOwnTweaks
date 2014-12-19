#import <Twitter/Twitter.h>
#import <Preferences/PSSpecifier.h>
#import <objc/runtime.h>
#import <Preferences/PSTableCell.h>
#import "NSTask.h"
#import <UIKit/UIKit.h>

#define kPreferencesPath @"/User/Library/Preferences/com.imokhles.FaceBOpenIN.plist"
#define kPreferencesChanged "com.imokhles.FaceBOpenIN.preferences-changed"

static NSBundle* getBundle() {
    return [NSBundle bundleWithPath:@"/Library/PreferenceBundles/FaceBOpenIN.bundle"];
}

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

#define SIDELOADERTINT [UIColor colorWithRed: 50.0/255.0 green: 200.0/255.0 blue: 50.0/255.0 alpha: 1.0]

#define kUrl_FollowOnTwitter @"https://twitter.com/imokhles"
#define kUrl_VisitWebSite @"http://imokhles.com"
#define kUrl_MakeDonation @"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=F4ZGWKWBKT82Y"

#define tweak_defaults @"/User/Library/Preferences/com.imokhles.FaceBOpenIN.plist"
#define yearMade @"2014"

@interface PSTableCell()
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
@end

@interface PSViewController : UIViewController
-(id)initForContentSize:(CGSize)contentSize;
-(void)setPreferenceValue:(id)value specifier:(id)specifier;
@end

@interface PSListController : PSViewController{
	NSArray *_specifiers;
}

- (void)viewDidAppear:(BOOL)arg1;
- (void)viewDidLayoutSubviews;
- (void)viewDidLoad;
- (void)viewDidUnload;
- (void)viewWillAppear:(BOOL)arg1;
- (void)viewWillDisappear:(BOOL)arg1;
-(void)loadView;
-(void)reloadSpecifier:(PSSpecifier*)specifier animated:(BOOL)animated;
-(void)reloadSpecifier:(PSSpecifier*)specifier;
- (NSArray *)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
-(PSSpecifier*)specifierForID:(NSString*)specifierID;
@end

@interface FaceBOpenINBannerCell : PSTableCell {
    UIImageView *_imageView;
}
@end

@interface FaceBOpenINListController: PSListController {
}
@end

@implementation FaceBOpenINListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"FaceBOpenIN" target:self] retain];
	}
	return _specifiers;
}
-(void)loadView {
    NSString *btnTitle;
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if ([language isEqualToString:@"ar"]) {
        btnTitle = @"مشاركة";
    } else {
        btnTitle = @"Share";
    }
    UIBarButtonItem *heart = [[UIBarButtonItem alloc] initWithTitle:btnTitle style:UIBarButtonItemStylePlain target:self action:@selector(shareTapped:)];
    self.navigationItem.rightBarButtonItem = heart;
    [super loadView];
    
}
-(void)shareTapped:(UIBarButtonItem *)sender {
    NSString *text;

    // NSString *btnTitle;
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if ([language isEqualToString:@"ar"]) {
        text = @"استخدم اداة #FaceBOpenIN بواسطة @iMokhles لمشاركة صور الفيس بوك للتطبيقات الاخري";
    } else {
        text = @"I like #FaceBOpenIN by @iMokhles to share facebook images with other apps.";
    }    
	if (objc_getClass("UIActivityViewController")) {
		UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:text, nil] applicationActivities:nil];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}
    
	else {
		text = [text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@", text]]];
	}
}

- (void)followOnTwitter:(PSSpecifier*)specifier {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_FollowOnTwitter]];
}
- (void)visitWebSite:(PSSpecifier*)specifier {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_VisitWebSite]];
}
- (void)makeDonation:(PSSpecifier *)specifier {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_MakeDonation]];
}

- (NSString *)versionValue:(PSSpecifier *)specifier {
    
	NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments:[NSArray arrayWithObjects: @"-c", @"dpkg -s com.imokhles.FaceBOpenIN | grep 'Version'", nil]];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task launch];
    NSData *data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
    NSString *version = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSString *subString = [version substringFromIndex:[version length] - 6];
    //[pipe release]; //crashes
    return subString;
}
-(id) readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *TGAnyFilesSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    if (!TGAnyFilesSettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return TGAnyFilesSettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPreferencesPath]];
    NSLog(@"TGAnyFiles: [DEBUG] %@",specifier.properties);
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:kPreferencesPath atomically:YES];
    NSDictionary *TGAnyFilesSettings = [NSDictionary dictionaryWithContentsOfFile:kPreferencesPath];
    NSLog(@"TGAnyFiles: [DEBUG] TGAnyFilesSettings %@",TGAnyFilesSettings);
    NSLog(@"TGAnyFiles: [DEBUG] posting CFNotification %@", specifier.properties[@"PostNotification"]);
    CFStringRef imokhlesPost = (CFStringRef)specifier.properties[@"PostNotification"];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), imokhlesPost, NULL, NULL, YES);
}
@end

@implementation FaceBOpenINBannerCell
- (id)initWithSpecifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell" specifier:specifier];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.369f green:0.169f blue:0.361f alpha:1.0f]];
        if (IS_IPHONE) {
            _imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[getBundle() pathForResource:@"FaceBOpenINHeader" ofType:@"png"]]];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_imageView];
        } else if (IS_IPHONE_5) {
            _imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[getBundle() pathForResource:@"FaceBOpenINHeader" ofType:@"png"]]];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_imageView];
        } else {
        	_imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[getBundle() pathForResource:@"FaceBOpenINHeader" ofType:@"png"]]];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_imageView];
        }
    }
    return self;
}
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1
{
    // Return a custom cell height.
    if (IS_IPHONE) {
        return 192.0f;
    } else if (IS_IPHONE_5) {
        return 384.0f;
    } else if (IS_IPAD) {
        return 384.0f;
    } else if (IS_RETINA) {
        return 384.0f;
    }
    return 384.0f;
}
@end
// vim:ft=objc
