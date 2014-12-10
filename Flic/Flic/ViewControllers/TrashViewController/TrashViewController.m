//
//  TrashViewController.m
//  Flic
//
//  Created by Mr Trung on 10/28/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "TrashViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TrashCollectionViewCell.h"
#import <Photos/Photos.h>

@interface TrashViewController ()

@end

@implementation TrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cachingManager = [[PHCachingImageManager alloc] init];
    _imageManager = [[PHImageManager alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 73) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.allowsMultipleSelection = YES;
    
    [self.view addSubview:_collectionView];
    
    UINib *cellNib = [UINib nibWithNibName:@"TrashCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"TrashCollectionViewCell"];
    
    [_collectionView reloadData];
    
    [self resetText];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = _btnEmpty.frame;
    [_btnEmpty setFrame:CGRectMake(frame.origin.x, appFrame.size.height - frame.size.height, frame.size.width, frame.size.height)];
}

- (void)setImageData:(NSMutableArray *)imageData
{
    _imageData = imageData;
    _imageSelectedIndex = [[NSMutableArray alloc] initWithCapacity:[_imageData count]];
    
    for (int i = 0; i < [_imageData count]; i++) {
        [_imageSelectedIndex addObject:[NSNumber numberWithInt:1]];
    }
    
    _totalSelected = (int) [_imageData count];
    _itemsSelected.text = [NSString stringWithFormat:@"%d Items Selected", _totalSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - COLLECTIONVIEW
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_imageData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *cellData = [_imageData objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"TrashCollectionViewCell";
    
    TrashCollectionViewCell *cell = (TrashCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    [_imageManager requestImageForAsset:cellData targetSize:cell.imgView.frame.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        [cell.imgView setImage:result];
//        [cell.imgView setContentMode:UIViewContentModeScaleAspectFit];
    }];
    
//    [cell.imgView setImage:[cellData objectForKey:UIImagePickerControllerOriginalImage]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // This is item deselected
    [_imageSelectedIndex replaceObjectAtIndex:indexPath.row withObject:@0];
    --_totalSelected;
    
    [self resetText];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // This is item selected
    [_imageSelectedIndex replaceObjectAtIndex:indexPath.row withObject:@1];
    ++_totalSelected;
    
    [self resetText];
}

- (void) resetText
{
    _itemsSelected.text = [NSString stringWithFormat:@"%d Items Selected", _totalSelected];
}

- (IBAction)emptyTrash:(id)sender {
    NSMutableArray *assetURL = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [_imageSelectedIndex count]; i++) {
        if ([[_imageSelectedIndex objectAtIndex:i] intValue] == 1) {
            // Delete this elcasset
            /*
            NSDictionary *imgAsset = [_imageData objectAtIndex:i];
            ALAsset *asset = [imgAsset objectForKey:@"PhotoAsset"];
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            
//            if (asset.isEditable)
                [assetURL addObject:rep.url];
             */
            
            PHAsset *imgAsset = [_imageData objectAtIndex:i];
            [assetURL addObject:imgAsset];
        }
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
//        PHFetchResult * fecthResult = [PHAsset fetchAssetsWithALAssetURLs:assetURL options:nil];
        [PHAssetChangeRequest deleteAssets:assetURL];
        
    } completionHandler:^(BOOL success, NSError *error) {
        
        if (error) {
            NSLog(@"Error %@", error);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@[], @"info", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoPushbackNotify object:self userInfo:userInfo];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

- (IBAction)keepTrash:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to Cancel" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"User continue trashing");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"User cancel");
        // Put back photos
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_imageData, @"info", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoPushbackNotify object:self userInfo:userInfo];
        
        [self dismissViewControllerAnimated:YES completion:^{
            UIAlertController *alertFinish = [UIAlertController alertControllerWithTitle:@"Your photos have been put back" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertFinish addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            PhotoViewController *photoController = (PhotoViewController*) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
            
            [photoController presentViewController:alertFinish animated:YES completion:^{
                
            }];
        }];
    }]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

@end
