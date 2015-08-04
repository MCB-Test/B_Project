//
//  ViewController.h
//  B_Project
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *homeTableView;

@property (strong, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property (nonatomic , strong) UISegmentedControl *homeSegment;

@property (nonatomic , copy) NSString *homeUrl;

@property (nonatomic , strong) MBProgressHUD *hud;

@end

