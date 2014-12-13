//
//  TimeFrameViewController.m
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "TimeFrameViewController.h"
#import "ELCAssetTablePicker.h"
#import "AlbumViewController.h"
#import "SVProgressHUD.h"
#import "PhotoViewController.h"
#import "SelectDateViewController.h"

@interface TimeFrameViewController ()

@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

@end

@implementation TimeFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phImagePicker = [[PHImagePicker alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Futura-Medium" size:18];
    cell.textLabel.textColor = [UIColor colorWithRed:240.0/255.0f green:152.0/255.0 blue:26.0/255.0 alpha:1.0];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Last Week";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Last Month";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Last Year";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Specific Date";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"Select Album";
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"Camera Roll";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self selectWithTime:@"week"];
    } else if (indexPath.row == 1) {
        [self selectWithTime:@"month"];
    } else if (indexPath.row == 2) {
        [self selectWithTime:@"year"];
    } else if (indexPath.row == 3) {
        [self selectDate];
    } else if (indexPath.row == 4) {
        [self selectAlbums];
    } else if (indexPath.row == 5) {
        [self selectCameraRoll];
    }
}

- (void) selectDate {
    SelectDateViewController *dateController = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
    
    [self.navigationController pushViewController:dateController animated:YES];
}

- (void) selectWithTime:(NSString*) timeRange
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableArray *images = [_phImagePicker selectByTime:timeRange];
    [self showPhotoViewController:images];
    
    /*
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    _specialLibrary = library;
    NSMutableArray *groups = [NSMutableArray array];
    [_specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        } else {
            // this is the end
            [self displayPickerForGroup:[groups objectAtIndex:0] timeRange:timeRange];
        }
    } failureBlock:^(NSError *error) {
        /*
         UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
         
         NSLog(@"A problem occured %@", [error description]);
         // an error here means that the asset groups were inaccessable.
         // Maybe the user or system preferences refused access.
         *
    }];*/
}

- (void) selectCameraRoll
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableArray *images = [_phImagePicker selectAllImages];
    [self showPhotoViewController:images];
    
    /*
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    _specialLibrary = library;
    NSMutableArray *groups = [NSMutableArray array];
    [_specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        } else {
            // this is the end
            [self displayPickerForGroup:[groups objectAtIndex:0]];
        }
    } failureBlock:^(NSError *error) {
        /*
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"A problem occured %@", [error description]);
        // an error here means that the asset groups were inaccessable.
        // Maybe the user or system preferences refused access.
        *
    }];
    */
}

- (void) showPhotoViewController:(NSMutableArray*) info {
    if ([info count] == 0) {
        UIAlertController *alertFinish = [UIAlertController alertControllerWithTitle:@"There is no photos in the time chosen" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertFinish addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertFinish animated:YES completion:nil];
    } else {
        PhotoViewController *photoController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
        NSMutableArray *infoArray = [[NSMutableArray alloc] initWithArray:info];
        photoController.imageData = infoArray;
        
        [self.navigationController pushViewController:photoController animated:YES];
    }
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group timeRange:(NSString*) timeRange
{
    ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For single image selection, do not display and return order of selected images
    elcPicker.assetGroup = group;
    tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [elcPicker selectWithTimeRange:timeRange];
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
    ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For single image selection, do not display and return order of selected images
    elcPicker.assetGroup = group;
    tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [elcPicker selectCameraRoll];
}

- (void) selectAlbums {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableArray *images = [_phImagePicker selectAlbums];
    
    AlbumViewController *albumController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumViewController"];
    albumController.imageData = images;
    [self.navigationController pushViewController:albumController animated:YES];
    
//    [self presentViewController:albumController animated:YES completion:nil];
    
    /*
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    
    [SVProgressHUD dismiss];*/
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([info count] == 0) {
        UIAlertController *alertFinish = [UIAlertController alertControllerWithTitle:@"There is no photos in the time chosen" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertFinish addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertFinish animated:YES completion:nil];
    } else {
        PhotoViewController *photoController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
        NSMutableArray *infoArray = [[NSMutableArray alloc] initWithArray:info];
        photoController.imageData = infoArray;
        
        [self.navigationController pushViewController:photoController animated:YES];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
