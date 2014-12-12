//
//  AlbumPickerViewController.m
//  Flic
//
//  Created by Mr Trung on 12/11/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "AlbumPickerViewController.h"
#import <Photos/Photos.h>

@interface AlbumPickerViewController ()

@end

static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";

@implementation AlbumPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phImagePicker = [[PHImagePicker alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 200, 230) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_imageData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectionCellReuseIdentifier];
    
    NSString *localizedTitle = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CollectionCellReuseIdentifier];
    }
    
    PHCollection *collection = _imageData[indexPath.row];
    localizedTitle = collection.localizedTitle;
    
    cell.textLabel.text = localizedTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHCollection *collection = _imageData[indexPath.row];
    NSString *title = collection.localizedTitle;
    NSLog(@"Album %@", title);
    
    if ([_albumType isEqualToString:kTypeTop]) {
        [[NSUserDefaults standardUserDefaults] setObject:title forKey:kTypeTop];
    }
    if ([_albumType isEqualToString:kTypeRight]) {
        [[NSUserDefaults standardUserDefaults] setObject:title forKey:kTypeRight];
    }
    if ([_albumType isEqualToString:kTypeLeft]) {
        [[NSUserDefaults standardUserDefaults] setObject:title forKey:kTypeLeft];
    }
    if ([_albumType isEqualToString:kTypeBottom]) {
        [[NSUserDefaults standardUserDefaults] setObject:title forKey:kTypeBottom];
    }
}

- (IBAction)btnAddClick:(id)sender {
    // Prompt user from new album title.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New Album", @"") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:NULL]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Album Name", @"");
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Create", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields.firstObject;
        NSString *title = textField.text;
        
        // Create new album.
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error creating album: %@", error);
            } else {
                [self performSelectorOnMainThread:@selector(reloadAlbums) withObject:nil waitUntilDone:YES];
            }
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void) reloadAlbums
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // Reload albums
    _imageData = [_phImagePicker selectAlbums];
    
    [_tableView reloadData];
}

@end
