//
//  ImageHolder.h
//  Flic
//
//  Created by Mr Trung on 10/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageHolder : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, retain) PHImageManager *imageManager;
@property (nonatomic, retain) UIImageView   *imageView;
@property (nonatomic, retain) UIImage       *originImage;
@property (nonatomic, retain) NSString      *info;
@property (nonatomic, retain) UILabel       *infoLabel;
@property (nonatomic, retain) UIView        *trashBg;
@property (nonatomic, retain) UIView        *keepBg;
@property (assign)            BOOL          isTrash;
@property (assign)            BOOL          isKeep;
//@property (nonatomic, retain) NSDictionary  *asset;
@property (nonatomic, retain) UIView        *imageViewFull;
@property (nonatomic, retain) UIImageView   *imgFull;
@property (nonatomic, retain) ALAsset       *asset;
@property (nonatomic, retain) PHAsset       *phAsset;
@property (nonatomic, assign) NSString      *sImageSize;
@property (nonatomic, assign) float         imgSize;
@property (assign)            BOOL          isMoving;
@property (assign)            BOOL          mustPush;

@end
