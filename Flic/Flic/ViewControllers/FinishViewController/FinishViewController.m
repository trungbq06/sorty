//
//  FinishViewController.m
//  Flic
//
//  Created by TrungBQ on 12/13/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "FinishViewController.h"
#import "SVProgressHUD.h"
#import <Social/Social.h>
#import "StartViewController.h"
#import <MessageUI/MessageUI.h>

@interface FinishViewController () {
    NSArray *_products;
}

@property (nonatomic, assign) BOOL              isPurchased;

@end

@implementation FinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:kPurchased];
    CGRect appframe = [[UIScreen mainScreen] bounds];
    
    if (!_isPurchased) {
        _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, appframe.size.height - 50, appframe.size.width, 50)];
        _adView.delegate = self;
        _adView.alpha = 0;
    }
    
    _lbTotalSorted.text = [NSString stringWithFormat:@"%d", _totalImage];
}

#pragma mark - AdBannerViewDelegate method implementation

-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad Banner will load ad.");
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad Banner did load ad.");
    
    // Show the ad banner.
    [UIView animateWithDuration:0.5 animations:^{
        _adView.alpha = 1.0;
    }];
}


-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    NSLog(@"Ad Banner action is about to begin.");
    
    return YES;
}


-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad Banner action did finish");
    
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Unable to show ads. Error: %@", [error localizedDescription]);
    
    // Hide the ad banner.
    [UIView animateWithDuration:0.5 animations:^{
        _adView.alpha = 0.0;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnEmailClick:(id)sender {
    MFMailComposeViewController *mViewController = [[MFMailComposeViewController alloc] init];
    mViewController.mailComposeDelegate = self;
    [mViewController setSubject:@"Sort Photos"];
    [mViewController setMessageBody:@"Best photos app that you ever experience !" isHTML:NO];
    
    [self presentViewController:mViewController animated:TRUE completion:nil];
}

- (IBAction)btnTwitterClick:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSString *message = [NSString stringWithFormat:@"Wow, I sorted out %d #iPhone Photos in few minutes only using #Sorty App by @AppDeveloper99 *%@*", _totalImage, kReviewURL];
        
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:message];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)btnFacebookClick:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Wow, I sorted out %d #iPhone Photos in few minutes only using #Sorty App by @AppDeveloper99 *%@*", _totalImage, kReviewURL];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:message];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)btnInappClick:(id)sender {
    [SVProgressHUD showWithStatus:@"Processing ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSArray *identifiers = [NSArray arrayWithObjects:@"", nil];
    [self validateProductIdentifiers:identifiers];
}

- (IBAction)btnAdsClick:(id)sender {
    
}

- (IBAction)btnRestartClick:(id)sender {
    StartViewController *startController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:startController];
    navController.navigationBarHidden = YES;
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:navController];
}

- (IBAction)btnFeedbackClick:(id)sender {
    MFMailComposeViewController *mViewController = [[MFMailComposeViewController alloc] init];
    mViewController.mailComposeDelegate = self;
    [mViewController setSubject:@"Sorty Feedback"];
    [mViewController setMessageBody:@"" isHTML:NO];
    [mViewController setToRecipients:@[@"appdeveloper99@gmail.com"]];
    
    [self presentViewController:mViewController animated:TRUE completion:nil];
}

- (IBAction)reviewClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kReviewURL]];
}

#pragma mark - Message Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Message Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - RETRIEVE PRODUCT INFORMATION
// Custom method
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for(SKProduct *aProduct in response.products){
        NSLog(@"%@", aProduct.productIdentifier);
    }
    _products = response.products;
    
    if ([_products count] > 0) {
        SKProduct * product = (SKProduct *) _products[0];
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
    [SVProgressHUD dismiss];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    [SVProgressHUD dismiss];
    for(SKPaymentTransaction *transaction in transactions){
        //        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing){
            NSLog(@"Transaction state -> Purchasing");
            //called when the user is in the process of purchasing, do not add any of your own code here.
            [SVProgressHUD showWithStatus:@"Processing ..." maskType:SVProgressHUDMaskTypeBlack];
        }else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            //this is called when the user has successfully purchased the package (Cha-Ching!)
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPurchased];
            [_adView removeFromSuperview];
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
            NSLog(@"Transaction state -> Purchased");
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            NSLog(@"Transaction state -> Restored");
            //add the same code as you did from SKPaymentTransactionStatePurchased here
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            //called when the transaction does not finnish
            if(transaction.error.code != SKErrorPaymentCancelled){
                NSLog(@"Transaction state -> Cancelled");
                //the user cancelled the payment ;(
            }
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}

@end
