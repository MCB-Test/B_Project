//
//  DownLoadController.m
//  B_Project
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "DownLoadController.h"
#import "DownloadCell.h"
#import "SVPullToRefresh.h"

@interface DownLoadController ()<UITableViewDelegate , UITableViewDataSource>

@end

@implementation DownLoadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor purpleColor];
   
//    __weak typeof(self) weakSelf = self
//   [self.doladTableView addPullToRefreshWithActionHandler:^{
//       [self refresh];
//   }];
    
    [SingleDownLoad shareSingleDownload].downloadFinishedBlock = ^(Model *model){
        // 下载完毕，移除监听者
        [[SingleDownLoad shareSingleDownload].dic removeObserver:self forKeyPath:model.title];
        // 从保存下载进度的字典中删除model
        [[SingleDownLoad shareSingleDownload].dic removeObjectForKey:model.title];
        
        // 从下载列表删除该model
//        if (self.downloadingArray) {
//            [self.downloadingArray removeAllObjects];
//        }
//        self.navigationController.navigationBarHidden = YES;
//        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//        NSFetchRequest *fetchrequest = [NSFetchRequest fetchRequestWithEntityName:@"Downloading"];
//        NSError *error = nil;
//        NSArray *fetchArr = [appDelegate.managedObjectContext executeFetchRequest:fetchrequest error:&error];
//        if (fetchArr) {
//            self.downloadingArray = [fetchArr mutableCopy];
//        }else{
//            NSLog(@"下载页面展示数据获取失败%@" , error);
//        }
        [self.downloadingArray removeObject:model];
        [self.doladTableView reloadData];
        NSLog(@"%@已经下载完毕" , model.title);
    };

    
}

- (void)refresh
{
    [self.doladTableView reloadData];
    [self.doladTableView.pullToRefreshView stopAnimating];
}

- (NSMutableArray *)downloadingArray
{
    if (!_downloadingArray) {
        self.downloadingArray = [NSMutableArray array];
    }
    return _downloadingArray;
}
// 页面将要出现是刷新tableView显示最新数据
- (void)viewWillAppear:(BOOL)animated
{
    if (self.downloadingArray) {
        [self.downloadingArray removeAllObjects];
    }
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchrequest = [NSFetchRequest fetchRequestWithEntityName:@"Downloading"];
    NSError *error = nil;
    NSArray *fetchArr = [appDelegate.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    if (fetchArr) {
        self.downloadingArray = [fetchArr mutableCopy];
    }else{
        NSLog(@"下载页面展示数据获取失败%@" , error);
    }
    
}

#pragma - mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadingArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
    Downloading *downloadingModel = self.downloadingArray[indexPath.row];
    
    [cell.downloadImageview sd_setImageWithURL:[NSURL URLWithString:downloadingModel.thumbnail] placeholderImage:[UIImage imageNamed:@"home"]];
    cell.downloadImageview.layer.cornerRadius = 5;
    cell.downloadImageview.layer.masksToBounds = YES;
    cell.downloadName.text = downloadingModel.title;
    
    [cell.startAndStopButton addTarget:self action:@selector(stopOrStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = 100 + indexPath.row;
    
    NSArray *arr = [[SingleDownLoad shareSingleDownload].dic allKeys];
    for (NSString *str in arr) {
        if ([downloadingModel.title isEqualToString:str]) {
            cell.downloadProgress.progress = [[[SingleDownLoad shareSingleDownload].dic objectForKey:str] floatValue];
        }
    }
    
    
    [[SingleDownLoad shareSingleDownload].dic addObserver:self forKeyPath:[NSString stringWithFormat:@"%@" , downloadingModel.title] options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void *)(indexPath)];
 
    
    return cell;
}

#pragma mark - 暂停按钮点击事件
- (void)stopOrStartAction:(UIButton *)sender
{
#warning 从下载队列中暂停*****************
}

#pragma mark - 删除按钮点击事件
- (void)deleteAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
     Downloading *dModel = self.downloadingArray[index];
    // 1、移除对该对象的监听
    [[SingleDownLoad shareSingleDownload].dic removeObserver:self forKeyPath:[NSString stringWithFormat:@"%@" , dModel.title]];
    
    // 2、从SingleDownLoad中删除
//    NSInteger a = 1000;
//    NSString *str = nil;
//    for (int i = 0; i < [SingleDownLoad shareSingleDownload].modelArray.count; i++) {
//        Model *model = [SingleDownLoad shareSingleDownload].modelArray[i];
//        if ([model.title isEqualToString:dModel.title]) {
//            str = model.source[@"240"];
//            a = i;
//            [[SingleDownLoad shareSingleDownload].modelArray removeObjectAtIndex:i];
//            break;
//        }
//    }
#warning 从下载队列中移除*****************
    // 3、从下载队列中移除*****************
    // 现将当前任务取消
        AFHTTPRequestOperation *opretion = [SingleDownLoad shareSingleDownload].operationArray[0];
    [opretion cancel];
    // 从数组中移除任务
    [[SingleDownLoad shareSingleDownload].operationArray removeObjectAtIndex:0];
    [[SingleDownLoad shareSingleDownload].modelArray removeObjectAtIndex:0];
    // 开始下一条任务
    if ([SingleDownLoad shareSingleDownload].operationArray.count == 0) {
        // 如果下载数组为空，则不执行任何操作，否则开始下一条
    }else{
//        AFHTTPRequestOperation *op = [[SingleDownLoad shareSingleDownload].operationArray objectAtIndex:0];
//        [op start];
        Downloading *model = [[SingleDownLoad shareSingleDownload].modelArray objectAtIndex:0];
        [[SingleDownLoad shareSingleDownload] downloadWithModel:model];
    }
    
    // 4、从本地文件删除该对象文件夹
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *modelPath = [cache stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4" , dModel.title]];
    if ([fm fileExistsAtPath:modelPath]) {
        [fm removeItemAtPath:modelPath error:nil];
    } else {
//        NSLog(@"路径错误，没有该文件夹");
    }
    // 5、从展示界面的数据数组中删除
    [self.downloadingArray removeObjectAtIndex:index];
    // 7、将下载单例里面保存的下载进度删除
    [[SingleDownLoad shareSingleDownload].dic removeObjectForKey:dModel.title];
    NSLog(@"删除第%ld" , index);
    // 6、从coredata中删除
   
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.managedObjectContext deleteObject:dModel];
    [appDelegate saveContext];
    // 刷新界面
    [self.doladTableView reloadData];
}

#pragma mark - KVO 监听下载进度的触发方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // context:传入的indexPath(索引路径            )
    // object：监听的对象 itemModel
    // change：里面包含了keyParth对应的新值
    
    NSIndexPath *indexPath = (__bridge NSIndexPath *)context;
    NSString *str = nil;
    
        // 此时str需要取old，因为在视频下载完毕时候，监听到的old成为1，new并不是1，而是重新置为nl了。
        str = [change objectForKey:@"old"];
    
    // 获得当前屏幕正在显示的cells
    NSArray *indexPathArray = [self.doladTableView indexPathsForVisibleRows];
    // 如过我们下载时传入的indexPath包含在显示的indexPathArray中，更新cell的progress；
    if ([indexPathArray containsObject:indexPath]) {
        // 找到要更新进度条的cell
        DownloadCell *cell = (DownloadCell *)[self.doladTableView cellForRowAtIndexPath:indexPath];
        // 更新进度条
        cell.downloadProgress.progress = [str floatValue];
    }
    
}


- (void)dealloc
{
//    [SingleDownLoad shareSingleDownload].dic removeObserver:self forKeyPath:<#(NSString *)#>
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
