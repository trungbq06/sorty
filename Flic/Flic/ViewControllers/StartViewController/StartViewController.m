//
//  StartViewController.m
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "StartViewController.h"
#import "TimeFrameViewController.h"
#import "AlbumPickerViewController.h"

@interface StartViewController ()

@property (nonatomic, assign) BOOL              isPurchased;
@property (weak, nonatomic) IBOutlet UIButton *btnTop;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;

@property (nonatomic, retain) UIBarButtonItem *barBtnTop;
@property (nonatomic, retain) UIBarButtonItem *barBtnRight;
@property (nonatomic, retain) UIBarButtonItem *barBtnBottom;
@property (nonatomic, retain) UIBarButtonItem *barBtnLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelRight;
@property (weak, nonatomic) IBOutlet UILabel *labelTop;
@property (weak, nonatomic) IBOutlet UILabel *labelBottom;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;

- (IBAction)selectTopClick:(id)sender;
- (IBAction)selectRightClick:(id)sender;
- (IBAction)selectDownClick:(id)sender;
- (IBAction)selectLeftClick:(id)sender;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:kPurchased];
    CGRect appframe = [[UIScreen mainScreen] bounds];
    
    if (!_isPurchased) {
//        _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, appframe.size.height - 50, appframe.size.width, 50)];
//        _adView.delegate = self;
//        _adView.alpha = 0;
    }
    
    [self loadIntersial];
    
    _phImagePicker = [[PHImagePicker alloc] init];
    
    _barBtnTop = [[UIBarButtonItem alloc] initWithCustomView:_btnTop];
    _barBtnRight = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    _barBtnBottom = [[UIBarButtonItem alloc] initWithCustomView:_btnBottom];
    _barBtnLeft = [[UIBarButtonItem alloc] initWithCustomView:_btnLeft];
    
    _btnTop.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnBottom.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self transformText:_labelLeft transform: -M_PI_2];
    [self transformText:_labelRight transform: M_PI_2];
    _labelTop.textAlignment = NSTextAlignmentCenter;
    _labelBottom.textAlignment = NSTextAlignmentCenter;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    CGRect frame = _btnSelect.frame;
    [_btnSelect setFrame:CGRectMake(frame.origin.x, self.view.frame.size.height - frame.size.height - 60, frame.size.width, frame.size.height)];
    [_bottomText setFrame:CGRectMake(_bottomText.frame.origin.x, self.view.frame.size.height - _bottomText.frame.size.height - 20, _bottomText.frame.size.width, _bottomText.frame.size.height)];
    
    [self resetAlbum];
}

#pragma mark - RESET ALBUM
- (void) resetAlbum
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kTypeTop];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kTypeRight];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kTypeLeft];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kTypeBottom];
}

#pragma mark - LOAD BANNER
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [interstitial_ presentFromRootViewController:self];
    
    bannerShown = TRUE;
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
}

- (void) loadIntersial
{
    if (!_noAds) {
        if (!bannerShown) {
            interstitial_ = [[GADInterstitial alloc] init];
            interstitial_.adUnitID = MY_BANNER_INTERSITIAL_UNIT_ID;
            [interstitial_ setDelegate:self];
            [interstitial_ loadRequest:[GADRequest request]];
        }
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
    {
        [bannerView_ removeFromSuperview];
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        CGRect frame = banner.frame;
        [banner setFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height)];
        
        [UIView commitAnimations];
        bannerIsVisible = YES;
        [adView setHidden:!bannerIsVisible];
    }
}

//when any problems occured
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        [UIView commitAnimations];
        bannerIsVisible = NO;
        [adView setHidden:!bannerIsVisible];
        
        [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
    }
}

- (void) loadBanner {
    if (!_noAds) {
        CGRect appframe= [[UIScreen mainScreen] applicationFrame];

        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0,
                                                appframe.size.height - 50,
                                                GAD_SIZE_320x50.width,
                                                GAD_SIZE_320x50.height)];
        
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = MY_BANNER_UNIT_ID;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        bannerView_.delegate = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[self request]];
    }
}

#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    //    request.testDevices = @[
    //                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
    //                            // the console when the app is launched.
    //                            GAD_SIMULATOR_ID
    //                            ];
    return request;
}

