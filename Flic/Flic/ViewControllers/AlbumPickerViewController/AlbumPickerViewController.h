//
//  AlbumPickerViewController.h
//  Flic
//
//  Created by Mr Trung on 12/11/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *imageData;
@property (nonatomic, retain) UITableView    *tableView;

- (IBAction)btnAddClick:(id)sender;

@end
