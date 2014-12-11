//
//  AlbumPickerViewController.m
//  Flic
//
//  Created by Mr Trung on 12/11/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "AlbumPickerViewController.h"

@interface AlbumPickerViewController ()

@end

static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";

@implementation AlbumPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
}

- (IBAction)btnAddClick:(id)sender {
}
@end
