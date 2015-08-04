//
//  SinglePlay.h
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SinglePlay : NSObject

@property (nonatomic , strong)AVPlayer *player;
@property (nonatomic , strong)AVPlayerItem *item;

// 保存播放进度
@property (nonatomic , assign) double progressValue;
// 保存播放地址
@property (nonatomic , copy) NSString *playUrl;
// 保存播放时间
@property (nonatomic , copy)NSString *startText;

+ (SinglePlay *)shareSinglePlay;

- (void)playWithUrl:(NSString *)url;
@end
