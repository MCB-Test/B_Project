//
//  DownloadedController.m
//  B_Project
//
//  Created by lanouhn on 15/7/31.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "DownloadedController.h"
#import "DownloadedCell.h"

#import <MediaPlayer/MediaPlayer.h>

#define kDownloadedCell @"kDownloadedCell"

@interface DownloadedController ()<UICollectionViewDataSource , UICollectionViewDelegate , UIAlertViewDelegate>

@property (nonatomic , strong) UICollectionView *collectionView;

@end

@implementation DownloadedController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Downloaded"];
    NSError *error = nil;
    NSArray *fetchArray = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchArray) {
        self.downloadedArray = [fetchArray mutableCopy];
    }else{
        NSLog(@"我的下载页面数据获取失败%@" , error);
    }
}

- (NSMutableArray *)downloadedArray
{
    if (!_downloadedArray) {
        self.downloadedArray = [NSMutableArray array];
    }
    return _downloadedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的下载";
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"清空所有" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllAction:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    // UICollectionViewFlowLayout 继承于 UICollectionViewLayout
    // 是专门用来处理UICollectionView 的布局问题
    // 创建用来布局的flowLayout对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // 设置item大小
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 15)/2, (self.view.frame.size.width - 15)/2);
    
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    // 设置item之间的最小距离
    layout.minimumInteritemSpacing = 5;
    
    // 设置行之间的最小间距
    layout.minimumLineSpacing = 5;
    
    // 设置集合视图的滑动方向
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置分区页眉（header）大小
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 30);
    
    // 设置分区页脚（footer）大小
    layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 60);

    // 创建集合视图UICollectionView（同时绑定layout布局）
    self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    
    // 设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    // 注册item
    // 第一个是告诉collection要注册的cell类型，第二个是重用标识符
    [self.collectionView registerClass:[DownloadedCell class] forCellWithReuseIdentifier:kDownloadedCell];
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionView 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.downloadedArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 直接重用cell，不用创建，因为仓库里面没有cell的话collectionView会自己创建该、DownloadedCell，不用我们管（更深层次原因：我们已经把DownloadedCell注册给collectionView了，所以collectionView会自己完成cell的创建工作）
    DownloadedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDownloadedCell forIndexPath:indexPath];
    Downloaded *model = self.downloadedArray[indexPath.row];
    cell.thumbnail.image = [UIImage imageWithData:model.image];
    cell.titleLabel.text = model.title;
    [cell.button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = 100 + indexPath.row;
    
    return cell;
}

//#warning 本地播放没有删除功能*T*&^T*^(&&*^&^*(
// 删除所有
- (void)deleteAllAction:(UIBarButtonItem *)sender
{
    NSString *str = [NSString stringWithFormat:@"您确定要删除全部歌曲"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 100;
    [alert show];
}
// 删除单个
- (void)deleteAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    Downloaded *downLoadedModel = self.downloadedArray[index];
    self.downloadedModel = downLoadedModel;
    NSString *str = [NSString stringWithFormat:@"您确定要删除%@" , downLoadedModel.title];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 101;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        
        if (buttonIndex == 0) {
            
            // 从本地文件删除文件
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
            NSString *filePath = [cache stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4" , self.downloadedModel.title]];
            if ([fm fileExistsAtPath:filePath]) {
                [fm removeItemAtPath:filePath error:nil];
            }else{
                NSLog(@"路径错误，无该文件");
            }
            
            // 当前界面数组中删除
            [self.downloadedArray removeObject:self.downloadedModel];
            // 从coreData删除
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate.managedObjectContext deleteObject:self.downloadedModel];
            [delegate saveContext];
            // 刷新
            [self.collectionView reloadData];
            
            
        }else{
            ;
        }
    }else if (alertView.tag == 100){
        if (buttonIndex == 0) {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            for (int i = 0; i < self.downloadedArray.count; i++) {
                Downloaded *model = self.downloadedArray[i];
                // 从本地文件删除文件
                NSFileManager *fm = [NSFileManager defaultManager];
                NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
                NSString *filePath = [cache stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4" , model.title]];
                if ([fm fileExistsAtPath:filePath]) {
                    [fm removeItemAtPath:filePath error:nil];
                }else{
                    NSLog(@"路径错误，无该文件");
                }

                [delegate.managedObjectContext deleteObject:model];
                [delegate saveContext];

            }
            
            [self.downloadedArray removeAllObjects];
            
            [self.collectionView reloadData];
            
        }else{
            ;
        }
        
    }
}


// 每个item的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Downloaded *model = self.downloadedArray[indexPath.row];
    
    // 从本地文件搜索
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *modelPath = [cache stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4" , model.title]];
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:modelPath]];
    // 弹出播放界面
    [self presentMoviePlayerViewControllerAnimated:player];
    
    NSLog(@"你点击了%@" , model.title);
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
