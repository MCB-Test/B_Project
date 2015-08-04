//
//  AFAppDotNetAPIClient.h
//  B_Project
//
//  Created by lanouhn on 15/7/29.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)shareClientWithView:(UIView *)view;

@end
