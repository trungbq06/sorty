//
//  StartViewController.h
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PHImagePicker.h"
#import <iAd/iAd.h>
#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "FPPopoverController.h"

@interface StartViewController : UIViewController <FPPopoverControllerDelegate, GADBannerViewDelegate, GADInterstitialDelegate, ADBannerViewDelegate>
{
    //AdMob
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
    
    ADBannerView *adView;
    
    BOOL bannerIsVisible;
    BOOL bannerShown;
}

@property (nonatomic, retain) ADBannerView          *adView;
@property (nonatomic, assign) BOOL              noAds;
@property (weak, nonatomic) IBOutlet UIButton   *btnSelect;
@property (nonatomic, retain) IBOutlet UILabel  *bottomText;

@property (nonatomic, retain) PHImagePicker     *phImagePicker;

- (IBAction)btnSelectClick:(id)sender;

@end
