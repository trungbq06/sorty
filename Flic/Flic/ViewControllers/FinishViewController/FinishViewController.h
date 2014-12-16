//
//  FinishViewController.h
//  Flic
//
//  Created by TrungBQ on 12/13/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>

@interface FinishViewController : UIViewController <ADBannerViewDelegate, MFMailComposeViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbTotalSorted;
@property (nonatomic, retain) ADBannerView          *adView;

@property (nonatomic, assign) int   totalImage;
@property (weak, nonatomic) IBOutlet UILabel *btnRestartClick;
- (IBAction)btnEmailClick:(id)sender;
- (IBAction)btnTwitterClick:(id)sender;
- (IBAction)btnFacebookClick:(id)sender;
- (IBAction)btnInappClick:(id)sender;
- (IBAction)btnAdsClick:(id)sender;
- (IBAction)btnRestartClick:(id)sender;
- (IBAction)btnFeedbackClick:(id)sender;
- (IBAction)reviewClick:(id)sender;

@end
