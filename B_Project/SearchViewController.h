//
//  SearchViewController.h
//  B_Project
//
//  Created by lanouhn on 15/7/29.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UISearchBar *search;

@property (nonatomic , copy) NSString *url;

@property (nonatomic , strong) MBProgressHUD *hud;

@end
