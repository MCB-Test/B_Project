//
//  AboutUsController.m
//  B_Project
//
//  Created by lanouhn on 15/8/4.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor colorWithRed:176.0 / 255.0 green:196.0 /255.0 blue:222.0 / 255.0 alpha:1];
    
    
    UIImageView *imageViewBackGround = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    imageViewBackGround.image = [UIImage imageNamed:@"BackGroundImage.png"];
    imageViewBackGround.image = [UIImage imageNamed:@"HomeBackImage.png"];
    [self.view addSubview:imageViewBackGround];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 60,self.view.frame.size.width , 30)];
    label1.text = @"B_Project介绍";
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    label1.backgroundColor = [UIColor clearColor];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20 , self.view.frame.size.height - 200)];
    label2.text = @"B_Project播放器是不分国家的MV播放器\n为你提供一个舒适的意境环境\n视为缓解压力，放松心情的首选\n\n\n\n版本号1.0\n小马工作室";
    label2.numberOfLines = 0;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 30, 40, 40);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:  UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [self.view addSubview:button];

    // Do any additional setup after loading the view.
}
- (void)buttonAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
