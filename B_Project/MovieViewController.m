//
//  MovieViewController.m
//  YinYueTai
//
//  Created by lanouhn on 15/7/1.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "MovieViewController.h"

@interface MovieViewController ()<UIAlertViewDelegate>

@property (nonatomic , assign) NSInteger mark;
@property (nonatomic , retain) MPMoviePlayerController *player;

@property (nonatomic , retain) MPMoviePlayerViewController *playViewController;


@property (nonatomic, strong) AFHTTPRequestOperation *reqestOperation;
//@property (nonatomic , strong) Helper *helper;

@property (nonatomic , assign) CGFloat precent;

@property (nonatomic , retain) NSMutableArray *dataArray;

@property (nonatomic , retain) NSMutableArray *downLoadArray;

@property (nonatomic , retain) UILabel *downloadLabel;


@end

@implementation MovieViewController

-(void)viewWillAppear:(BOOL)animated
{
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.helper = [Helper shareHelp];
    

//    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    if (self.model.url480 != nil) {
        NSURL *movieURL = [NSURL URLWithString:self.model.url480];
        self.playViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
//        NSLog(@"播放地址%@" , self.model.url480);
    }else{
        NSURL *movieURL = [NSURL URLWithString:self.model.url360];
        self.playViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
//        NSLog(@"播放地址%@" , self.model.url360);
    }
    
    
    // 添加监听者(全屏之后,按Done退出之后停止播放)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[self.playViewController moviePlayer]];
    
    self.playViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    
    self.player = [self.playViewController moviePlayer];
    [self.player prepareToPlay];
    
    [self.player play];
    
    [self.view addSubview:self.player.view];
    
    // 自动播放打开
    self.player.shouldAutoplay = YES;
    [self.player setControlStyle:MPMovieControlStyleDefault];
    // 是否充满全屏
    [self.player setFullscreen:YES];
    [self.player.view setFrame:CGRectMake(0, 30, self.view.frame.size.width, 300)];
    
    self.downloadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3 * self.view.frame.size.height / 4, self.view.frame.size.width, 50)];
    self.downloadLabel.textColor = [UIColor whiteColor];
    self.downloadLabel.textAlignment = NSTextAlignmentCenter;
//    self.downloadLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.downloadLabel];
    
    //判断网络
    [self checkNetWorkState];
    
    //播放历史
//    [self historyList];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnAction:)];
    
    
}

#pragma mark - 返回上一级,并且停止播放视频
-(void)leftBarBtnAction:(UIBarButtonItem *)sender
{
    [self.player stop];
    [self.navigationController popViewControllerAnimated:YES];
}


//#pragma mark - 存储播放记录
//-(void)historyList
//{
//    NSString *filePath = [[Function createFileAndPath]stringByAppendingString:@"/history"];
//    NSArray *array = [NSArray arrayWithObjects:self.model.title , self.model.artistName , self.model.posterPic , self.model.mtvUrl , nil];
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:filePath]) {
//        self.dataArray = [NSMutableArray array];
//    }else {
//        self.dataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
//    }
//    
//    if (![self.dataArray containsObject:array]) {
//        [self.dataArray addObject:array];
//        [self.dataArray writeToFile:filePath atomically:YES];
//    }
//    
//}




- (void)playVideoFinished:(NSNotification *)theNotification
{
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    
}


#pragma mark - 判断网络状态
- (void)checkNetWorkState
{
    // 先让自动播放停止
    [self.player stop];
    // 1. 检测WIFI状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2. 检测手机是否能上网(wifi\3G\2.5G)
    Reachability *connection = [Reachability reachabilityForInternetConnection];
    // 判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) {
        self.mark = 0;
        [self promptBox];
    } else if ([connection currentReachabilityStatus] != NotReachable) {
        self.mark = 1;
        [self promptBox];
    } else {
        self.mark = 2;
        [self promptBox];
    }
    
}

- (void)promptBox
{
    NSArray *arr = @[@"当前网络处于WiFi状态是否播放", @"使用手机自带网络是否播放",@"当前设备无法连接网络"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:arr[self.mark] delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.player play];
            break;
        case 1:
            if (self.mark == 2) {
//                MTVTableViewController *mtvVC = [[MTVTableViewController alloc] init];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                break;
            }
            break;
        default:
            break;
    }
}

//-(void)dealloc
//{
//    [_dataArray release];
//    [_downLoadArray release];
//    [_player release];
//    [_playViewController release];
//    [super dealloc];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
