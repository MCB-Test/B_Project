//
//  ColectCell.m
//  B_Project
//
//  Created by lanouhn on 15/7/31.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "ColectCell.h"

#define kInspace 5
#define kHeadImageViewWidth 40

#define kNameLabelWidth 200
#define kNameLabelHeight 25

#define kArtistLabelWidth 200
#define kArtistLabelHeight 15

@implementation ColectCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    // headImageView
    self.collectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kInspace, kInspace, kHeadImageViewWidth, kHeadImageViewWidth)];
    self.collectImageView.layer.cornerRadius = 5;
    self.collectImageView.layer.masksToBounds = YES;
    
    // name
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.collectImageView.frame.origin.x + kHeadImageViewWidth + kInspace, self.collectImageView.frame.origin.y, kNameLabelWidth, kNameLabelHeight)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    // artist
    self.artistLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x + kInspace, self.titleLabel.frame.origin.y + kNameLabelHeight, kArtistLabelWidth, kArtistLabelHeight)];
    self.artistLabel.font = [UIFont systemFontOfSize:10];
    
    // button
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(self.frame.size.width - 40, self.titleLabel.frame.origin.y + 2 * kInspace, kNameLabelHeight, kNameLabelHeight);
    self.button.backgroundColor = [UIColor clearColor];
    [self.button setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    self.button.adjustsImageWhenHighlighted = YES;
    
    [self.contentView addSubview:self.collectImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.artistLabel];
    [self.contentView addSubview:self.button];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
