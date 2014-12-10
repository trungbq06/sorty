0001;544dce95;Google\x20Chrome;7CF9098E-96DE-424F-BCDD-3C856FD3B76DAlexey Belkevich on 12/10/13.
//  Copyright (c) 2013 alterplay. All rights reserved.
//

#import "ALAssetsGroup+Assets.h"

@implementation ALAssetsGroup (Assets)

- (NSArray *)assets
{
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    [self enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (result)
        {
            [assets addObject:result];
        }
    }];
    return [assets copy];
}

@end
