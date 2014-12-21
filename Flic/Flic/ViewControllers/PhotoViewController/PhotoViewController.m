//
//  ViewController.m
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "PhotoViewController.h"
#import "NSUserDefaults+Reminder.h"
#import "AppDelegate.h"
#import "ImageHolder.h"

#define kImageTag 100
#define kTypeTrash 1
#define kTypeKeep  1
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define kImageHeight 300
#define kStart 65

@interface PhotoViewController ()

@property (nonatomic, assign) BOOL              isPurchased;
@property (nonatomic, assign) BOOL              noAds;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phImagePicker = [[PHImagePicker alloc] init];
    _imageManager = [PHImageManager defaultManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoPushback:) name:kPhotoPushbackNotify object:nil];
    
//    _isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:kPurchased];
//    CGRect appframe = [[UIScreen mainScreen] bounds];
//    
//    if (!_isPurchased) {
//        _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, appframe.size.height - 50, appframe.size.width, 50)];
//        _adView.delegate = self;
//        _adView.hidden = TRUE;
//    }
    
//    [self.view addSubview:_adView];
    
//    [self loadIntersial]
    
    /*
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
     */
    
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    
    if (!IS_IPHONE_5) {
        [_introText setFrame:CGRectMake(_introText.frame.origin.x, appFrame.size.height - _introText.frame.size.height - 70, _introText.frame.size.width, _introText.frame.size.height)];
        [_btnTrash setFrame:CGRectMake(_btnTrash.frame.origin.x, appFrame.size.height - _btnTrash.frame.size.height - 5, _btnTrash.frame.size.width, _btnTrash.frame.size.height)];
        [_btnKeep setFrame:CGRectMake(_btnKeep.frame.origin.x, appFrame.size.height - _btnKeep.frame.size.height - 5, _btnKeep.frame.size.width, _btnKeep.frame.size.height)];
    }
    
    self.view.userInteractionEnabled = YES;
    
    _badgeInfo.layer.cornerRadius = 8;
    _badgeInfo.layer.masksToBounds = YES;
    
    _totalSortedImage = 0;
    _totalSize = 0;
    _totalTrash = 0;
    _totalKeep = 0;
    _lastIsTrash = false;
    _badgeInfo.hidden = YES;
    _imageDisplay = [[NSMutableArray alloc] initWithCapacity:0];
    _infoDisplay = [[NSMutableArray alloc] initWithCapacity:0];
    _trashImage = [[NSMutableArray alloc] initWithCapacity:0];
    _undoImage = [[NSMutableArray alloc] initWithCapacity:0];
    _undoPosition = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self transformText:_albumLeft transform:-M_PI_2];
    [self transformText:_albumRight transform:M_PI_2];
    [self transformText:_badgeLeft transform:-M_PI_2];
    [self transformText:_badgeRight transform:M_PI_2];
    
    [self formatLabel:_albumBottom];
    [self formatLabel:_albumLeft];
    [self formatLabel:_albumRight];
    [self formatLabel:_albumTop];
    
    [self initializeAlbum];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _imageHeight = _albumBottom.frame.origin.y - _albumTop.frame.origin.y - 48;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_imageHeight] forKey:kHeight];
    
    [self initImageHolder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreImageHolder:) name:kImageNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageSize:) name:kUpdateSize object:nil];
    
//    [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
    [self loadBanner];
}

#pragma mark - LOAD BANNER
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [interstitial_ presentFromRootViewController:self];
    
    bannerShown = TRUE;
    
//    [self loadBanner];
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
        
        bannerIsVisible = YES;
        [_adView setHidden:!bannerIsVisible];
        
        [self.view bringSubviewToFront:_adView];
    }
}

//when any problems occured
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        bannerIsVisible = NO;
        [_adView setHidden:!bannerIsVisible];
        
        [UIView commitAnimations];
    }
    
    [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
}

- (void) loadBanner {
    CGRect appframe= [[UIScreen mainScreen] bounds];
    
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            appframe.size.height - 50,
                                            (appframe.size.width - GAD_SIZE_320x50.width) / 2,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    bannerView_.delegate = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[ GAD_SIMULATOR_ID ];
    [bannerView_ loadRequest:request];
    
    [self.view addSubview:bannerView_];
    [self.view bringSubviewToFront:bannerView_];
}

#pragma mark GADRequest generation
- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
//        request.testDevices = @[
//                                // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
//                                // the console when the app is launched.
//                                GAD_SIMULATOR_ID
//                                ];
    return request;
}
// END LOAD BANNER

