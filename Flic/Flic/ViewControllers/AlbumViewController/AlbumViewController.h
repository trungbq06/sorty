//
//  AlbumViewController.h
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *imageData;
@property (nonatomic, retain) UITableView    *tableView;


- (IBAction)btnBackClick:(id)sender;

@end
