//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "SVProgressHUD.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCConsole.h"

@implementation ELCImagePickerController

//Using auto synthesizers

- (id)initImagePicker
{
    ELCAlbumPickerController *albumPicker = [[ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    
    self = [super initWithRootViewController:albumPicker];
    if (self) {
        self.maximumImagesCount = 4;
        self.returnsImage = YES;
        self.returnsOriginalImage = YES;
        [albumPicker setParent:self];
        self.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        self.elcAssets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{

    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.maximumImagesCount = 4;
        self.returnsImage = YES;
        self.elcAssets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSDate *) getCreatedDateOfAsset:(ALAsset *)asset
{
    return [asset valueForProperty:ALAssetPropertyDate];
}

- (NSDate *) getTakenDateOfAsset:(ALAsset *)asset
{
    @autoreleasepool {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        NSDictionary *metadata = asset.defaultRepresentation.metadata;
        NSString *takenDateStr = [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];
        NSDate *takenDate = [formatter dateFromString:takenDateStr];

        return (takenDate == nil) ? [self getCreatedDateOfAsset:asset] : takenDate;
    }
}

- (void) selectCameraRoll
{
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)selectWithTimeRange:(NSString*) timeRange
{
    [self performSelectorInBackground:@selector(preparePhotosWithTime:) withObject:timeRange];
}

- (void) preparePhotosWithTime:(NSString*) timeRange
{
    @autoreleasepool {
        NSDate *needDate;
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
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
        
        [self.elcAssets removeAllObjects];
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) {
                return;
            }
            
            NSDate *assetDate = [self getCreatedDateOfAsset:result];
            if ([assetDate compare:needDate] == NSOrderedDescending) {
                ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
                
                [self.elcAssets addObject:elcAsset];
            }
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self selectAllImages];
        });
    }
}

- (void) preparePhotos
{
    @autoreleasepool {
        [self.elcAssets removeAllObjects];
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) {
                return;
            }
            
            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            
            [self.elcAssets addObject:elcAsset];
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self selectAllImages];
        });
    }
}

- (void) selectAllImages
{
    NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
    
    for (ELCAsset *elcAsset in self.elcAssets) {
        [selectedAssetsImages addObject:elcAsset];
    }
    if ([[ELCConsole mainConsole] onOrder]) {
        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
    }
    
    [self selectedAssets:selectedAssetsImages];
}

- (ELCAlbumPickerController *)albumPicker
{
    return self.viewControllers[0];
}

- (void)setMediaTypes:(NSArray *)mediaTypes
{
    self.albumPicker.mediaTypes = mediaTypes;
}

- (NSArray *)mediaTypes
{
    return self.albumPicker.mediaTypes;
}

- (void)cancelImagePicker
{
	if ([_imagePickerDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[_imagePickerDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    BOOL shouldSelect = previousCount < self.maximumImagesCount;
    if (!shouldSelect) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Only %d photos please!", nil), self.maximumImagesCount];
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You can only send %d photos at a time.", nil), self.maximumImagesCount];
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"Okay", nil), nil] show];
    }
    return shouldSelect;
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount;
{
    return YES;
}

- (void)selectedAssets:(NSArray *)assets
{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for(ELCAsset *elcasset in assets) {
        ALAsset *asset = elcasset.asset;
        
        [returnArray addObject:asset];
    }
    
	/*
	for(ELCAsset *elcasset in assets) {
        ALAsset *asset = elcasset.asset;
        NSDate* date = [asset valueForProperty:ALAssetPropertyDate];
        
		id obj = [asset valueForProperty:ALAssetPropertyType];
		if (!obj) {
			continue;
		}
		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
		
		CLLocation* wgs84Location = [asset valueForProperty:ALAssetPropertyLocation];
		if (wgs84Location) {
			[workingDictionary setObject:wgs84Location forKey:ALAssetPropertyLocation];
		}
        
        [workingDictionary setObject:obj forKey:UIImagePickerControllerMediaType];

        //This method returns nil for assets from a shared photo stream that are not yet available locally. If the asset becomes available in the future, an ALAssetsLibraryChangedNotification notification is posted.
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        NSDictionary *metaData = assetRep.metadata;
        
        if(assetRep != nil) {
            if (_returnsImage) {
                CGImageRef imgRef = nil;
                //defaultRepresentation returns image as it appears in photo picker, rotated and sized,
                //so use UIImageOrientationUp when creating our image below.
                UIImageOrientation orientation = UIImageOrientationUp;
            
                if (_returnsOriginalImage) {
                    imgRef = [assetRep fullResolutionImage];
                    orientation = [assetRep orientation];
                } else {
                    imgRef = [assetRep fullScreenImage];
                }
                UIImage *img = [UIImage imageWithCGImage:imgRef
                                                   scale:1.0f
                                             orientation:orientation];
                [workingDictionary setObject:img forKey:UIImagePickerControllerOriginalImage];
            }

            [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:UIImagePickerControllerReferenceURL];
            long long dataSize = [assetRep size];
            [workingDictionary setObject:[NSString stringWithFormat:@"%.2f", (float) (dataSize/(1024.0f * 1024.0f))] forKey:@"PhotoSize"];
            [workingDictionary setObject:date forKey:@"PhotoDate"];
            [workingDictionary setObject:asset forKey:@"PhotoAsset"];
            
            [returnArray addObject:workingDictionary];
        }
	}
     */
    [SVProgressHUD dismiss];
	if (_imagePickerDelegate != nil && [_imagePickerDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[_imagePickerDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:returnArray];
	} else {
        [self popToRootViewControllerAnimated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

- (BOOL)onOrder
{
    return [[ELCConsole mainConsole] onOrder];
}

- (void)setOnOrder:(BOOL)onOrder
{
    [[ELCConsole mainConsole] setOnOrder:onOrder];
}

@end
