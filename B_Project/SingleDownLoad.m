//
//  SingleDownLoad.m
//  B_Project
//
//  Created by lanouhn on 15/7/30.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "SingleDownLoad.h"
static SingleDownLoad *singleDownload = nil;

@implementation SingleDownLoad

+(SingleDownLoad *)shareSingleDownload
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleDownload = [[SingleDownLoad alloc]init];
    });
    return singleDownload;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.queue = [[NSOperationQueue alloc]init];
//        [self.queue setMaxConcurrentOperationCount:2];
        self.modelArray = [NSMutableArray array];
        self.operationArray = [NSMutableArray array];
        self.progress = 0;
    }
    
    return self;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (singleDownload == nil) {
        singleDownload = [super allocWithZone:zone];
    }
    return singleDownload;
}

- (id)copy
{
    return self;
}

- (NSMutableDictionary *)dic
{
    if (!_dic) {
        self.dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

#pragma mark 下载方法实现
- (void)downloadWithModel:(id)dModel
{
        Downloading *model = (Downloading *)dModel;
//    // 寻找沙盒路径，判断文件是否已经存在
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
//    // 获取文件路径
//    // 先拿到要下载的文件
//    Model *model = [self.modelArray lastObject];
//
//    // 拼接保存路径
    NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4" , model.title]];
    

        // 开始下载
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.url240] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:-1];
        
        AFHTTPRequestOperation *opration = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
        // 将任务放进任务下载数组中
    [self.operationArray addObject:opration];
    
        // 下载的方法中，我们可以用下面这个方法，用它可以来观察进度，可以做进度条
        // 第一个参数bytesRead：本次执行下载了多少字节
        // totalBytesRead：已经下载了多少
        // totalBytesExpectedToRead：文件总大小
        
        // 防止内存问题（内存泄露），当你在block中引用self，不知道到底有没有内存泄露的时候加上下面一行代码，就不会有内存泄露问题
        // block里面用weakSelf
        __weak typeof(self) weakSelf = self;
        [opration setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            // 保存下载进度条
            weakSelf.progress = (float)totalBytesRead / totalBytesExpectedToRead;
            NSString *str = model.title;
            [self.dic setValue:[NSString stringWithFormat:@"%f" , weakSelf.progress] forKey:str];
            
//            NSLog(@"%@已经下载了%f" , model.title , weakSelf.progress);
            
        }];
        
        // 告诉下载的data下载到哪个文件
        opration.outputStream = [[NSOutputStream alloc]initToFileAtPath:filePath append:YES];

    
        // 下载完成后的回调******》》》》》《《《《《《《《《《《》》》》》》》》《》《》《》********
        [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // 从下载队列移除任务,同时开启下一条任务《》《》《《》《》《》《》《》《》《》《
            [self.operationArray removeObjectAtIndex:0];
            if (self.operationArray.count == 0) {
                // 如果下载数组为空，则不执行任何操作，否则开始下一条
                [self.modelArray removeObjectAtIndex:0];
            }else{
                [self.modelArray removeObjectAtIndex:0];
                Downloading *model = [self.modelArray objectAtIndex:0];
                [[SingleDownLoad shareSingleDownload] downloadWithModel:model];
            }
            // 将下载成功的MVmodel保存进coreData的DownLoaded里面，用于下载界面展示
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            Downloaded *downloadedModel = [NSEntityDescription insertNewObjectForEntityForName:@"Downloaded" inManagedObjectContext:appDelegate.managedObjectContext];
            downloadedModel.title = model.title;
            downloadedModel.artist = model.artist;
            downloadedModel.thumbnail = model.thumbnail;
            [appDelegate saveContext];
            
            // 将下载好的文件图片存入缓存区《》《》《》《》《》《》《》《》《》《》《》
            
            
            
            // 调用block将下载好的model信息传出去，用于移除对该model的观察对象
            if (self.downloadFinishedBlock) {
                self.downloadFinishedBlock(model);
            }
            // 从coredata中删除该MVmodel
            [appDelegate.managedObjectContext deleteObject:model];
            [appDelegate saveContext];
            
            // 从本身下载数组中删除
//            [self.modelArray removeObject:model];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"下载失败");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@下载失败" , model.title] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            NSLog(@"*&*&^*^&*&^*");
            [alert show];
        }];
    
    
    AFHTTPRequestOperation *op = [self.operationArray objectAtIndex:0];
    [op start];
    
        // 单个任务的话需要手动开启即：[operation start];
        // 多个任务的话放进NSOperationQueue里面，这样任务直接开启不用手动start
//        [self.queue addOperation:opration];

  
}

@end
