//
//  PHImagePicker.h
//  Flic
//
//  Created by TrungBQ on 11/2/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <Photos/Photos.h>
#import "SVProgressHUD.h"
#import <Foundation/Foundation.h>

@interface PHImagePicker : NSObject

- (NSMutableArray*) selectAllImages;
- (NSMutableArray*) selectAlbums;
- (NSMutableArray*) selectByAlbums:(PHAssetCollection*) index;
- (NSMutableArray*) selectByTime:(NSString*) timeRange;
- (NSMutableArray *)selectByTimeRange:(NSDate*) startDate endDate: (NSDate*) endDate;

@end
