//
//  DownLoadController.h
//  B_Project
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DownLoadController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *doladTableView;

@property (nonatomic , strong) NSMutableArray *downloadingArray;


@end
