//
//  SingleDownLoad.h
//  B_Project
//
//  Created by lanouhn on 15/7/30.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^DownloadFinishBolck)(id model);

@interface SingleDownLoad : NSObject

@property (nonatomic , assign) float progress;
// 保存不同MV下载进度
@property (nonatomic , strong) NSMutableDictionary *dic;
// 头像保存
@property (nonatomic , strong) UIImage *image;
// 保存要下载的MV信息
@property (nonatomic , strong) NSMutableArray *modelArray;
@property (nonatomic , strong) NSMutableArray *operationArray;
// 创建下载队列
@property (nonatomic , strong) NSOperationQueue *queue;

@property (nonatomic , copy) DownloadFinishBolck downloadFinishedBlock;

+(SingleDownLoad *)shareSingleDownload;

// 下载方法
- (void)downloadWithModel:(id)dModel;

@end
