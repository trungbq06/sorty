0001;544dce95;Google\x20Chrome;7CF9098E-96DE-424F-BCDD-3C856FD3B76Dlkevich on 12/11/13.
//  Copyright (c) 2013 alterplay. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (Photo)

- (UIImage *)photoThumbnail;
- (void)loadPhotoInFullResolutionAsynchronously:(void (^)(UIImage *image))callbackBlock;
- (void)loadPhotoInFullScreenAsynchronously:(void (^)(UIImage *image))callbackBlock;

@end