- (void) formatLabel:(UILabel*) label {
    label.layer.cornerRadius = 10;
    label.layer.borderWidth = 1;
    label.clipsToBounds = YES;
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor colorWithRed:245.0f/255.0f green:152.0f/255.0f blue:24.0f/255.0f alpha:1];
}

- (void) transformText:(UILabel*) label transform: (float) angle {
    CGRect frame = label.frame;
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(frame.size.width/2 + frame.origin.x, frame.size.height/2 + frame.origin.y);
    label.transform = CGAffineTransformMakeRotation(angle);
}

- (void) initializeAlbum {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSString *albumTop = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeTop];
    _phAlbumTop = appDelegate.phAlbumTop;
    
    if (albumTop) {
        _albumTop.text = albumTop;
    }
    NSString *albumRight = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeRight];
    _phAlbumRight = appDelegate.phAlbumRight;
    
    if (albumRight) {
        _albumRight.text = albumRight;
    }
    NSString *albumBottom = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeBottom];
    _phAlbumBottom = appDelegate.phAlbumBottom;
    
    if (albumBottom) {
        _albumBottom.text = albumBottom;
    }
    NSString *albumLeft = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeLeft];
    _phAlbumLeft = appDelegate.phAlbumLeft;
    
    if (albumLeft) {
        _albumLeft.text = albumLeft;
    }
    
    _badgeTop.text = @"0";
    _badgeRight.text = @"0";
    _badgeBottom.text = @"0";
    _badgeLeft.text = @"0";
    _badgeTop.hidden = YES;
    _badgeRight.hidden = YES;
    _badgeBottom.hidden = YES;
    _badgeLeft.hidden = YES;
    
    _phAlbums = [[NSMutableDictionary alloc] initWithCapacity:0];
    _phBadges = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (_phAlbumTop) {
        [_phAlbums setObject:_phAlbumTop forKey:kTypeTop];
        [_phBadges setObject:_badgeTop forKey:kTypeTop];
        _badgeTop.hidden = NO;
    }
    if (_phAlbumRight) {
        [_phAlbums setObject:_phAlbumRight forKey:kTypeRight];
        [_phBadges setObject:_badgeRight forKey:kTypeRight];
        _badgeRight.hidden = NO;
    }
    if (_phAlbumBottom) {
        [_phAlbums setObject:_phAlbumBottom forKey:kTypeBottom];
        [_phBadges setObject:_badgeBottom forKey:kTypeBottom];
        _badgeBottom.hidden = NO;
    }
    if (_phAlbumLeft) {
        [_phAlbums setObject:_phAlbumLeft forKey:kTypeLeft];
        [_phBadges setObject:_badgeLeft forKey:kTypeLeft];
        _badgeLeft.hidden = NO;
    }
    
    [self styleBadge:_badgeTop];
    [self styleBadge:_badgeLeft];
    [self styleBadge:_badgeRight];
    [self styleBadge:_badgeBottom];
}

- (void) styleBadge:(UILabel*) badgeLabel {
    badgeLabel.layer.cornerRadius = 5;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.backgroundColor = [UIColor greenColor];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [bannerView_ removeFromSuperview];
    [_adView removeFromSuperview];
}

- (IBAction)imgClick:(id)sender
{
    
}

- (void) initImageHolder
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    _total = (int) _imageData.count;
    
    int start = kStart;
    int xStart = 40;
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    for (int i = 0; i < 3;i++) {
        if (i < _total && [_imageDisplay count] < 3 && _total > [_imageDisplay count]) {
            ImageHolder *imgHolder1 = [[ImageHolder alloc] initWithFrame:CGRectMake(xStart - i*10, start + i*5, self.view.frame.size.width - 80 + i*20, imgHeight)];
            UIImageView *imgView1 = [[UIImageView alloc] init];
            [imgHolder1 setImageView:imgView1];
            [imgHolder1 setInfo:@""];
            [imgHolder1 setTag:kImageTag];
    //        [imgHolder1 setAsset:[_imageData objectAtIndex:_total - i - 1]];
            [imgHolder1 performSelectorInBackground:@selector(setPhAsset:) withObject:[_imageData objectAtIndex:_total - i - 1]];
        
            [_imageDisplay addObject:imgHolder1];
            [self.view addSubview:imgHolder1];
        }
    }
    
    [self bringAlbumToFront];
    
//    [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
}

