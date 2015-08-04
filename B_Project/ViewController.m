//
//  ViewController.m
//  B_Project
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "ViewController.h"
#import "HomeCell.h"
#import "Model.h"
#import "PlayViewController.h"


#define kUrl1 @"http://api.mp3.zing.vn/api/mobile/video/getvideobygenre?fromvn=1&keycode=fafd463e2131914934b73310aa34a23f&requestdata=%7B%22id%22%3A%22"
#define kUrl2 @"%22%2C%22length%22%3A100%2C%22sort%22%3A%22total_play%22%2C%22start%22%3A0%7D"


@interface ViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic, strong) NSArray *allUrlArray;
@property (nonatomic , strong) NSMutableArray *allID;
@property (nonatomic , strong) NSMutableArray *allName;

@property (nonatomic , retain) NSMutableArray *allMVModels;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor cyanColor];
   
    
    self.allUrlArray = @[@{@"id":@8.0,@"name":@"V-pop"}, @{@"id": @11.0,@"name":@"V-romance"}, @{@"id": @10.0,@"name":@"V-rock"}, @{@"id": @9.0,@"name":@"V-rap"}, @{@"id": @66.0,@"name":@"V-dance"}, @{@"id": @13.0,@"name":@"V-country"}, @{@"id": @15.0,@"name":@"V-kid"}, @{@"id": @14.0,@"name":@"Trinh"}, @{@"id": @16.0,@"name":@"V-instrumental"}, @{@"id": @12.0,@"name":@"V-red"}, @{@"id": @58.0,@"name":@"V-ost"}, @{@"id": @70.0,@"name":@"Cailuong"}, @{@"id": @23.0,@"name":@"Pop"}, @{@"id": @25.0,@"name":@"Rock"}, @{@"id": @27.0,@"name":@"Rap"}, @{@"id": @22.0,@"name":@"Country"}, @{@"id": @26.0,@"name":@"Dance"}, @{@"id": @29.0,@"name":@"R&B"}, @{@"id": @99.0,@"name":@"Audiophile"}, @{@"id": @108.0,@"name":@"OST"}, @{@"id": @2.0,@"name":@"Kpop"}, @{@"id": @5.0,@"name":@"Jpop"}, @{@"id": @4.0,@"name":@"Cpop"}, @{@"id": @94.0,@"name":@"Gospel"}, @{@"id": @74.0,@"name":@"Indie"}, @{@"id": @71.0,@"name":@"Techno"}, @{@"id": @28.0,@"name":@"Jazz"}, @{@"id": @24.0,@"name":@"Newage"}, @{@"id": @30.0,@"name":@"Folk"}, @{@"id": @49.0,@"name":@"Classical"}, @{@"id": @48.0,@"name":@"Piano"}, @{@"id": @41.0,@"name":@"Guitar"}, @{@"id": @52.0,@"name":@"Violin"}, @{@"id": @42.0,@"name":@"National"}, @{@"id": @45.0,@"name":@"Cello"}, @{@"id": @51.0,@"name":@"Newage"}, @{@"id": @55.0,@"name":@"Saxo"}, @{@"id": @104.0,@"name":@"Other"}];
    for (NSDictionary *dic in self.allUrlArray) {
        NSString *idStr = [dic objectForKey:@"id"];
        NSString *nameStr = [dic objectForKey:@"name"];
        [self.allID addObject:idStr];
        [self.allName addObject:nameStr];
    }
//    NSLog(@"allid = %@ , allname = %@" , self.allID , self.allName);
    
    // 设置homeScrollView的contentSize
    self.homeScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 8, 30);
    
    // homeScrollView上添加Segment
    // 用数组self.allName初始化homeSegment
    self.homeSegment = [[UISegmentedControl alloc]initWithItems:self.allName];
    self.homeSegment.frame = CGRectMake(self.homeScrollView.frame.origin.x, self.homeScrollView.frame.origin.y, self.homeScrollView.contentSize.width, self.homeScrollView.contentSize.height);
    // 设置默认选择项索引值为0
    self.homeSegment.selectedSegmentIndex = 0;
    [self.homeSegment addTarget:self action:@selector(segmentTapAction:) forControlEvents:UIControlEventValueChanged];
    [self.homeScrollView addSubview:self.homeSegment];
 
    if (self.homeSegment.selectedSegmentIndex == 0) {
        // 拼接请求地址
        NSString *urlStr = kUrl1;
        urlStr = [urlStr stringByAppendingFormat:@"%@" , self.allID[0]];
        urlStr = [urlStr stringByAppendingString:kUrl2];
        self.homeUrl = urlStr;
//        NSLog(@"%@" , self.homeUrl);
    }
    
    [self getDataWithUrl];
    // 添加 加载动画
    self.hud = [[MBProgressHUD alloc]init];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    // 设置定时器，20s没有请求道数据的话提示从新加载
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(requestAction) userInfo:nil repeats:NO];

}

