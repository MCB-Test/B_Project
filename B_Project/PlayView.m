//
//  PlayView.m
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

// 重写播放界面的init方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubviews];
    }
    return self;
}

// 设置自动横屏
- (void)layoutSubviews
{
    self.topOperationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 54);
    self.rightOperationView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 45, CGRectGetMaxY(_topOperationView.frame) + 8, 45, 185);
    self.bottomOperationView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 65, [UIScreen mainScreen].bounds.size.width, 65);
    self.endTimeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 9, 48, 21);
    
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.startTimeLabel.frame) + 6, 5, CGRectGetMinX(self.endTimeLabel.frame) - 12 - CGRectGetMaxX(self.startTimeLabel.frame), 31);
    
}

// 添加所有子视图
- (void)addSubviews
{
    // 顶部的操作视图
    self.topOperationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 54)];
    self.topOperationView.backgroundColor = [UIColor blackColor];
    self.topOperationView.alpha = 0.69;
    [self addSubview:_topOperationView];
    // 顶部返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"播放器_返回"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(4, 17, 36, 36);
    [self.topOperationView addSubview:_backButton];
    // 顶部添加movieNameLabel
    self.movieName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backButton.frame) + 1, 25, 362, 21)];
    self.movieName.font = [UIFont systemFontOfSize:13.0];
    self.movieName.tintColor = [UIColor whiteColor];
    [self.topOperationView addSubview:self.movieName];
    
    // 左面视图的操作
    self.leftOperationView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topOperationView.frame) + 8, 45, 185)];
    self.leftOperationView.backgroundColor = [UIColor blackColor];
    self.leftOperationView.alpha = 0.69;
    [self addSubview:_leftOperationView];
    // 左视图添加三个操作按钮
    // 分享按钮
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"分享_plyer"] forState:UIControlStateNormal];
    self.shareButton.frame = CGRectMake(7, 22, 27, 40);
//    [self.leftOperationView addSubview:self.shareButton];
    // 收藏按钮
    self.colletionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.colletionButton setBackgroundImage:[UIImage imageNamed:@"收藏_plyer"] forState:UIControlStateNormal];
    self.colletionButton.frame = CGRectMake(7, 22, 27, 40);
    [self.leftOperationView addSubview:self.colletionButton];
    // 缓存按钮
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"缓存_plyer"] forState:UIControlStateNormal];
    self.saveButton.frame = CGRectMake(7, CGRectGetMaxY(self.colletionButton.frame) + 10, 27, 40);
//    [self.leftOperationView addSubview:self.saveButton];

    //  右面的操作视图
    self.rightOperationView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, CGRectGetMaxY(_topOperationView.frame) + 8, 45, 185)];
    self.rightOperationView.backgroundColor = [UIColor blackColor];
    self.rightOperationView.alpha = 0.69;
    [self addSubview:_rightOperationView];
    
    // 右面试图添加两个控件
    // 音量滑竿
    self.voiceSlider = [[UISlider alloc]initWithFrame:CGRectMake(-27, 68, 100, 31)];
    self.voiceSlider.transform = CGAffineTransformRotate(self.voiceSlider.transform, -M_PI_2);
    self.voiceSlider.value = .5;
    [self.rightOperationView addSubview:_voiceSlider];
    // 音量图标
    self.voiceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"播放器_音量"]];
    self.voiceImageView.frame = CGRectMake(13, 143, 19, 19);
    [self.rightOperationView addSubview:_voiceImageView];
    
    //  底部的操作视图
    self.bottomOperationView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 65, [UIScreen mainScreen].bounds.size.width, 65)];
    self.bottomOperationView.backgroundColor = [UIColor blackColor];
    self.bottomOperationView.alpha = 0.69;
    [self addSubview:_bottomOperationView];
    
    // 底部视图上添加控件
    self.startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 9, 48, 21)];
    // 调整字体大小以适应宽度
    self.startTimeLabel.adjustsFontSizeToFitWidth = YES;
    self.startTimeLabel.text = @"00:00:00";
    self.startTimeLabel.textColor = [UIColor whiteColor];
    [self.bottomOperationView addSubview:_startTimeLabel];
    
    // 总时间
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 9, 48, 21)];
    self.endTimeLabel.textColor = [UIColor whiteColor];
    [self.bottomOperationView addSubview:_endTimeLabel];
    // 播放进度条
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.startTimeLabel.frame) + 6, 5, CGRectGetMinX(self.endTimeLabel.frame) - 6, 31)];
    [self.bottomOperationView addSubview:_progressSlider];
    // 缓冲进度
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.progressSlider.frame)- 50, CGRectGetMinY(self.progressSlider.frame) + CGRectGetHeight(self.progressSlider.frame)/2 -5, CGRectGetWidth(self.progressSlider.frame) + 205, 2)];
    [self.progressSlider addSubview:self.progressView];
    
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
    self.playButton.frame = CGRectMake(23, 35, 24, 24);
    [self.bottomOperationView addSubview:_playButton];
 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
