//
//  DownloadCell.h
//  B_Project
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *downloadImageview;
@property (strong, nonatomic) IBOutlet UILabel *downloadName;
@property (strong, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (strong, nonatomic) IBOutlet UIButton *startAndStopButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;


@end
