//
//  TrashViewController.h
//  Flic
//
//  Created by Mr Trung on 10/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PhotoViewController.h"

#define kPhotoPushbackNotify @"push_back_notify"

@interface TrashViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) NSMutableArray *imageData;
@property (nonatomic, retain) NSMutableArray *imageSelectedIndex;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) IBOutlet UILabel *itemsSelected;
@property (nonatomic, assign) int              totalSelected;
@property (weak, nonatomic) IBOutlet UIButton *btnEmpty;
@property (nonatomic, retain) PHCachingImageManager *cachingManager;
@property (nonatomic, retain) PHImageManager        *imageManager;

- (IBAction)emptyTrash:(id)sender;
- (IBAction)keepTrash:(id)sender;
@end
