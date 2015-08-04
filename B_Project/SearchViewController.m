//
//  SearchViewController.m
//  B_Project
//
//  Created by lanouhn on 15/7/29.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "SearchViewController.h"
#import "Model.h"
#import "HomeCell.h"
#import "PlayViewController.h"

#define kUrl1 @"http://api.mp3.zing.vn/api/mobile/search/video?keycode=fafd463e2131914934b73310aa34a23f&fromvn=1&requestdata=%7B%22start%22%3A0%2C%22q%22%3A%22"
#define kUrl2 @"%22%2C%22length%22%3A100%7D"

@interface SearchViewController ()<UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate , UIAlertViewDelegate>

@property (nonatomic , strong) NSMutableArray *allSearchMVModel;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.search becomeFirstResponder];
}

// 懒加载model数组
- (NSMutableArray *)allSearchMVModel
{
    if (!_allSearchMVModel) {
        self.allSearchMVModel = [NSMutableArray array];
    }
    return _allSearchMVModel;
}
#pragma mark 返回按钮点击事件
// 返回按钮
- (IBAction)buttonAction:(id)sender {
    [self.search resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.search.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.search.showsCancelButton = NO;
    [self.search resignFirstResponder];
}
#pragma mark 搜索请求
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.url = [kUrl1 stringByAppendingString:[NSString stringWithFormat:@"%@" , searchBar.text]];
    self.url = [self.url stringByAppendingString:kUrl2];
//    NSLog(@"%@" , self.url);
    [self getData];
    [self.search resignFirstResponder];
    self.hud = [[MBProgressHUD alloc]init];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(action) userInfo:nil repeats:NO];
    
}
- (void)action
{
    if (self.hud != nil) {
        [self.hud removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力，请重新加载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark 请求数据
- (void)getData
{
   
    AFClient *afClient = [AFClient shareClient];
    [afClient GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.hud hide:YES];
        [self.hud removeFromSuperview];
        self.hud = nil;
        
            // 请求到的数据不为空，继续解析
            // 清空数组里原有内容
            if (self.allSearchMVModel.count != 0) {
                [self.allSearchMVModel removeAllObjects];
            }
            
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSArray *arr = dic1[@"docs"];
        if (arr.count == 0) {
            // 如果请求到的数据为空提示
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"搜索内容为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }else{
            
            for (NSDictionary *dic in arr) {
                Model *model = [[Model alloc]initWithDictionary:dic];
                [self.allSearchMVModel addObject:model];
            }
            [self.tableView reloadData];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"***************%@" , error);
    }];
}

#pragma mark TableViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allSearchMVModel.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    Model *model = self.allSearchMVModel[indexPath.row];
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
    playVC.model = self.allSearchMVModel[indexPath.row];
    
    if (indexPath.row % 2 == 0) {
        playVC.urlStr = @"http://k.youku.com/player/getFlvPath/sid/1438153066542512cb144_01/st/mp4/fileid/030020010055B61D7763C007383F557B2B84A8-2970-C375-3DBF-2FB4675574D7?K=a0ba5a7bc5bb65c0282aab78&hd=0&ymovie=1&ts=2005&ctype=51&token=5914&ev=1&oip=2021929295&ep=1PJ5k4EKMnBGi5AJKQ6QI80YEkm84IrsRvVG9Y8PHv%2Fnyn7C1OTSF44gSQ082GIlCjvTzMbTS2UP%2FmUSJJccrsevYu1J3ZdrVP%2BL1TLn9wfLAEV%2FBV5ovbyWcYuHwhBi";
    }else{
        playVC.urlStr = @"http://k.youku.com/player/getFlvPath/sid/443815382996151ebb29a_01/st/mp4/fileid/0300200100557AF25B3B4507383F5529E47F20-EBA1-5FF9-D77E-02F6127B525E?K=1a1397f3b87aeb2b261e7a7b&hd=0&ymovie=1&ts=2544&ctype=51&token=8828&ev=1&oip=2021929295&ep=ozED2%2FQeG1Jwadz6zvYP1%2BkIWFCgpd2sRvVG9Y8PHv9AW8SCwp1hNYybZouAn6fjke2dWTLVD9KB0agFlWK5mfdxvz8ZRZ1TIXNmUA2AithKH2UUbxsBsCkVUCz1Uqrl";
    }
    [self presentViewController:playVC animated:YES completion:nil];
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
