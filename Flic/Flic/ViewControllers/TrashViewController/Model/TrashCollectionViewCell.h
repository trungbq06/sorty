//
//  TrashCollectionViewCell.h
//  Flic
//
//  Created by Mr Trung on 10/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrashCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, assign)        BOOL     cellSelected;
@property (weak, nonatomic) IBOutlet UIButton *btnTick;

- (void)showSelection:(BOOL) selection;

@end
