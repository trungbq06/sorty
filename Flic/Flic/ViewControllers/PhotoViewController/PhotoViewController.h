//
//  ViewController.h
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHolder.h"
#import "PHImagePicker.h"
#import "TrashViewController.h"

#define kPhotoPushbackNotify @"push_back_notify"

@interface PhotoViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *imageData;

@property (nonatomic, retain) PHImagePicker  *phImagePicker;
@property (nonatomic, retain) PHImageManager *imageManager;

@property (assign)            int            total;
@property (assign)            int            totalTrash;
@property (assign)            int            totalKeep;
@property (assign)            BOOL           lastIsTrash;
@property (nonatomic, retain) NSMutableArray *imageDisplay;
@property (nonatomic, retain) NSMutableArray *infoDisplay;
@property (nonatomic, retain) NSMutableArray *imgDataDisplay;
@property (weak, nonatomic) IBOutlet UILabel *badgeInfo;
@property (nonatomic, retain) NSMutableArray *trashImage;
@property (nonatomic, retain) NSMutableArray *undoImage;
@property (assign)            BOOL           touchStarted;
@property (assign)            CGPoint        normalPoint;
@property (weak, nonatomic) IBOutlet UITextView *introText;
@property (weak, nonatomic) IBOutlet UIButton *btnTrash;
@property (weak, nonatomic) IBOutlet UIButton *btnKeep;
@property (nonatomic, retain) ImageHolder    *tmpImageHolder;

@property (assign)            float          oldX;
@property (assign)            float          oldY;

@property (weak, nonatomic) IBOutlet UILabel *imageSize;
@property (assign)          float            totalSize;
@property (weak, nonatomic) IBOutlet UIButton *btnUndo;

@property (weak, nonatomic) IBOutlet UILabel *albumTop;
@property (weak, nonatomic) IBOutlet UILabel *albumRight;
@property (weak, nonatomic) IBOutlet UILabel *albumBottom;
@property (weak, nonatomic) IBOutlet UILabel *albumLeft;

@property (nonatomic, retain) PHCollection   *phAlbumTop;
@property (nonatomic, retain) PHCollection   *phAlbumRight;
@property (nonatomic, retain) PHCollection   *phAlbumLeft;
@property (nonatomic, retain) PHCollection   *phAlbumBottom;

- (IBAction)trashClick:(id)sender;
- (IBAction)keepClick:(id)sender;
- (IBAction)undoClick:(id)sender;
- (IBAction)emptyTrashClick:(id)sender;
- (IBAction)backClick:(id)sender;

@end

