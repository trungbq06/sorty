//
//  SelectDateViewController.h
//  Flic
//
//  Created by TrungBQ on 12/13/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHImagePicker.h"

@interface SelectDateViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@property (nonatomic, retain) UIView            *dateView;
@property (nonatomic, retain) UIDatePicker      *datePicker;
@property (nonatomic, retain) UITextField       *currTextField;

@property (nonatomic, retain) PHImagePicker  *phImagePicker;

- (IBAction)btnSelectClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;

@end
