//
//  PlayViewController.m
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "PlayView.h"
#import "CollectModel.h"

@interface PlayViewController ()<UIAlertViewDelegate>
// 视频的显示页面
@property (nonatomic , strong) PlayView *playView;
@property (nonatomic, assign) BOOL isFirstTap;
@property (nonatomic, assign) BOOL isPlayOrParse;

// 保存该视频资源的总长，快进或快退是候要用
@property (nonatomic , assign) CGFloat totalMovieDuration;

@end

@implementation PlayViewController

// 使用MVC可以重写loadView方法，也可以使用在viewDidload方法中直接加载view，都可以
- (void)loadView
{
    self.playView = [[PlayView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _playView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.urlStr = [self.model.source objectForKey:@"480"];
    
    // 判断接受的播放地址是否与单例保存的地址相同
    if ([[SinglePlay shareSinglePlay].playUrl isEqualToString:self.urlStr]) {
        // 相同的话弹出提示框选择是否继续播放
        self.playView.startTimeLabel.text = [SinglePlay shareSinglePlay].startText;
        self.playView.progressSlider.value = [SinglePlay shareSinglePlay].progressValue;
        [[SinglePlay shareSinglePlay].player play];
        [self.playView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
        self.isPlayOrParse = YES;
        [self addProgressObserver];
        [self addObserverToPlayerItem:[SinglePlay shareSinglePlay].item];
    }else{
        // 不同的话播放新地址
        [SinglePlay shareSinglePlay].playUrl = self.urlStr;
        
        [[SinglePlay shareSinglePlay] playWithUrl:self.urlStr];
        
        // 添加进度观察
        [self addProgressObserver];
        [self addObserverToPlayerItem:[SinglePlay shareSinglePlay].item];
    }
    
    
    // 注册观察者用来观察，看是否播放完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 创建视频播放层
    // AVPlayer要显示必须创建一个播放器层AVPlayerLayer用于展示，播放器层继承于CALayer，有了AVPlayerLayer只添加到控制器视图的layer中即可
 
    // 创建显示层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:[SinglePlay shareSinglePlay].player];
    // 设置frame
    CGRect frame = self.view.bounds;
    frame.size.height = self.view.bounds.size.width;
    frame.size.width = self.view.bounds.size.height;
    playerLayer.frame = frame;
    
    // 这是视屏的填充模式，默认为AVLayerVideoGravityResizeAspect
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 插入到view的层上，
    [self.view.layer insertSublayer:playerLayer atIndex:0];
    
    // 设置初始音量
    [[SinglePlay shareSinglePlay].player setVolume:self.playView.voiceSlider.value];
    
    //  播放按钮的点击事件
    [self.playView.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //  播放页面添加轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllSubviews:)];
    [self.view addGestureRecognizer:tap];
    
    //  给音量的滑杆设置事件
    [self.playView.voiceSlider addTarget:self action:@selector(voiceSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    //  给进度的滑杆设置事件
    [self.playView.progressSlider addTarget:self action:@selector(scrubberIsScrolling:) forControlEvents:UIControlEventValueChanged];
    
    //  分享按钮的点击事件
    [self.playView.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //  收藏按钮的点击事件
    [self.playView.colletionButton addTarget:self action:@selector(colletionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //  缓存按钮的点击事件
    [self.playView.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
 
    // 返回按钮点击事件
    [self.playView.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 相同播放地址选择是否继续
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:{
//#warning 判断播放进度*&……*&……*……
//            //            [SinglePlay shareSinglePlay].playUrl = nil;
//            //
//            //            [SinglePlay shareSinglePlay].playUrl = self.urlStr;
//            
//            [[SinglePlay shareSinglePlay] playWithUrl:self.urlStr];
//            
//            // 添加进度观察
//            [self addProgressObserver];
//            [self addObserverToPlayerItem:[SinglePlay shareSinglePlay].item];
//        }
//            break;
//        case 1:
//        {
//            self.playView.startTimeLabel.text = [SinglePlay shareSinglePlay].startText;
//            self.playView.progressSlider.value = [SinglePlay shareSinglePlay].progressValue;
//            [[SinglePlay shareSinglePlay].player play];
//            [self.playView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
//            self.isPlayOrParse = YES;
//            [self addProgressObserver];
//            [self addObserverToPlayerItem:[SinglePlay shareSinglePlay].item];
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//}



// 界面消失时候暂停播放
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 保存播放进度
    [SinglePlay shareSinglePlay].progressValue = self.playView.progressSlider.value;
    // 保存已播放时间
    [SinglePlay shareSinglePlay].startText = self.playView.startTimeLabel.text;
    
}

#pragma mark 分享按钮的点击事件
- (void)shareButtonAction:(UIButton *)sender
{
    NSLog(@"您点击了分享！");
}
#pragma mark 收藏按钮的点击事件
- (void)colletionButtonAction:(UIButton *)sender
{
    NSLog(@"您点击了收藏！");
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchrequest = [NSFetchRequest fetchRequestWithEntityName:@"CollectModel"];
    NSError *error = nil;
    NSArray *fetchArray = [appDelegate.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    if (fetchArray) {
        BOOL isExit = NO;
        for (CollectModel *dic in fetchArray) {
            if ([self.model.title isEqualToString:dic.title]) {
                isExit = YES;
            }
        }
        if (isExit) {
            MBProgressHUD *hud = [[MBProgressHUD alloc]init];
            [self.view addSubview:hud];
            hud.labelText = @"已收藏";
            hud.mode = MBProgressHUDModeText;
            hud.dimBackground = YES;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
            }];
            
        }else{
            CollectModel *collectModel = [NSEntityDescription insertNewObjectForEntityForName:@"CollectModel" inManagedObjectContext:appDelegate.managedObjectContext];
            collectModel.title = self.model.title;
            collectModel.artist = self.model.artist;
            collectModel.thumbnail = self.model.thumbnail;
            collectModel.url240 = self.model.url240;
            collectModel.url360 = self.model.url360;
            collectModel.url480 = self.model.url480;
            collectModel.url720 = self.model.url720;
            
            [appDelegate saveContext];
            MBProgressHUD *hud = [[MBProgressHUD alloc]init];
            [self.view addSubview:hud];
            hud.labelText = @"收藏成功";
            hud.mode = MBProgressHUDModeDeterminate;
            hud.dimBackground = YES;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
            }];
            
        }
    }else{
        CollectModel *collectModel = [NSEntityDescription insertNewObjectForEntityForName:@"CollectModel" inManagedObjectContext:appDelegate.managedObjectContext];
        collectModel.title = self.model.title;
        collectModel.artist = self.model.artist;
        collectModel.thumbnail = self.model.thumbnail;
        collectModel.url240 = self.model.url240;
        collectModel.url360 = self.model.url360;
        collectModel.url480 = self.model.url480;
        collectModel.url720 = self.model.url720;
        
        [appDelegate saveContext];
        NSLog(@"收藏成功！");
    }

    
    
}
#pragma mark 缓存按钮的点击事件
- (void)saveButtonAction:(UIButton *)sender
{
    NSLog(@"您点击了保存！");
    
    
}
#pragma mark 返回按钮点击事件
- (void)backAction:(UIButton *)sender
{
    // 如果视频正在播放就让他暂停
    if (self.isPlayOrParse) {
        [[SinglePlay shareSinglePlay].player pause];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - mark 轻拍手势的事件
- (void)dismissAllSubviews:(UIGestureRecognizer *)tap
{
    // 防止循环引用
    __weak typeof(self) myself = self;
    if (!self.isFirstTap) {
        [UIView animateWithDuration:1 animations:^{
            myself.playView.topOperationView.frame = CGRectMake(0, -54, self.view.frame.size.width, 54);
            myself.playView.bottomOperationView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 65);
            myself.playView.leftOperationView.frame = CGRectMake(-45, 62, 45, 185);
            myself.playView.rightOperationView.frame = CGRectMake(self.view.frame.size.width, 62, 45, 185);
            myself.isFirstTap = YES;
        }];
    }else{
        [UIView animateWithDuration:.2f animations:^{
            myself.playView.topOperationView.frame = CGRectMake(0, 0, self.view.frame.size.width ,54);
            myself.playView.bottomOperationView.frame = CGRectMake(0, self.view.frame.size.height - 65, self.view.frame.size.width, 65);
            myself.playView.leftOperationView.frame = CGRectMake(0, 62, 45, 185);
            myself.playView.rightOperationView.frame = CGRectMake(self.view.frame.size.width - 45, 62, 45, 185);
            myself.isFirstTap = NO;
            
        }];
    }
}

#pragma mark 调节音量
- (void)voiceSliderValueChange:(UISlider *)sender
{
    [[SinglePlay shareSinglePlay].player setVolume:sender.value];
    if (sender.value == 0) {
        self.playView.voiceImageView.image = [UIImage imageNamed:@"播放器_静音"];
    }else{
        self.playView.voiceImageView.image = [UIImage imageNamed:@"播放器_音量"];
    }
    
}

#pragma - mark 播放或暂停
- (void)playButtonAction:(UIButton *)sender
{
    //  在这里你可以自己设置bool值来判断是否正在播放或者已经停止，也可以通过，播放器自带的rate属性，当rate为0时，为暂停，当rate为1时为正在播放
    if (!self.isPlayOrParse) {
        // 如果是暂停状态就开始播放
        [[SinglePlay shareSinglePlay].player play];
        // 切换按钮图片
        [sender setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
        NSLog(@"点击开始播放");
        self.isPlayOrParse = YES;
    }else{
        // 视频暂停播放
        [[SinglePlay shareSinglePlay].player pause];
        // 切换按钮图片
        [sender setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
        self.isPlayOrParse = NO;
        NSLog(@"点击开始暂停");
    }
    
}

#pragma - mark 调节进度
- (void)scrubberIsScrolling:(UISlider *)sender
{
    // 先暂停
    [[SinglePlay shareSinglePlay].player pause];
    // 图片切换
    [self.playView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
    
    float current = (float)(self.totalMovieDuration * sender.value);
    CMTime currentTime = CMTimeMake(current, 1);
    // 给AVPlayer设置进度
    [[SinglePlay shareSinglePlay].player seekToTime:currentTime completionHandler:^(BOOL finished) {
        [self.playView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
        [[SinglePlay shareSinglePlay].player play];
    }];
}

#pragma mark 播放结束后的代理回调
- (void)moviePlayDidEnd:(NSNotification *)notif
{
    // 播放按钮设置成播放图片
    [self.playView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
}

// 依靠AVPlayer的- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block方法获得播放进度，这个方法会在设定的时间间隔内定时更新播放进度，通过time参数通知客户端。有了这些视频信息，播放进度就不成问题了，事实上通过这些信息就算是平时看到的其他播放器的缓冲进度显示以及拖动播放的功能也可顺利完成
- (void)addProgressObserver
{
    // 获取当前媒体资源管理对象
    AVPlayerItem *item = [SinglePlay shareSinglePlay].player.currentItem;
    __weak typeof(self) myself = self;
    // 设置每秒执行一次
    [[SinglePlay shareSinglePlay].player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 获取当前进度
        float current = CMTimeGetSeconds(time);
        // 获取全部资源的大小
        float total = CMTimeGetSeconds([item duration]);
        // 计算出进度
        if (current) {
            [myself.playView.progressSlider setValue:(current / total) animated:YES];
            
            // 设置slider左右颜色都为透明
            UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
            UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [myself.playView.progressSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
            [myself.playView.progressSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
            
            // 显示已播放时间
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:current];
            NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
            if (current / 3600 >= 1) {
                [fomatter setDateFormat:@"HH:mm:ss"];
            }else{
                [fomatter setDateFormat:@"00:mm:ss"];
            }
            NSString *showTimeNew = [fomatter stringFromDate:date];
            myself.playView.startTimeLabel.adjustsFontSizeToFitWidth = YES;
            myself.playView.startTimeLabel.text = showTimeNew;
            
        }
  
    }];
    
}

//  这个方法，用来取得播放进度，播放进度就没有其他播放器那么简单了。在系统播放器中通常是使用通知来获得播放器的状态，媒体加载状态等，但是无论是AVPlayer还是AVPlayerItem（AVPlayer有一个属性currentItem是AVPlayerItem类型，表示当前播放的视频对象）都无法获得这些信息。当然AVPlayerItem是有通知的，但是对于获得播放状态和加载状态有用的通知只有一个：播放完成通知AVPlayerItemDidPlayToEndTimeNotification。在播放视频时，特别是播放网络视频往往需要知道视频加载情况、缓冲情况、播放情况，这些信息可以通过KVO监控AVPlayerItem的status、loadedTimeRanges属性来获得当AVPlayerItem的status属性为AVPlayerStatusReadyToPlay是说明正在播放，只有处于这个状态时才能获得视频时长等信息；当loadedTimeRanges的改变时（每缓冲一部分数据就会更新此属性）可以获得本次缓冲加载的视频范围（包含起始时间、本次加载时长），这样一来就可以实时获得缓冲情况。
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem
{
    // 监控状态属性，注意AVPlayer也有一个status属性，通过监控他的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

// 观察者的方法，会在加载好后触发，我们可以在这个方法中，保存总文件的大小，用于后面的进度实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playItem = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放。。。，视频总长度:%.2f" , CMTimeGetSeconds(playItem.duration));
            
            CMTime totalTime = playItem.duration;
            // 因为slider的值是小数，要转换成float，当前时间和总时间相除才能得到小数
            self.totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_totalMovieDuration];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            
            if (_totalMovieDuration/3600 >= 1) {
                [formatter setDateFormat:@"HH:mm:ss"];
            }else{
                [formatter setDateFormat:@"00:mm:ss"];
            }
            NSString *showTimeNew = [formatter stringFromDate:date];
            self.playView.endTimeLabel.adjustsFontSizeToFitWidth = YES;
            self.playView.endTimeLabel.text = showTimeNew;
            
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = playItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];// 本次缓冲时间范围
        float startSenonds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSenonds + durationSeconds;// 缓冲总长度
        NSLog(@"共缓冲：%.2f" , totalBuffer);
        self.playView.progressView.progress = (totalBuffer / CMTimeGetSeconds(playItem.duration));
    }
}


// 进入该试图控制器自动横屏进行播放
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeObserverFromPlayerItem:[SinglePlay shareSinglePlay].player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
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
