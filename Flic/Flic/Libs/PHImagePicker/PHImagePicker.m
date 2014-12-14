//
//  PHImagePicker.m
//  Flic
//
//  Created by TrungBQ on 11/2/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "PHImagePicker.h"

@implementation PHImagePicker

- (NSMutableArray *)selectAllImages
{
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *items = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:obj];
    }];
    
    [SVProgressHUD dismiss];
    
    return result;
}

- (NSMutableArray *)selectAlbums
{
    PHFetchResult *collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [collection enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:obj];
    }];
    
    [SVProgressHUD dismiss];
    
    return result;
}

- (PHCollection *)getAlbum:(NSString *)albumName
{
    PHFetchResult *collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [collection enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:obj];
    }];
    
    [SVProgressHUD dismiss];
    
    for (PHCollection *collect in result) {
        if ([collect.localizedTitle isEqualToString:albumName]) {
            return collect;
        }
    }
    
    return nil;
}

- (NSMutableArray *)selectByAlbums:(PHAssetCollection*) collection
{
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    PHFetchResult *items = [PHAsset fetchAssetsInAssetCollection:collection options:allPhotosOptions];
    
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:obj];
    }];
    
    [SVProgressHUD dismiss];
    
    return result;
}

- (NSMutableArray *)selectByTime:(NSString *)timeRange
{
    NSDate *needDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[[NSDate alloc] init]];
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    [components setYear:([components year] - 1)];
    NSDate *lastYear = [cal dateFromComponents:components];
    
    NSLog(@"lastWeek=%@",lastWeek);
    NSLog(@"lastMonth=%@",lastMonth);
    NSLog(@"lastYear=%@",lastYear);
    
    if ([timeRange isEqualToString:@"week"]) {
        needDate = lastWeek;
    } else if ([timeRange isEqualToString:@"month"]) {
        needDate = lastMonth;
    } else if ([timeRange isEqualToString:@"year"]) {
        needDate = lastYear;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    PHFetchResult *items = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAsset *asset = (PHAsset*) obj;
        NSDate *assetDate = asset.creationDate;
        if ([assetDate compare:needDate] == NSOrderedDescending) {
            [result addObject:obj];
        }
    }];
    
    [SVProgressHUD dismiss];
    
    return result;
}

- (NSMutableArray *)selectByTimeRange:(NSDate*) startDate endDate: (NSDate*) endDate
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    PHFetchResult *items = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAsset *asset = (PHAsset*) obj;
        NSDate *assetDate = asset.creationDate;
        if ([assetDate compare:endDate] == NSOrderedDescending && [assetDate compare:startDate] == NSOrderedAscending) {
            [result addObject:obj];
        }
    }];
    
    [SVProgressHUD dismiss];
    
    return result;
}

@end
