//
//  ImageHolder.m
//  Flic
//
//  Created by Mr Trung on 10/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "ImageHolder.h"

#define kImageHeight 300

@implementation ImageHolder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        _imageManager = [PHImageManager defaultManager];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height - 30, self.frame.size.width, 30)];
        _infoLabel.font = [UIFont fontWithName:@"Futura" size:15];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.alpha = 0.6;
        
        [self addSubview:_infoLabel];
        
        _trashBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_trashBg setBackgroundColor:[UIColor colorWithRed:173.0/255.0 green:103.0/255.0 blue:201.0/255.0 alpha:1.0]];
        UIImageView *trashImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 85, self.frame.size.height/2 - 55, 170, 110)];
        [trashImg setImage:[UIImage imageNamed:@"trash_bg"]];
        [_trashBg addSubview:trashImg];
        
        [self addSubview:_trashBg];
        
        _keepBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_keepBg setBackgroundColor:[UIColor colorWithRed:169.0/255.0 green:177.0/255.0 blue:184.0/255.0 alpha:1.0]];
        UIImageView *keepImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 85, self.frame.size.height/2 - 55, 170, 110)];
        [keepImg setImage:[UIImage imageNamed:@"keep_bg"]];
        [_keepBg addSubview:keepImg];
        
        [self addSubview:_keepBg];
        
        _trashBg.hidden = YES;
        _keepBg.hidden = YES;
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        
        _imageViewFull = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_imageViewFull setBackgroundColor:[UIColor blackColor]];
        
        _imgFull = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, _imageViewFull.frame.size.width, _imageViewFull.frame.size.height - 40)];
        [_imgFull setContentMode:UIViewContentModeScaleAspectFit];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:_imageViewFull];
        
        [_imageViewFull addSubview:_imgFull];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 50, 25)];
        [button setTitle:@"Close" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_imageViewFull addSubview:button];
        
        _imageViewFull.hidden = YES;
        _imageViewFull.alpha = 0.0;
        
        _imageView.userInteractionEnabled = YES;
        _imageViewFull.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
        tap2.numberOfTapsRequired = 1;
        tap2.delegate = self;
        
        [_imageViewFull addGestureRecognizer:tap2];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (IBAction)closeClick:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _imageViewFull.alpha = 0.0;
    } completion:^(BOOL finished) {
        _imageViewFull.hidden = YES;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (UIImage*)imageByScalingAndCroppingForImage:(UIImage*) image withSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"Could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)imgClick:(UITapGestureRecognizer *)recognizer
{
    if (_isMoving) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kImageNotify object:self];
        
        return;
    }
    
    BOOL needHide = NO;
    if (!_imageViewFull.isHidden)
        needHide = YES;
    
    if (!needHide)
        _imageViewFull.hidden = needHide;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (needHide)
            _imageViewFull.alpha = 0.0;
        else
            _imageViewFull.alpha = 1.0;
    } completion:^(BOOL finished) {
        _imageViewFull.hidden = needHide;
    }];
}

- (void)setPhAsset:(PHAsset *)phAsset
{
    _phAsset = phAsset;
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    [_imageManager requestImageDataForAsset:phAsset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        UIImage *image = [UIImage imageWithData:imageData];
        _imageView.image = image;
        _imgFull.image = image;
        _imgSize = (float) [imageData length] / (1024 * 1024);
        _sImageSize = [NSString stringWithFormat:@"%.2f", (float) [imageData length] / (1024 * 1024)];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSDate* date = phAsset.creationDate;
        
        _info = [NSString stringWithFormat:@"%@MB - %@", _sImageSize, [dateFormatter stringFromDate:date]];
        _infoLabel.text = _info;
        
        if (_mustPush) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateSize object:self];
            _mustPush = FALSE;
        }
        
        [self layoutSubviews];
    }];
}

- (void)setAsset:(ALAsset *)asset
{
    NSDate* date = [asset valueForProperty:ALAssetPropertyDate];
    
    id obj = [asset valueForProperty:ALAssetPropertyType];
    if (!obj) {
        return;
    }
    
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    NSDictionary *metaData = assetRep.metadata;
    
    if(assetRep != nil) {
        CGImageRef imgRef = nil;
        //defaultRepresentation returns image as it appears in photo picker, rotated and sized,
        //so use UIImageOrientationUp when creating our image below.
        UIImageOrientation orientation = UIImageOrientationUp;
        
        imgRef = [assetRep fullResolutionImage];
        orientation = [assetRep orientation];
        
        UIImage *img = [UIImage imageWithCGImage:imgRef
                                           scale:1.0f
                                     orientation:orientation];
        _imageView.image = img;
        
        long long dataSize = [assetRep size];
        _sImageSize = [NSString stringWithFormat:@"%.2f", (float) (dataSize/(1024.0f * 1024.0f))];
        _imgSize = (float) (dataSize/(1024.0f * 1024.0f));
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSDate* date = [asset valueForProperty:ALAssetPropertyDate];
        
        _info = [NSString stringWithFormat:@"%@MB - %@", _sImageSize, [dateFormatter stringFromDate: [dateFormatter stringFromDate:date]]];
        
        [self layoutSubviews];
        
//            [workingDictionary setObject:img forKey:UIImagePickerControllerOriginalImage];
        
//        [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:UIImagePickerControllerReferenceURL];
//        long long dataSize = [assetRep size];
//        [workingDictionary setObject:[NSString stringWithFormat:@"%.2f", (float) (dataSize/(1024.0f * 1024.0f))] forKey:@"PhotoSize"];
//        [workingDictionary setObject:date forKey:@"PhotoDate"];
//        [workingDictionary setObject:asset forKey:@"PhotoAsset"];
//        
//        [returnArray addObject:workingDictionary];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    [_imageView setFrame:CGRectMake(0, 0, self.frame.size.width, imgHeight)];
    _originImage = _imageView.image;
    
    _imageView.image = [self imageByScalingAndCroppingForImage:_imageView.image withSize:CGSizeMake(self.frame.size.width * 2, imgHeight * 2)];
}

- (void)setImageView:(UIImageView *)imageView
{
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    _imageView = imageView;
    [_imageView setFrame:CGRectMake(0, 0, self.frame.size.width, imgHeight)];
    
    [self addSubview:_imageView];
    [self sendSubviewToBack:_imageView];
}

- (void)setInfo:(NSString *)info
{
    _infoLabel.text = info;
}

@end