- (void) transformText:(UILabel*) label transform: (float) angle {
    CGRect frame = label.frame;
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(frame.size.width/2 + frame.origin.x, frame.size.height/2 + frame.origin.y);
    label.transform = CGAffineTransformMakeRotation(angle);
}

- (void) setTextTopDown:(UIButton*) button {
    NSString *newText = [NSString stringWithFormat:@"%C",[button.titleLabel.text characterAtIndex:0]];
    for(int i=1;i<button.titleLabel.text.length;i++) {
        // Format newText to include a newline and then the next character of the original string
        newText = [NSString stringWithFormat:@"%@\n%C",newText,[button.titleLabel.text characterAtIndex:i]];
    }
    // We must change the word wrap mode of the button in order for text to display across multiple lines.
    button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    // .. and for an unknown reason, the text alignment needs to be reset. Replace this if you use something other than center alignment.
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    // newText now contains the properly formatted text string, so we can set this as the button label
    [button setTitle:newText forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self setButtonTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)btnSelectClick:(id)sender
{
    // Check if user select 2 albums
    NSString *textTop = _labelTop.text;
    NSString *textRight = _labelRight.text;
    NSString *textBottom = _labelBottom.text;
    NSString *textLeft = _labelLeft.text;
    
    int totalAlbum = 0;
    if (![textBottom isEqualToString:@"Create or Select Albums"])
        totalAlbum++;
    if (![textRight isEqualToString:@"Create or Select Albums"])
        totalAlbum++;
    if (![textTop isEqualToString:@"Create or Select Albums"])
        totalAlbum++;
    if (![textLeft isEqualToString:@"Create or Select Albums"])
        totalAlbum++;
    
    if (totalAlbum < 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please Create or Select at least 2 albums to start" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    TimeFrameViewController *timeFrame = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeFrameViewController"];
    
    [self.navigationController pushViewController:timeFrame animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray*) loadAlbums {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableArray *images = [_phImagePicker selectAlbums];
    
    [SVProgressHUD dismiss];
    
    return images;
}

- (IBAction)selectTopClick:(id)sender {
    AlbumPickerViewController *albumPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPickerViewController"];
    [albumPicker setImageData:[self loadAlbums]];
    albumPicker.albumType = kTypeTop;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:albumPicker];
    popover.delegate = self;
    popover.contentSize = CGSizeMake(220, 320);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromView:_btnTop];
}

- (IBAction)selectRightClick:(id)sender {
    AlbumPickerViewController *albumPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPickerViewController"];
    [albumPicker setImageData:[self loadAlbums]];
    albumPicker.albumType = kTypeRight;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:albumPicker];
    popover.delegate = self;
    popover.contentSize = CGSizeMake(220, 320);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromView:_btnRight];
}

- (IBAction)selectDownClick:(id)sender {
    AlbumPickerViewController *albumPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPickerViewController"];
    [albumPicker setImageData:[self loadAlbums]];
    albumPicker.albumType = kTypeBottom;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:albumPicker];
    popover.delegate = self;
    popover.contentSize = CGSizeMake(220, 290);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromView:_btnBottom];
}

- (IBAction)selectLeftClick:(id)sender {
    AlbumPickerViewController *albumPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPickerViewController"];
    [albumPicker setImageData:[self loadAlbums]];
    albumPicker.albumType = kTypeLeft;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:albumPicker];
    popover.delegate = self;
    popover.contentSize = CGSizeMake(220, 320);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromView:_btnLeft];
}

#pragma mark - FPPopoverController Delegate
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController
{
    [self setButtonTitle];
}

- (void) setButtonTitle {
    NSString *albumTop = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeTop];
    if (albumTop) {
        _labelTop.text = albumTop;
    }
    NSString *albumRight = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeRight];
    if (albumRight) {
        _labelRight.text = albumRight;
    }
    NSString *albumBottom = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeBottom];
    if (albumBottom) {
        _labelBottom.text = albumBottom;
    }
    NSString *albumLeft = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeLeft];
    if (albumLeft) {
        _labelLeft.text = albumLeft;
    }
}

@end
