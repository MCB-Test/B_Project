//
//  MineController.h
//  B_Project
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DeleteBlock)(id model);

@interface MineController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) UILabel *label;

@property (nonatomic , copy) DeleteBlock deleteBlock;

@end
