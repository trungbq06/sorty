//
//  AlbumViewController.m
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "AlbumViewController.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"

static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
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
    
    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        NSMutableArray *result = [[NSMutableArray alloc] init];
        
        [assetsFetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [result addObject:obj];
        }];
        
        if ([result count] == 0) {
            UIAlertController *alertFinish = [UIAlertController alertControllerWithTitle:@"There is no photos in the time chosen" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertFinish addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            [self presentViewController:alertFinish animated:YES completion:nil];
        } else {
            PhotoViewController *photoController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
            NSMutableArray *infoArray = [[NSMutableArray alloc] initWithArray:result];
            photoController.imageData = infoArray;
            
            [self.navigationController pushViewController:photoController animated:YES];
        }
    }
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
