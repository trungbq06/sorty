//
//  ViewController.h
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHolder.h"
#import "PHImagePicker.h"
#import <iAd/iAd.h>
#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "FinishViewController.h"

#define kPhotoPushbackNotify @"push_back_notify"

@interface PhotoViewController : UIViewController <GADBannerViewDelegate, GADInterstitialDelegate, ADBannerViewDelegate>
{
    //AdMob
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
    
    BOOL bannerIsVisible;
    BOOL bannerShown;
}

@property (nonatomic, retain) ADBannerView          *adView;
@property (nonatomic, retain) NSMutableArray *imageData;

@property (nonatomic, retain) PHImagePicker  *phImagePicker;
@property (nonatomic, retain) PHImageManager *imageManager;

@property (assign)            int            total;
@property (assign)            int            totalTrash;
@property (assign)            int            totalKeep;
@property (assign)            BOOL           lastIsTrash;
@property (nonatomic, retain) NSMutableArray *imageDisplay;
@property (nonatomic, retain) NSMutableArray *infoDisplay;
@property (nonatomic, retain) NSMutableArray *imgDataDisplay;
@property (weak, nonatomic) IBOutlet UILabel *badgeInfo;
@property (nonatomic, retain) NSMutableArray *trashImage;
@property (nonatomic, retain) NSMutableArray *undoImage;
@property (nonatomic, retain) NSMutableArray *undoPosition;
@property (assign)            BOOL           touchStarted;
@property (assign)            CGPoint        normalPoint;
@property (weak, nonatomic) IBOutlet UITextView *introText;
@property (weak, nonatomic) IBOutlet UIButton *btnTrash;
@property (weak, nonatomic) IBOutlet UIButton *btnKeep;
@property (nonatomic, retain) ImageHolder    *tmpImageHolder;

@property (assign)            float          oldX;
@property (assign)            float          oldY;

@property (weak, nonatomic) IBOutlet UILabel *imageSize;
@property (assign)          float            totalSize;
@property (weak, nonatomic) IBOutlet UIButton *btnUndo;

@property (weak, nonatomic) IBOutlet UIImageView *arrowRight;
@property (weak, nonatomic) IBOutlet UIImageView *arrowLeft;
@property (weak, nonatomic) IBOutlet UIImageView *arrowTop;
@property (weak, nonatomic) IBOutlet UIImageView *arrowBottom;
@property (weak, nonatomic) IBOutlet UILabel *albumTop;
@property (weak, nonatomic) IBOutlet UILabel *albumRight;
@property (weak, nonatomic) IBOutlet UILabel *albumBottom;
@property (weak, nonatomic) IBOutlet UILabel *albumLeft;

@property (nonatomic, retain) PHCollection   *phAlbumTop;
@property (nonatomic, retain) PHCollection   *phAlbumRight;
@property (nonatomic, retain) PHCollection   *phAlbumLeft;
@property (nonatomic, retain) PHCollection   *phAlbumBottom;

@property (nonatomic, retain) NSString       *lastPosition;
@property (nonatomic, retain) NSMutableDictionary *phAlbums;
@property (nonatomic, retain) NSMutableDictionary *phBadges;

@property (nonatomic, assign) int           totalSortedImage;
@property (nonatomic, assign) int           imageHeight;
@property (weak, nonatomic) IBOutlet UIView *rightAlbumView;
@property (weak, nonatomic) IBOutlet UIView *leftAlbumView;
@property (weak, nonatomic) IBOutlet UILabel *badgeTop;
@property (weak, nonatomic) IBOutlet UILabel *badgeRight;
@property (weak, nonatomic) IBOutlet UILabel *badgeBottom;
@property (weak, nonatomic) IBOutlet UILabel *badgeLeft;

- (IBAction)trashClick:(id)sender;
- (IBAction)keepClick:(id)sender;
- (IBAction)undoClick:(id)sender;
- (IBAction)emptyTrashClick:(id)sender;
- (IBAction)backClick:(id)sender;
- (IBAction)btnDoneClick:(id)sender;

@end

