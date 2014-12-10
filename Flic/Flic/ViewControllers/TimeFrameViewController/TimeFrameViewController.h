//
//  TimeFrameViewController.h
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHImagePicker.h"
#import "ELCImagePickerController.h"

@interface TimeFrameViewController : UIViewController < UITableViewDelegate, UITableViewDataSource,ELCImagePickerControllerDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *timeFrame;
@property (nonatomic, retain) UIImage *tmpImage;
@property (weak, nonatomic) IBOutlet UIView *navBar;
@property (nonatomic, retain) PHImagePicker  *phImagePicker;

- (IBAction)btnBackClick:(id)sender;

@end
