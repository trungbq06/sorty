//
//  TrashCollectionViewCell.m
//  Flic
//
//  Created by Mr Trung on 10/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "TrashCollectionViewCell.h"

@implementation TrashCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareForReuse];
    }
    
    return self;
}

- (void)showSelection:(BOOL) selection
{
//    if (selection) {
//        [_btnTick setHidden:NO];
//        self.contentView.backgroundColor = [UIColor greenColor];
//    } else {
//        [_btnTick setHidden:YES];
//        self.contentView.backgroundColor = [UIColor whiteColor];
//    }
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (!selected) {
        [_btnTick setHidden:NO];
//        self.contentView.backgroundColor = [UIColor greenColor];
    } else {
        [_btnTick setHidden:YES];
//        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//    
//    [self showSelection:YES];
//}

@end
