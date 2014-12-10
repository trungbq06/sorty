0001;544dce95;Google\x20Chrome;7CF9098E-96DE-424F-BCDD-3C856FD3B76D Belkevich on 12/10/13.
//  Copyright (c) 2013 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;
@class ALAssetsLibrary;

typedef NSComparisonResult (^APAssetComparator)(ALAsset *asset1, ALAsset *asset2);

@interface APPhotolibrary : NSObject

@property (nonatomic, readonly) ALAssetsLibrary *assetLibrary;
@property (nonatomic, assign) BOOL sortAscending;
@property (nonatomic, copy) APAssetComparator sortComparator;

+ (BOOL)isAuthorized;
- (void)loadPhotosAsynchronously:(void (^)(NSArray *assets, NSError *error))callbackBlock;

@end
