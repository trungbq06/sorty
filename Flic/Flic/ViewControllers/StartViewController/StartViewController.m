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
#import "FPPopoverController.h"

@interface StartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnTop;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;

@property (nonatomic, retain) UIBarButtonItem *barBtnTop;
@property (nonatomic, retain) UIBarButtonItem *barBtnRight;
@property (nonatomic, retain) UIBarButtonItem *barBtnBottom;
@property (nonatomic, retain) UIBarButtonItem *barBtnLeft;

- (IBAction)selectTopClick:(id)sender;
- (IBAction)selectRightClick:(id)sender;
- (IBAction)selectDownClick:(id)sender;
- (IBAction)selectLeftClick:(id)sender;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phImagePicker = [[PHImagePicker alloc] init];
    
    _barBtnTop = [[UIBarButtonItem alloc] initWithCustomView:_btnTop];
    _barBtnRight = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    _barBtnBottom = [[UIBarButtonItem alloc] initWithCustomView:_btnBottom];
    _barBtnLeft = [[UIBarButtonItem alloc] initWithCustomView:_btnLeft];
    
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
    popover.contentSize = CGSizeMake(220, 320);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromView:_btnTop];
}

- (IBAction)selectRightClick:(id)sender {
    AlbumPickerViewController *albumPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPickerViewController"];
    [albumPicker setImageData:[self loadAlbums]];
    albumPicker.albumType = kTypeRight;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:albumPicker];
    popover.contentSize = CGSizeMake(220, 320);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromView:_btnRight];
}

- (IBAction)selectDownClick:(id)sender {
    AlbumPickerViewController *albumPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPickerViewController"];
    [albumPicker setImageData:[self loadAlbums]];
    albumPicker.albumType = kTypeBottom;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:albumPicker];
    popover.contentSize = CGSizeMake(220, 320);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromView:_btnBottom];
}

- (IBAction)selectLeftClick:(id)sender {
    AlbumPickerViewController *albumPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPickerViewController"];
    [albumPicker setImageData:[self loadAlbums]];
    albumPicker.albumType = kTypeLeft;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:albumPicker];
    popover.contentSize = CGSizeMake(220, 320);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromView:_btnLeft];
}

@end
