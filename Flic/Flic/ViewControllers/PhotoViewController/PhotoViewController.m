//
//  ViewController.m
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "PhotoViewController.h"
#import "ImageHolder.h"

#define kImageTag 100
#define kTypeTrash 1
#define kTypeKeep  1
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define kImageHeight 300
#define kStart 70

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phImagePicker = [[PHImagePicker alloc] init];
    _imageManager = [PHImageManager defaultManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoPushback:) name:kPhotoPushbackNotify object:nil];
    
    /*
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
     */
    
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    
    if (!IS_IPHONE_5) {
        [_introText setFrame:CGRectMake(_introText.frame.origin.x, appFrame.size.height - _introText.frame.size.height - 70, _introText.frame.size.width, _introText.frame.size.height)];
        [_btnTrash setFrame:CGRectMake(_btnTrash.frame.origin.x, appFrame.size.height - _btnTrash.frame.size.height - 5, _btnTrash.frame.size.width, _btnTrash.frame.size.height)];
        [_btnKeep setFrame:CGRectMake(_btnKeep.frame.origin.x, appFrame.size.height - _btnKeep.frame.size.height - 5, _btnKeep.frame.size.width, _btnKeep.frame.size.height)];
    }
    
    self.view.userInteractionEnabled = YES;
    
    _badgeInfo.layer.cornerRadius = 8;
    _badgeInfo.layer.masksToBounds = YES;
    
    _totalSize = 0;
    _totalTrash = 0;
    _totalKeep = 0;
    _lastIsTrash = false;
    _badgeInfo.hidden = YES;
    _imageDisplay = [[NSMutableArray alloc] initWithCapacity:0];
    _infoDisplay = [[NSMutableArray alloc] initWithCapacity:0];
    _trashImage = [[NSMutableArray alloc] initWithCapacity:0];
    _undoImage = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initImageHolder];
    
    [self showImages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreImageHolder:) name:kImageNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageSize:) name:kUpdateSize object:nil];
    
    /*
    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pgr];
     */
}
/*
-(void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    if (pgr.state == UIGestureRecognizerStateChanged) {
        int tag = touchView.tag;
        if (tag == kImageTag) {
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        center = CGPointMake(center.x + translation.x,
                             center.y + translation.y);
        pgr.view.center = center;
        [pgr setTranslation:CGPointZero inView:pgr.view];
    }
}
*/

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)imgClick:(id)sender
{
    
}

- (void) initImageHolder
{
    _total = (int) _imageData.count;
    
    int start = kStart;
    int xStart = 40;
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    for (int i = 0; i < 3;i++) {
        if (i < _total && [_imageDisplay count] < 3 && _total > [_imageDisplay count]) {
            ImageHolder *imgHolder1 = [[ImageHolder alloc] initWithFrame:CGRectMake(xStart - i*10, start + i*10, self.view.frame.size.width - 80 + i*20, imgHeight)];
            UIImageView *imgView1 = [[UIImageView alloc] init];
            [imgHolder1 setImageView:imgView1];
            [imgHolder1 setInfo:@""];
            [imgHolder1 setTag:kImageTag];
    //        [imgHolder1 setAsset:[_imageData objectAtIndex:_total - i - 1]];
            [imgHolder1 performSelectorInBackground:@selector(setPhAsset:) withObject:[_imageData objectAtIndex:_total - i - 1]];
        
            [_imageDisplay addObject:imgHolder1];
            [self.view addSubview:imgHolder1];
        }
    }
}