- (void) bringAlbumToFront {
    [self.view bringSubviewToFront:_leftAlbumView];
    [self.view bringSubviewToFront:_rightAlbumView];
    
    [self.view bringSubviewToFront:_albumTop];
    [self.view bringSubviewToFront:_albumBottom];
    [self.view bringSubviewToFront:_arrowTop];
    [self.view bringSubviewToFront:_arrowBottom];
    [self.view bringSubviewToFront:_badgeTop];
    [self.view bringSubviewToFront:_badgeBottom];
    
    [self.view bringSubviewToFront:bannerView_];
}

#pragma MARK - Photo Push back
- (void) photoPushback:(NSNotification*) notify
{
    _badgeInfo.text = @"0";
    _badgeInfo.hidden = YES;
    
    NSDictionary *info = notify.userInfo;
    NSArray *rImageData = [info objectForKey:@"info"];
    NSLog(@"Total ImageData %d", (int) [rImageData count]);
    
    if ([rImageData count] > 0 || [_imageData count] > 0) {
        [self performSelectorOnMainThread:@selector(arrangeImage:) withObject:rImageData waitUntilDone:NO];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) arrangeImage:(NSArray*) rImageData
{
    [_imageData addObjectsFromArray:rImageData];
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    [self initImageHolder];
    
    [_trashImage removeAllObjects];
    [_undoImage removeAllObjects];
    _totalTrash = 0;
    _totalSize = 0;
    [_imageSize setText:@"0 MB"];
    
    [self showImages];
    [self animationImage];
}

- (void) showImages
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK - BUTTON ACTION
- (IBAction)trashClick:(id)sender {
    if (_total > 0) {
        [self doTrash];
    }
}

- (IBAction)keepClick:(id)sender {
    if (_total > 0) {
        [self doKeep];
    }
}

- (void) revealNewImageHolder
{
    int index = (int)( _imageData.count - _imageDisplay.count - 1 );
    NSLog(@"Reveal %d", index);
    if (index >= 0 && _imageData.count > 0) {
//        if ([_imageData count] > 3) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            
            int imgHeight = kImageHeight;
            if (!IS_IPHONE_5) {
                imgHeight = 200;
            }
            
            ImageHolder *newImgHolder = [[ImageHolder alloc] initWithFrame:CGRectMake(50, 80, self.view.frame.size.width - 100, imgHeight)];
            [newImgHolder setTag:kImageTag];
            UIImageView *imgView3 = [[UIImageView alloc] init];
            [newImgHolder setImageView:imgView3];
        
            [newImgHolder performSelectorInBackground:@selector(setPhAsset:) withObject:[_imageData objectAtIndex:index]];
        
            [self.view addSubview:newImgHolder];
            [self.view sendSubviewToBack:newImgHolder];
            [_imageDisplay insertObject:newImgHolder atIndex:0];
            
            [self animationImage];
//        }
    } else if ([_imageData count] == 0) {
        // Show Trash
        [self showFinish];
    }
    
    [self bringAlbumToFront];
}

- (void) reArrangeImgHolder:(int) imgType
{
    // Remove first index
    if ([_imageDisplay count] == 3)
        [_imageDisplay removeObjectAtIndex:0];
    
    int index = (int) [_imageData count] - 1;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    ImageHolder *newImgHolder = [[ImageHolder alloc] initWithFrame:CGRectMake(50, 80, self.view.frame.size.width - 100, imgHeight)];
    [newImgHolder setTag:kImageTag];
    UIImageView *imgView3 = [[UIImageView alloc] init];
    [newImgHolder setImageView:imgView3];
    
    [newImgHolder performSelectorInBackground:@selector(setPhAsset:) withObject:[_imageData objectAtIndex:index]];
    if (imgType == kTypeTrash) {
        newImgHolder.mustPush = TRUE;
    }
    
    [self.view addSubview:newImgHolder];
    [self.view sendSubviewToBack:newImgHolder];
    
//    [newImgHolder setPhAsset:[_imageData objectAtIndex:index]];
    
//    [newImgHolder.imageView setImage:[[_imageData objectAtIndex:index] objectForKey:UIImagePickerControllerOriginalImage]];
//    NSString *date = [NSString stringWithFormat:@"%@MB - %@", [[_imageData objectAtIndex:index] objectForKey:@"PhotoSize"], [dateFormatter stringFromDate:[[_imageData objectAtIndex:index] objectForKey:@"PhotoDate"]] ];
//    newImgHolder.info = date;
    [_imageDisplay addObject:newImgHolder];
    
    [self animationImage];
    
    [self bringAlbumToFront];
}

- (void) animationImage
{
    int start = kStart;
    int xStart = 40;
    
    for (int i = 0;i < _imageDisplay.count;i++) {
        ImageHolder *img = [_imageDisplay objectAtIndex:i];
        img.trashBg.backgroundColor = [UIColor colorWithRed:173.0/255.0 green:103.0/255.0 blue:201.0/255.0 alpha:1.0];
        img.keepBg.backgroundColor = [UIColor colorWithRed:169.0/255.0 green:177.0/255.0 blue:184.0/255.0 alpha:1.0];
        CGRect frame = img.frame;
        
        int imgHeight = kImageHeight;
        if (!IS_IPHONE_5) {
            imgHeight = 200;
        }
        
        NSLog(@"frame %@", NSStringFromCGRect(frame));
        img.frame = CGRectMake(xStart - i*10, start + i*10, self.view.frame.size.width - 80 + i*20, imgHeight);
        NSLog(@"after frame %@\n", NSStringFromCGRect(img.frame));
        
        img.trashBg.frame = CGRectMake(0, 0, img.frame.size.width, img.frame.size.height);
        img.keepBg.frame = CGRectMake(0, 0, img.frame.size.width, img.frame.size.height);
        
        [self.view bringSubviewToFront:img];
    }
}

- (void) doTrash
{
    [_btnUndo setEnabled:YES];
    
    _totalTrash++;
    _lastIsTrash = true;
    if (_totalTrash > 0) {
        _badgeInfo.hidden = NO;
    }
    _badgeInfo.text = [NSString stringWithFormat:@"%d", _totalTrash];
    _total = (int) _imageData.count;
    
    NSLog(@"Remain %d", _total);
    ImageHolder *imgHolder = [_imageDisplay objectAtIndex:_imageDisplay.count - 1];
    imgHolder.isTrash = YES;
    
//    PHAsset *toTrash = [_imageData objectAtIndex:_total - 1];
    PHAsset *toTrash = imgHolder.phAsset;
    
    _totalSize += imgHolder.imgSize;
    [_imageSize setText:[NSString stringWithFormat:@"%.2f MB", _totalSize]];
    [_trashImage addObject:toTrash];
    
    [_imageDisplay removeObjectAtIndex:_imageDisplay.count - 1];
    [_undoImage addObject:imgHolder];
    [imgHolder removeFromSuperview];
    [_imageData removeObject:toTrash];
    _total = (int) _imageData.count;
    
    if ([_undoImage count] > 3)
        [_undoImage removeObjectsInRange:NSMakeRange(0, [_undoImage count] - 3)];
    
    [self revealNewImageHolder];
}

- (void) doKeep
{
    [_btnUndo setEnabled:YES];
    
    _totalKeep++;
    _lastIsTrash = false;
    
    _total = (int) _imageData.count;
//    PHAsset *toKeep = [_imageData objectAtIndex:_total - 1];
    
    ImageHolder *imgHolder = [_imageDisplay objectAtIndex:_imageDisplay.count - 1];
    imgHolder.isKeep = YES;
    PHAsset *toKeep = imgHolder.phAsset;
    
    [_imageDisplay removeObjectAtIndex:_imageDisplay.count - 1];
    [_undoImage addObject:imgHolder];
    [imgHolder removeFromSuperview];
    [_imageData removeObject:toKeep];
    _total = (int) _imageData.count;
    
    if ([_undoImage count] > 3)
        [_undoImage removeObjectsInRange:NSMakeRange(0, [_undoImage count] - 3)];
    
    [self revealNewImageHolder];
}

#pragma mark - Move to one album
- (void) increaseBadge:(UILabel*) label {
    int current = [label.text intValue];
    current++;
    
    label.text = [NSString stringWithFormat:@"%d", current];
}

- (void) decreaseBadge:(UILabel*) label {
    int current = [label.text intValue];
    current--;
    
    label.text = [NSString stringWithFormat:@"%d", current];
}

- (void) addPhotoToAlbum:(PHCollection*) album withTouchView:(ImageHolder*) touchView{
    if (album) {
        [_btnUndo setEnabled:YES];
        
        _total = (int) _imageData.count;
        
        ImageHolder *imgHolder = [_imageDisplay objectAtIndex:_imageDisplay.count - 1];
        imgHolder.isKeep = YES;
        PHAsset *phAsset = imgHolder.phAsset;
        
        // Add this photo to album
        [self addPhoto:phAsset toCollection:album];
        
        [_imageDisplay removeObjectAtIndex:_imageDisplay.count - 1];
        [_undoImage addObject:imgHolder];
        [_undoPosition addObject:_lastPosition];
        [imgHolder removeFromSuperview];
        [_imageData removeObject:phAsset];
        _total = (int) _imageData.count;
        
        if ([_undoImage count] > 3)
            [_undoImage removeObjectsInRange:NSMakeRange(0, [_undoImage count] - 3)];
        if ([_undoPosition count] > 3)
            [_undoPosition removeObjectsInRange:NSMakeRange(0, [_undoImage count] - 3)];
        
        [self revealNewImageHolder];
    } else {
        // Put to normal position
        touchView.center = _normalPoint;
        
        touchView.trashBg.hidden = YES;
        touchView.keepBg.hidden = YES;
    }
}

- (void) addPhoto:(PHAsset*) photo toCollection:(PHCollection*) collection {
    _totalSortedImage++;
    
    PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        [changeRequest addAssets:[NSArray arrayWithObject:photo]];
        
        NSLog(@"Adding asset to %@...", changeRequest.title);
    } completionHandler:^(BOOL success, NSError *error){
        
    }];
}

