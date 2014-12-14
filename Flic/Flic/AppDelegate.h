//
//  AppDelegate.h
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) PHCollection   *phAlbumTop;
@property (nonatomic, retain) PHCollection   *phAlbumRight;
@property (nonatomic, retain) PHCollection   *phAlbumLeft;
@property (nonatomic, retain) PHCollection   *phAlbumBottom;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end