#pragma MARK - Photo Push back
- (void) photoPushback:(NSNotification*) notify
{
    _badgeInfo.text = @"0";
    _badgeInfo.hidden = YES;
    
    NSDictionary *info = notify.userInfo;
    NSArray *rImageData = [info objectForKey:@"info"];
    NSLog(@"Total ImageData %d", (int) [rImageData count]);
    
    if ([rImageData count] > 0 || [_imageData count] > 0) {
        [self performSelectorOnMainThread:@selector(arrangeImage:) withObject:rImageData waitUntilDone:NO];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) arrangeImage:(NSArray*) rImageData
{
    [_imageData addObjectsFromArray:rImageData];
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    /*
    if ([_imageDisplay count] < 3) {
        int start = 90;
        int xStart = 40;
        
        for (int i = (int) [_imageDisplay count]; i < 3;i++) {
            ImageHolder *imgHolder1 = [[ImageHolder alloc] initWithFrame:CGRectMake(xStart - i*10, start + i*10, self.view.frame.size.width - 80 + i*20, imgHeight)];
            UIImageView *imgView1 = [[UIImageView alloc] init];
            [imgHolder1 setImageView:imgView1];
            [imgHolder1 setInfo:@""];
            [imgHolder1 setTag:kImageTag];
            
            [_imageDisplay addObject:imgHolder1];
//            [imgHolder1 setAsset:[rImageData objectAtIndex:[rImageData count] - 1]];
            [imgHolder1 performSelectorInBackground:@selector(setPhAsset:) withObject:[rImageData objectAtIndex:i - 1]];
            
            [self.view addSubview:imgHolder1];
        }
    }
    */
    
    [self initImageHolder];
    
    [_trashImage removeAllObjects];
    [_undoImage removeAllObjects];
    _totalTrash = 0;
    _totalSize = 0;
    [_imageSize setText:@"0 MB"];
    
    [self showImages];
    [self animationImage];
}

- (void) showImages
{
    return;
    _total = (int) _imageData.count;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *date;
    
    if (_total > 2) {
        ImageHolder *imgHolder1 = [_imageDisplay objectAtIndex:0];
        
//        [imgHolder1.imageView setImage:[[_imageData objectAtIndex:_total - 3] objectForKey:UIImagePickerControllerOriginalImage]];
//        date = [NSString stringWithFormat:@"%@MB - %@", [[_imageData objectAtIndex:_total - 3] objectForKey:@"PhotoSize"], [dateFormatter stringFromDate:[[_imageData objectAtIndex:_total - 3] objectForKey:@"PhotoDate"]] ];
//        imgHolder1.info = date;
    }
    
    if (_total > 1) {
        ImageHolder *imgHolder2 = [_imageDisplay objectAtIndex:1];
//        [imgHolder2.imageView setImage:[[_imageData objectAtIndex:_total - 2] objectForKey:UIImagePickerControllerOriginalImage]];
//        date = [NSString stringWithFormat:@"%@MB - %@", [[_imageData objectAtIndex:_total - 2] objectForKey:@"PhotoSize"], [dateFormatter stringFromDate:[[_imageData objectAtIndex:_total - 2] objectForKey:@"PhotoDate"]] ];
//        imgHolder2.info = date;
    }
    
    if (_total > 0) {
        ImageHolder *imgHolder3 = [_imageDisplay objectAtIndex:2];
//        [imgHolder3.imageView setImage:[[_imageData objectAtIndex:_total - 1] objectForKey:UIImagePickerControllerOriginalImage]];
//        date = [NSString stringWithFormat:@"%@MB - %@", [[_imageData objectAtIndex:_total - 1] objectForKey:@"PhotoSize"], [dateFormatter stringFromDate:[[_imageData objectAtIndex:_total - 1] objectForKey:@"PhotoDate"]] ];
//        imgHolder3.info = date;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK - BUTTON ACTION
- (IBAction)trashClick:(id)sender {
    if (_total > 0) {
        [self doTrash];
    }
}

- (IBAction)keepClick:(id)sender {
    if (_total > 0) {
        [self doKeep];
    }
}

- (void) revealNewImageHolder
{
    int index = (int)( _imageData.count - _imageDisplay.count - 1 );
    NSLog(@"Reveal %d", index);
    if (index >= 0 && _imageData.count > 0) {
//        if ([_imageData count] > 3) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            
            int imgHeight = kImageHeight;
            if (!IS_IPHONE_5) {
                imgHeight = 200;
            }
            
            ImageHolder *newImgHolder = [[ImageHolder alloc] initWithFrame:CGRectMake(50, 80, self.view.frame.size.width - 100, imgHeight)];
            [newImgHolder setTag:kImageTag];
            UIImageView *imgView3 = [[UIImageView alloc] init];
            [newImgHolder setImageView:imgView3];
        
//            [newImgHolder setAsset:[_imageData objectAtIndex:index]];
            [newImgHolder performSelectorInBackground:@selector(setPhAsset:) withObject:[_imageData objectAtIndex:index]];
        
//            [newImgHolder.imageView setImage:[[_imageData objectAtIndex:index] objectForKey:UIImagePickerControllerOriginalImage]];
//            NSString *date = [NSString stringWithFormat:@"%@MB - %@", [[_imageData objectAtIndex:index] objectForKey:@"PhotoSize"], [dateFormatter stringFromDate:[[_imageData objectAtIndex:index] objectForKey:@"PhotoDate"]] ];
//            newImgHolder.info = date;
            [self.view addSubview:newImgHolder];
            [self.view sendSubviewToBack:newImgHolder];
            [_imageDisplay insertObject:newImgHolder atIndex:0];
            
            [self animationImage];
//        }
    } else if ([_imageData count] == 0) {
        // Show Trash
        [self showTrash];
    }
}

- (void) reArrangeImgHolder:(int) imgType
{
    // Remove first index
    if ([_imageDisplay count] == 3)
        [_imageDisplay removeObjectAtIndex:0];
    
    int index = (int) [_imageData count] - 1;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    int imgHeight = kImageHeight;
    if (!IS_IPHONE_5) {
        imgHeight = 200;
    }
    
    ImageHolder *newImgHolder = [[ImageHolder alloc] initWithFrame:CGRectMake(50, 80, self.view.frame.size.width - 100, imgHeight)];
    [newImgHolder setTag:kImageTag];
    UIImageView *imgView3 = [[UIImageView alloc] init];
    [newImgHolder setImageView:imgView3];
    
    [newImgHolder performSelectorInBackground:@selector(setPhAsset:) withObject:[_imageData objectAtIndex:index]];
    if (imgType == kTypeTrash) {
        newImgHolder.mustPush = TRUE;
    }
    
    [self.view addSubview:newImgHolder];
    [self.view sendSubviewToBack:newImgHolder];
    
//    [newImgHolder setPhAsset:[_imageData objectAtIndex:index]];
    
//    [newImgHolder.imageView setImage:[[_imageData objectAtIndex:index] objectForKey:UIImagePickerControllerOriginalImage]];
//    NSString *date = [NSString stringWithFormat:@"%@MB - %@", [[_imageData objectAtIndex:index] objectForKey:@"PhotoSize"], [dateFormatter stringFromDate:[[_imageData objectAtIndex:index] objectForKey:@"PhotoDate"]] ];
//    newImgHolder.info = date;
    [_imageDisplay addObject:newImgHolder];
    
    [self animationImage];
}

- (void) animationImage
{
    int start = kStart;
    int xStart = 40;
    
    for (int i = 0;i < _imageDisplay.count;i++) {
        ImageHolder *img = [_imageDisplay objectAtIndex:i];
        img.trashBg.backgroundColor = [UIColor colorWithRed:173.0/255.0 green:103.0/255.0 blue:201.0/255.0 alpha:1.0];
        img.keepBg.backgroundColor = [UIColor colorWithRed:169.0/255.0 green:177.0/255.0 blue:184.0/255.0 alpha:1.0];
        CGRect frame = img.frame;
        
        int imgHeight = kImageHeight;
        if (!IS_IPHONE_5) {
            imgHeight = 200;
        }
        
        NSLog(@"frame %@", NSStringFromCGRect(frame));
        img.frame = CGRectMake(xStart - i*10, start + i*10, self.view.frame.size.width - 80 + i*20, imgHeight);
        NSLog(@"after frame %@\n", NSStringFromCGRect(img.frame));
        
        img.trashBg.frame = CGRectMake(0, 0, img.frame.size.width, img.frame.size.height);
        img.keepBg.frame = CGRectMake(0, 0, img.frame.size.width, img.frame.size.height);
        
        [self.view bringSubviewToFront:img];
    }
}

- (void) doTrash
{
    [_btnUndo setEnabled:YES];
    
    _totalTrash++;
    _lastIsTrash = true;
    if (_totalTrash > 0) {
        _badgeInfo.hidden = NO;
    }
    _badgeInfo.text = [NSString stringWithFormat:@"%d", _totalTrash];
    _total = (int) _imageData.count;
    
    NSLog(@"Remain %d", _total);
    ImageHolder *imgHolder = [_imageDisplay objectAtIndex:_imageDisplay.count - 1];
    imgHolder.isTrash = YES;
    
//    PHAsset *toTrash = [_imageData objectAtIndex:_total - 1];
    PHAsset *toTrash = imgHolder.phAsset;
    
    _totalSize += imgHolder.imgSize;
    [_imageSize setText:[NSString stringWithFormat:@"%.2f MB", _totalSize]];
    [_trashImage addObject:toTrash];
    
    [_imageDisplay removeObjectAtIndex:_imageDisplay.count - 1];
    [_undoImage addObject:imgHolder];
    [imgHolder removeFromSuperview];
    [_imageData removeObject:toTrash];
    _total = (int) _imageData.count;
    
    if ([_undoImage count] > 3)
        [_undoImage removeObjectsInRange:NSMakeRange(0, [_undoImage count] - 3)];
    
    [self revealNewImageHolder];
}

- (void) doKeep
{
    [_btnUndo setEnabled:YES];
    
    _totalKeep++;
    _lastIsTrash = false;
    
    _total = (int) _imageData.count;
//    PHAsset *toKeep = [_imageData objectAtIndex:_total - 1];
    
    ImageHolder *imgHolder = [_imageDisplay objectAtIndex:_imageDisplay.count - 1];
    imgHolder.isKeep = YES;
    PHAsset *toKeep = imgHolder.phAsset;
    
    [_imageDisplay removeObjectAtIndex:_imageDisplay.count - 1];
    [_undoImage addObject:imgHolder];
    [imgHolder removeFromSuperview];
    [_imageData removeObject:toKeep];
    _total = (int) _imageData.count;
    
    if ([_undoImage count] > 3)
        [_undoImage removeObjectsInRange:NSMakeRange(0, [_undoImage count] - 3)];
    
    [self revealNewImageHolder];
}

- (IBAction)undoClick:(id)sender {
    if ([_undoImage count] > 0) {
        ImageHolder *imgHolder = [_undoImage lastObject];
        if (imgHolder.isTrash) {
            --_totalTrash;
            _badgeInfo.text = [NSString stringWithFormat:@"%d", _totalTrash];
            if (_totalTrash == 0) {
                _badgeInfo.hidden = YES;
            }
            
            PHAsset *asset = imgHolder.phAsset;
            [_imageData addObject:asset];
            
            [self reArrangeImgHolder:kTypeTrash];
            [_undoImage removeLastObject];
            [_trashImage removeLastObject];
            
            if ([_undoImage count] == 0)
                [_btnUndo setEnabled:NO];
        } else if (imgHolder.isKeep) {
            _totalKeep--;
            
            PHAsset *asset = imgHolder.phAsset;
            [_imageData addObject:asset];
            
            [self reArrangeImgHolder:kTypeKeep];
            [_undoImage removeLastObject];
            
            if ([_undoImage count] == 0)
                [_btnUndo setEnabled:NO];
        }
    }
}

- (IBAction)emptyTrashClick:(id)sender {
    if ([_trashImage count] > 0) {
        [self showTrash];
    } else {
        UIAlertController *alertFinish = [UIAlertController alertControllerWithTitle:@"You need to add some pictures to your trash first ..." message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertFinish addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertFinish animated:YES completion:nil];
    }
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showTrash
{
    TrashViewController *trashController = [self.storyboard instantiateViewControllerWithIdentifier:@"TrashViewController"];
    [trashController setImageData:_trashImage];
    
    [self presentViewController:trashController animated:YES completion:^{
        
    }];
}

#pragma mark - USER TOUCHES
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch Began");
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if ([[touch.view class] isSubclassOfClass:[ImageHolder class]]) {
        ImageHolder *touchView = (ImageHolder*) touch.view;
        int tag = touchView.tag;
        if (tag == kImageTag) {
            if (CGRectContainsPoint(touchView.frame, touchLocation)) {
                _touchStarted = true;
                _normalPoint = touchView.center;
                
                _oldX = touchLocation.x;
                _oldY = touchLocation.y;
            }
            
        } else {
            _touchStarted = false;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Move action");
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    float x = touchLocation.x;
    CGPoint newPoint;
    
    if (_touchStarted) {
        ImageHolder *touchView = (ImageHolder*) touch.view;
        NSLog(@"Moving %@", touchView);
        
        if ([touchView isKindOfClass:[ImageHolder class]]) {
            touchView.isMoving = TRUE;
            
            touchView.center = touchLocation;
            CGRect frame = self.view.frame;
            float center = frame.size.width/2;
            float ratio = abs(center - x) / center;
            
            if (x < (frame.size.width/2.0f - 20)) {
                touchView.trashBg.hidden = NO;
                touchView.trashBg.alpha = ratio;
                touchView.keepBg.hidden = YES;
            } else if (x > (frame.size.width/2.0f + 20)) {
                touchView.keepBg.hidden = NO;
                touchView.keepBg.alpha = ratio;
                touchView.trashBg.hidden = YES;
            } else {
                touchView.trashBg.hidden = YES;
                touchView.keepBg.hidden = YES;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Ended");
    
    if (_touchStarted) {
        UITouch *touch = [touches anyObject];
        ImageHolder *touchView = (ImageHolder*) touch.view;
        
        if ([touchView isKindOfClass:[ImageHolder class]]) {
            touchView.isMoving = false;
            
            CGPoint touchLocation = [touch locationInView:self.view];
            float x = touchLocation.x;
            CGRect frame = self.view.frame;
            NSLog(@"Got x: %f", x);
            
            if (x < (frame.size.width/2.0f - 50)) {
                if (_total > 0) {
                    [self doTrash];
                    
                    _touchStarted = NO;
                }
            } else if (x > (frame.size.width/2.0f + 50)) {
                if (_total > 0) {
                    [self doKeep];
                    
                    _touchStarted = NO;
                }
            } else {
                NSLog(@"Putting to normal");
                
                // Put to normal position
                touchView.center = _normalPoint;
                
                touchView.trashBg.hidden = YES;
                touchView.keepBg.hidden = YES;
            }
            
            _touchStarted = NO;
        }
    }
}

#pragma mark - Notification
- (void) restoreImageHolder:(NSNotification*) notify {
    id object = [notify object];
    
    if ([object isKindOfClass:[ImageHolder class]]) {
        ImageHolder *touchView = (ImageHolder*) object;
        touchView.isMoving = false;
        
        NSLog(@"Putting to normal");
        _touchStarted = NO;
        
        // Put to normal position
        touchView.center = _normalPoint;
        
        touchView.trashBg.hidden = YES;
        touchView.keepBg.hidden = YES;
    }
}

- (void) updateImageSize: (NSNotification*) notify {
    id object = [notify object];
    
    if ([object isKindOfClass:[ImageHolder class]]) {
        ImageHolder *imgHolder = (ImageHolder*) object;
        
        _totalSize -= imgHolder.imgSize;
        [_imageSize setText:[NSString stringWithFormat:@"%.2f MB", _totalSize]];
    }
}

@end
