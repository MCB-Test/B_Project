//
//  MineController.m
//  B_Project
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "MineController.h"
#import "DownloadedController.h"
#import "CollectViewController.h"


@interface MineController ()<UITableViewDataSource , UITableViewDelegate>

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor brownColor];
    
    self.tableView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 69);
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏导航条
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - TableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"我的下载";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"我的收藏";
        }
            break;
            
        case 2:
        {
            cell.textLabel.text = @"清除缓存";
#warning 清除缓存没有实现*&%*&%*&^%*(&^*(&
        }
            break;
            
        case 3:
        {
            cell.textLabel.text = @"关于我们";
#warning 关于我们没有实现*&%*&%*(%&*(%(&(
        }
            break;
            
        default:
            break;
    }
//    cell.textLabel.text = @"测试";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationController.navigationBarHidden = NO;
    if (indexPath.row == 0) {
        
        DownloadedController *dVC = [[DownloadedController alloc]init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dVC];
        [self.navigationController pushViewController:dVC animated:YES];
    }else if (indexPath.row == 1){
        CollectViewController *collectVC = [[CollectViewController alloc]init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }else if (indexPath.row == 2){
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        [fm removeItemAtPath:cache error:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   
    
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
