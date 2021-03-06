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
#import "FPPopoverController.h"

@interface StartViewController : UIViewController <FPPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton   *btnSelect;
@property (nonatomic, retain) IBOutlet UILabel  *bottomText;

@property (nonatomic, retain) PHImagePicker     *phImagePicker;

- (IBAction)btnSelectClick:(id)sender;

@end
