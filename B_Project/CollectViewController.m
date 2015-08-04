//
//  CollectViewController.m
//  B_Project
//
//  Created by lanouhn on 15/7/31.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "CollectViewController.h"
#import "ColectCell.h"
#import "MovieViewController.h"

@interface CollectViewController ()<UITableViewDataSource , UITableViewDelegate , UIAlertViewDelegate>

@property (nonatomic , strong) NSMutableArray *collectArray;

@property (nonatomic , strong) CollectModel *collectModel;

@end

@implementation CollectViewController

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CollectModel"];
    NSError *error = nil;
    NSArray *fetchArray = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchArray) {
        self.collectArray = [fetchArray mutableCopy];
    }else{
        NSLog(@"收藏信息内容抓取失败%@" , error);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的收藏";
    UIBarButtonItem *rightBarbuttonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除全部收藏" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllAction:)];
    self.navigationItem.rightBarButtonItem = rightBarbuttonItem;
    
    self.collectTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.collectTableView.dataSource = self;
    self.collectTableView.delegate = self;
    
    self.collectTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.collectTableView];
}

- (NSMutableArray *)collectArray
{
    if (!_collectArray) {
        self.collectArray = [NSMutableArray array];
    }
    return _collectArray;
}

#pragma mark - TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectCell = @"CollectCell";
    ColectCell *cell = [tableView dequeueReusableCellWithIdentifier:collectCell];
    
    if (nil == cell) {
        cell = [[ColectCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:collectCell];
    }
    
    CollectModel *model = self.collectArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.artistLabel.text = model.artist;
    [cell.collectImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"home"]];
    cell.collectImageView.layer.cornerRadius = 5;
    cell.collectImageView.layer.masksToBounds = YES;
    
    [cell.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = 100 + indexPath.row;

    
    return cell;
}

#pragma mark - 删除点击事件
// button点击事件
- (void)buttonAction:(UIButton *)sender
{
    NSLog(@"点击了删除");
    
    NSInteger index = sender.tag - 100;
    CollectModel *collectModel = self.collectArray[index];
    self.collectModel = collectModel;
    NSString *str = [NSString stringWithFormat:@"您确定要删除%@" , collectModel.title];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 101;
    [alert show];

}

#pragma mark - 删除所有
- (void)deleteAllAction:sender
{
    NSString *str = [NSString stringWithFormat:@"您确定要删除全部歌曲"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 100;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        
        if (buttonIndex == 0) {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate.managedObjectContext deleteObject:self.collectModel];
            [delegate saveContext];
            
            [self.collectArray removeObject:self.collectModel];
            [self.collectTableView reloadData];

            
        }else{
            ;
        }
    }else if (alertView.tag == 100){
        if (buttonIndex == 0) {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            for (int i = 0; i < self.collectArray.count; i++) {
                CollectModel *model = self.collectArray[i];
                [delegate.managedObjectContext deleteObject:model];
                [delegate saveContext];
            }
            
            [self.collectArray removeAllObjects];
            
            [self.collectTableView reloadData];
            
        }else{
            ;
        }
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//#warning 收藏界面点击cell没有播放功能*&^*&^*&^&)&*(^&*(
    MovieViewController *movieVC = [[MovieViewController alloc]init];
    CollectModel *model = [self.collectArray objectAtIndex:indexPath.row];
    movieVC.model = model;
    
#pragma mark - 添加进入mv播放页面 动画 (打开摄像头效果)
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = @"cameraIrisHollowOpen";
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:movieVC animated:YES];
    
    
    
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
