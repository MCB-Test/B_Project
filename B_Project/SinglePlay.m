//
//  SinglePlay.m
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "SinglePlay.h"
static SinglePlay *play = nil;

@implementation SinglePlay

+(SinglePlay *)shareSinglePlay
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        play = [[SinglePlay alloc]init];
    });
    return play;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.player = [[AVPlayer alloc]init];
        self.playUrl = nil;
        self.progressValue = 0;
        self.startText = nil;
    }
    return self;
}

- (void)playWithUrl:(NSString *)url
{
    self.item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    self.player = [AVPlayer playerWithPlayerItem:self.item];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (nil == play) {
        play = [super allocWithZone:zone];
    }
    return play;
}

- (id)copy
{
    return self;
}

@end
