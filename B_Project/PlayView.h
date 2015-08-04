//
//  PlayView.h
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayView : UIView

//  自定义播放界面上的返回按钮
@property (nonatomic, strong) UIButton *backButton;
//  自定义播放界面上的电影的title
@property (nonatomic, strong) UILabel *movieName;
//  分享按钮
@property (nonatomic, strong) UIButton *shareButton;
//  收藏按钮
@property (nonatomic, strong) UIButton *colletionButton;
//  缓存按钮
@property (nonatomic, strong) UIButton *saveButton;
//  开始播放的时间的label
@property (nonatomic, strong) UILabel *startTimeLabel;
//  结束播放的时间的label
@property (nonatomic, strong) UILabel *endTimeLabel;
//  播放进度的slider
@property (nonatomic, strong) UISlider *progressSlider;
//  播放按钮
@property (nonatomic, strong) UIButton *playButton;
//  音量slider
@property (nonatomic, strong) UISlider *voiceSlider;
//  音量图标
@property (nonatomic, strong) UIImageView *voiceImageView;
// 缓存进度
@property (nonatomic , strong) UIProgressView *progressView;

// 自定义播放界面上部的操作视图
@property (nonatomic, strong) UIView *topOperationView;
//  自定义播放界面上的左部的操作视图
@property (nonatomic, strong) UIView *leftOperationView;
//  自定义播放界面上的右部的操作视图
@property (nonatomic, strong) UIView *rightOperationView;
//  自定义播放界面上的底部的操作视图
@property (nonatomic, strong) UIView *bottomOperationView;

@end
