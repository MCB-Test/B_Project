//
//  DownloadedCell.m
//  B_Project
//
//  Created by lanouhn on 15/7/31.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "DownloadedCell.h"

@implementation DownloadedCell

- (UIImageView *)thumbnail
{
    if (!_thumbnail) {
        self.thumbnail = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_thumbnail];
        self.thumbnail.backgroundColor = [UIColor redColor];
    }
    return _thumbnail;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc]init];
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - 40, self.contentView.bounds.size.width, 40)];
        toolBar.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:toolBar];
        self.titleLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width - 40, 40);
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [toolBar addSubview:_titleLabel];
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.button.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5, CGRectGetMinY(self.titleLabel.frame) + 5, 30, 30);
        [self.button setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        [toolBar addSubview:self.button];
    }
    return _titleLabel;
}


@end