- (void) removePhoto:(PHAsset*) photo fromCollection:(PHCollection*) collection {
    PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        [changeRequest removeAssets:[NSArray arrayWithObject:photo]];
        
        NSLog(@"Adding asset to %@...", changeRequest.title);
    } completionHandler:^(BOOL success, NSError *error){
        
    }];
}

- (IBAction)undoClick:(id)sender {
    if ([_undoImage count] > 0) {
        ImageHolder *imgHolder = [_undoImage lastObject];
        --_totalSortedImage;
        
        PHAsset *asset = imgHolder.phAsset;
        [_imageData addObject:asset];
        
        // Remove photo from collection
        NSString *undoPosition = [_undoPosition lastObject];
        [self removePhoto:asset fromCollection:[_phAlbums objectForKey:undoPosition]];
        [self decreaseBadge:[_phBadges objectForKey:undoPosition]];
        
        [self reArrangeImgHolder:kTypeTrash];
        [_undoImage removeLastObject];
        [_undoPosition removeLastObject];
        [_trashImage removeLastObject];
        
        if ([_undoImage count] == 0)
            [_btnUndo setEnabled:NO];
    }
}

- (IBAction)emptyTrashClick:(id)sender {
    if ([_trashImage count] > 0) {
        [self showFinish];
    } else {
        UIAlertController *alertFinish = [UIAlertController alertControllerWithTitle:@"You need to add some pictures to your trash first ..." message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertFinish addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertFinish animated:YES completion:nil];
    }
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneClick:(id)sender
{
    [self showFinish];
}

- (void) showFinish
{
    FinishViewController *finishController = [self.storyboard instantiateViewControllerWithIdentifier:@"FinishViewController"];
    finishController.totalImage = _totalSortedImage;
    
    [self presentViewController:finishController animated:YES completion:^{
        
    }];
}

#pragma mark - USER TOUCHES
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch Began");
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if ([[touch.view class] isSubclassOfClass:[ImageHolder class]]) {
        ImageHolder *touchView = (ImageHolder*) touch.view;
        int tag = (int) touchView.tag;
        if (tag == kImageTag) {
            if (CGRectContainsPoint(touchView.frame, touchLocation)) {
                _touchStarted = true;
                _normalPoint = touchView.center;
                
                _oldX = touchLocation.x;
                _oldY = touchLocation.y;
            }
            
        } else {
            _touchStarted = false;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Move action");
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    float x = touchLocation.x;
    float y = touchLocation.y;
    
    if (_touchStarted) {
        ImageHolder *touchView = (ImageHolder*) touch.view;
        NSLog(@"Moving %@", touchView);
        
        if ([touchView isKindOfClass:[ImageHolder class]]) {
            touchView.isMoving = TRUE;
            
            touchView.center = touchLocation;
            CGRect frame = self.view.frame;
            float centerX = frame.size.width/2;
            float centerY = frame.size.height/2;
            float ratioX = abs(centerX - x) / centerX;
            float ratioY = abs(centerY - y) / centerY;
            
            if (x < (frame.size.width/2.0f - 20)) {
                NSLog(@"Moving Left");
                
//                touchView.trashBg.hidden = NO;
//                touchView.trashBg.alpha = ratioX;
//                touchView.keepBg.hidden = YES;
            } else if (x > (frame.size.width/2.0f + 20)) {
                NSLog(@"Moving Right");
                
//                touchView.keepBg.hidden = NO;
//                touchView.keepBg.alpha = ratioX;
//                touchView.trashBg.hidden = YES;
            } else if (y < (centerY - 20)) {
                NSLog(@"Moving Top");
                
//                touchView.trashBg.hidden = NO;
//                touchView.trashBg.alpha = ratioY;
//                touchView.keepBg.hidden = YES;
            } else if (y > (centerY + 20)) {
                NSLog(@"Moving Bottom");
                
//                touchView.keepBg.hidden = NO;
//                touchView.keepBg.alpha = ratioY;
//                touchView.trashBg.hidden = YES;
            } else {
                touchView.trashBg.hidden = YES;
                touchView.keepBg.hidden = YES;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Ended");
    
    if (_touchStarted) {
        UITouch *touch = [touches anyObject];
        ImageHolder *touchView = (ImageHolder*) touch.view;
        
        if ([touchView isKindOfClass:[ImageHolder class]]) {
            touchView.isMoving = false;
            
            CGPoint touchLocation = [touch locationInView:self.view];
            float x = touchLocation.x;
            float y = touchLocation.y;
            
            CGRect frame = self.view.frame;
            NSLog(@"Got x: %f - y: %f", x, y);
            float centerY = frame.size.height/2;
            
            if (x < (frame.size.width/2.0f - 50)) {
                if (_total > 0) {
                    _lastPosition = kTypeLeft;
                    NSLog(@"Need move to album Left");
                    
                    [self addPhotoToAlbum:[_phAlbums objectForKey:_lastPosition] withTouchView: touchView];
                    [self increaseBadge:[_phBadges objectForKey:_lastPosition]];
                    
                    _touchStarted = NO;
                }
            } else if (x > (frame.size.width/2.0f + 50)) {
                if (_total > 0) {
                    _lastPosition = kTypeRight;
                    NSLog(@"Need move to album Right");
                    
                    [self addPhotoToAlbum:[_phAlbums objectForKey:_lastPosition] withTouchView: touchView];
                    [self increaseBadge:[_phBadges objectForKey:_lastPosition]];
                    
                    _touchStarted = NO;
                }
            } else if (y < (centerY - 50)) {
                if (_total > 0) {
                    _lastPosition = kTypeTop;
                    NSLog(@"Need move to album Top");
                    
                    [self addPhotoToAlbum:[_phAlbums objectForKey:_lastPosition] withTouchView: touchView];
                    [self increaseBadge:[_phBadges objectForKey:_lastPosition]];
                    
                    _touchStarted = NO;
                }
            } else if (y > (centerY + 50)) {
                if (_total > 0) {
                    _lastPosition = kTypeBottom;
                    NSLog(@"Need move to album Bottom");
                    
                    [self addPhotoToAlbum:[_phAlbums objectForKey:_lastPosition] withTouchView: touchView];
                    [self increaseBadge:[_phBadges objectForKey:_lastPosition]];
                    
                    _touchStarted = NO;
                }
            } else {
                NSLog(@"Putting to normal");
                
                // Put to normal position
                touchView.center = _normalPoint;
                
                touchView.trashBg.hidden = YES;
                touchView.keepBg.hidden = YES;
            }
            
            _touchStarted = NO;
        }
    }
}

#pragma mark - Notification
- (void) restoreImageHolder:(NSNotification*) notify {
    id object = [notify object];
    
    if ([object isKindOfClass:[ImageHolder class]]) {
        ImageHolder *touchView = (ImageHolder*) object;
        touchView.isMoving = false;
        
        NSLog(@"Putting to normal");
        _touchStarted = NO;
        
        // Put to normal position
        touchView.center = _normalPoint;
        
        touchView.trashBg.hidden = YES;
        touchView.keepBg.hidden = YES;
    }
}

- (void) updateImageSize: (NSNotification*) notify {
    id object = [notify object];
    
    if ([object isKindOfClass:[ImageHolder class]]) {
        ImageHolder *imgHolder = (ImageHolder*) object;
        
        _totalSize -= imgHolder.imgSize;
        [_imageSize setText:[NSString stringWithFormat:@"%.2f MB", _totalSize]];
    }
}

@end
