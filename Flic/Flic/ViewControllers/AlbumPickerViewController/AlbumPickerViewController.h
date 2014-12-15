//
//  AlbumPickerViewController.h
//  Flic
//
//  Created by Mr Trung on 12/11/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PHImagePicker.h"

@interface AlbumPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *imageData;
@property (nonatomic, retain) PHImagePicker  *phImagePicker;
@property (nonatomic, assign) NSString        *albumType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btnAddClick:(id)sender;

@end