#pragma - mark 懒加载数据数组
// 懒加载
- (NSMutableArray *)allMVModels
{
    if (!_allMVModels) {
        self.allMVModels = [NSMutableArray array];
    }
    return _allMVModels;
}
- (NSArray *)allUrlArray
{
    if (!_allUrlArray) {
        self.allUrlArray = [NSArray array];
    }
    return _allUrlArray;
}
- (NSMutableArray *)allID
{
    if (!_allID) {
        self.allID = [NSMutableArray array];
    }
    return _allID;
}
- (NSMutableArray *)allName
{
    if (!_allName) {
        self.allName = [NSMutableArray array];
    }
    return _allName;
}
#pragma  - mark Segment点击事件
- (void)segmentTapAction:(UISegmentedControl *)segment
{
    NSInteger selecyIndex = segment.selectedSegmentIndex;
    for (NSInteger i = 1; i < self.allID.count; i++) {
        if (i == selecyIndex) {
            // 拼接请求地址
            NSString *urlStr = kUrl1;
            urlStr = [urlStr stringByAppendingFormat:@"%@" , self.allID[i]];
            urlStr = [urlStr stringByAppendingString:kUrl2];
            self.homeUrl = urlStr;
            break;
        }
    }
//   NSLog(@"%@" , self.homeUrl);
    [self getDataWithUrl];
    self.hud = [[MBProgressHUD alloc]init];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(requestAction) userInfo:nil repeats:NO];
    
}

// 20s后不能显示的话重新加载
- (void)requestAction
{
    if (self.hud != nil) {
        [self.hud removeFromSuperview];
        self.hud = nil;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力，请重新加载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma - mark 请求数据
- (void)getDataWithUrl
{
    // 如果model数组中还有数据清空数组
    if (self.allMVModels.count != 0) {
        [self.allMVModels removeAllObjects];
        [self.homeTableView reloadData];
    }
    
    AFClient *afClient = [AFClient shareClient];
    [afClient GET:self.homeUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.hud hide:YES];
        [self.hud removeFromSuperview];
        self.hud = nil;

        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *array = dic1[@"docs"];
        for (NSDictionary *dic in array) {
            Model *model = [[Model alloc]initWithDictionary:dic];
            [self.allMVModels addObject:model];
        }
        
        [self.homeTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"*****************%@" , error);
    }];
    
}


#pragma - mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allMVModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellindeifier = @"homeCell";
    
    HomeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellindeifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindeifier];

    }
    
    Model *model = self.allMVModels[indexPath.row];
    
    
    
    [cell.homeImageVie sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"home"]];
    cell.homeImageVie.layer.cornerRadius = 5;
    cell.homeImageVie.layer.masksToBounds = YES;
    
    cell.titleLabel.text = model.title;
    cell.artistLabel.text = model.artist;
    [cell.homeCellButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.homeCellButton.tag = 100 + indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayViewController *playVC = [[PlayViewController alloc]init];
    playVC.model = self.allMVModels[indexPath.row];
    
    
    [self presentViewController:playVC animated:YES completion:nil];
}

#pragma mark - 下载点击事件
// button点击事件
- (void)buttonAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    Model *model = self.allMVModels[index];
    BOOL isExit = NO;
    
    // 判断是否有下载地址
    if (model.url240 != nil) {
        
        // 有的话判断是否已经在下载列表是的话提示已经在下载列表，否则用SingleDownLoad进行下载
        // 取出Downloading里所有model
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *managedObjectContext = delegate.managedObjectContext;
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Downloading"];
        NSError *error = nil;
        NSArray *fetchArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchArray) {
            // 成功拿出数据后循环遍历数组，判断里面是否有当前传进来的MV

            for (Downloading *downloading in fetchArray) {
                if ([model.title isEqualToString:downloading.title]) {
                    // 如果存在的话isExit置为YES
                    isExit = YES;
                    break;
                }
            }
        }else{
            NSLog(@"********获取正在下载的MV信息失败%@" , error);
        }
        // 通过isExit判断当前传进来的MV是否已经在下载
        if (!isExit) {
            // 没有在下载
            // 用SingleDownLoad进行下载
            // 寻找沙盒路径，判断文件是否已经存在
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
            // 获取文件路径
            // 先拿到要下载的文件
            NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
            NSLog(@"%@" , cache);
            // 拼接保存路径
            NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4" , model.title]];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                //路径下没有该文件
                // 将可以下载的MV添加到coreData的Downloading里，用于下载界面的展示
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                Downloading *downloadingModel = [NSEntityDescription insertNewObjectForEntityForName:@"Downloading" inManagedObjectContext:appDelegate.managedObjectContext];
                downloadingModel.title = model.title;
                downloadingModel.artist = model.artist;
                downloadingModel.thumbnail = model.thumbnail;
                downloadingModel.url240 = model.url240;
                [appDelegate saveContext];
                
                // 将
                [[SingleDownLoad shareSingleDownload].modelArray addObject:downloadingModel];
                // 开始下载
                [[SingleDownLoad shareSingleDownload] downloadWithModel:downloadingModel];
            }else{
                // 有该文件说明已经下载完毕
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@已经下载完毕" , model.title] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            

        }else{
            // 已经在下载列表，提示视频正在下载
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该视频已经在下载列表" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    }else{
        // 没有下载地址的话提示：视频无法下载
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该视频暂时无法下载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    NSLog(@"%ld" , index);
}
//#pragma - mark 隐藏状态栏
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
