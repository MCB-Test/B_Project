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
#import "AboutUsController.h"
#import "AppDelegate.h"

@interface MineController ()<UITableViewDataSource , UITableViewDelegate , UIAlertViewDelegate>

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor brownColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 80, 30)];
    
    self.tableView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 69);
  
}
- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏导航条
    self.navigationController.navigationBarHidden = YES;
    [self.tableView reloadData];
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
            
            self.label.text =[NSString stringWithFormat:@"%.2fMB" , [self filePath]];
            [cell addSubview:self.label];
        }
            break;
            
        case 3:
        {
            cell.textLabel.text = @"关于我们";
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
//        NSFileManager *fm = [NSFileManager defaultManager];
//        NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
//        [fm removeItemAtPath:cache error:nil];
        [self clearRubbishes];
    }else{
        AboutUsController *aboutVC = [[AboutUsController alloc]init];
        [self presentViewController:aboutVC animated:YES completion:nil];
    }
        
}
#pragma mark - 清楚缓存
-(void)clearRubbishes
{
    NSString *cachePath;
    cachePath = [self handlePersonalBuffer];
    NSString *messange = [NSString stringWithFormat:@"有%.2fMB的缓存，确定要删除吗？",[self folderSizeAtPath:cachePath]];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:messange delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

// 计算缓存大小
- ( float )filePath
{
    //缓存路径
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
}
- (float)folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFileEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long folderSize = 0;
    while ((fileName = [childFileEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
-(long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
}

-(NSString*)handlePersonalBuffer
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    return cachePath;
}
-(void)clearCache:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
//    [self.label removeFromSuperview];
    self.label.text = [NSString stringWithFormat:@"%.2fMB" , [self filePath]];
    [self.tableView reloadData];
}

#pragma mark -- AlertDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 1:
//#warning 删除各种数据
        {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            //清除Downloaded里面保存的数据
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Downloaded"];
            NSError *error = nil;
            NSArray *fetchArr = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if (fetchArr) {
                for (Downloaded *model in fetchArr) {
                    [appDelegate.managedObjectContext deleteObject:model];
                }
            }
            //清除Downloading里面保存的数据
            NSFetchRequest *fetchRequest2 = [NSFetchRequest fetchRequestWithEntityName:@"Downloading"];
            NSError *error2 = nil;
            NSArray *fetchArr2 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest2 error:&error2];
            if (fetchArr2) {
                for (Downloaded *model in fetchArr2) {
                    // 移除监听
                    if (self.deleteBlock) {
                        self.deleteBlock(model);
                    }
                    
                    [appDelegate.managedObjectContext deleteObject:model];
                }
            }
            //清除CollectModel里面保存的数据
            NSFetchRequest *fetchRequest3 = [NSFetchRequest fetchRequestWithEntityName:@"CollectModel"];
            NSError *error3 = nil;
            NSArray *fetchArr3 = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest3 error:&error3];
            if (fetchArr3) {
                for (Downloaded *model in fetchArr) {
                    [appDelegate.managedObjectContext deleteObject:model];
                }
            }
            
            [[SingleDownLoad shareSingleDownload].dic removeAllObjects];
            [[SingleDownLoad shareSingleDownload].operationArray removeAllObjects];
            [[SingleDownLoad shareSingleDownload].modelArray removeAllObjects];
            
            [self clearCache:[self handlePersonalBuffer]];
        }
            break;
            
        case 0:
            
            break;
            
        default:
            break;
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
