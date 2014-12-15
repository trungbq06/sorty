//
//  SelectDateViewController.m
//  Flic
//
//  Created by TrungBQ on 12/13/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "SelectDateViewController.h"
#import "PhotoViewController.h"
#import "SVProgressHUD.h"

@interface SelectDateViewController ()

@end

@implementation SelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phImagePicker = [[PHImagePicker alloc] init];
    
    _startDate.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _endDate.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _startDate.layer.borderWidth = 1;
    _endDate.layer.borderWidth = 1;
    _btnSelect.layer.borderWidth = 1;
    
    _btnSelect.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _startDate.leftView = paddingView;
    _startDate.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _endDate.leftView = paddingView2;
    _endDate.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [_dateView removeFromSuperview];
}

#pragma mark - TEXT FIELD DELEGATE
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    [_dateView removeFromSuperview];
    
    _currTextField = textField;
    [self initDatePicker];
    
    return NO;
}

- (IBAction)btnSelectClick:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *dateStart = _startDate.text;
    NSString *dateEnd = _endDate.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    
    NSDate *_dateStart = [formatter dateFromString:dateStart];
    NSDate *_dateEnd = [formatter dateFromString:dateEnd];
    
    NSMutableArray *images = [_phImagePicker selectByTimeRange:_dateStart endDate:_dateEnd];
    
    [self showPhotoViewController:images];
    
    [SVProgressHUD dismiss];
}

- (void) showPhotoViewController:(NSMutableArray*) info {
    if ([info count] == 0) {
        UIAlertController *alertFinish = [UIAlertController alertControllerWithTitle:@"There is no photos in the time chosen" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertFinish addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertFinish animated:YES completion:nil];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PhotoViewController *photoController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
        NSMutableArray *infoArray = [[NSMutableArray alloc] initWithArray:info];
        photoController.imageData = infoArray;
        
        [self.navigationController pushViewController:photoController animated:YES];
    }
}

- (void) initDatePicker {
    CGRect frame = self.view.frame;
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
    _dateView.backgroundColor = [UIColor whiteColor];
    
    _datePicker=[[UIDatePicker alloc]init];
    _datePicker.frame=CGRectMake(0,0,320, 216);
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    NSDate *currDate = [NSDate date];
    
    NSString *txtDate = _currTextField.text;
    if ([txtDate isEqualToString:@""]) {
        _datePicker.date = currDate;
    } else {
        _datePicker.date = [formatter dateFromString:txtDate];
    }
    
    [_dateView addSubview:_datePicker];
    
    [self.view addSubview:_dateView];
}

- (void) dateChanged:(id) sender {
    NSDate * dateSelected = ((UIDatePicker *) sender).date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    
    NSString *strDate = [formatter stringFromDate:dateSelected];
    _currTextField.text = strDate;
}

@end
