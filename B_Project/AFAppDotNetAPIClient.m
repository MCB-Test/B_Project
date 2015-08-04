//
//  AFAppDotNetAPIClient.m
//  B_Project
//
//  Created by lanouhn on 15/7/29.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"
static NSString *const AFAppDotNetAPIBaseURLAtring = @"https://api.app.net/";

@implementation AFAppDotNetAPIClient

+(instancetype)shareClientWithView:(UIView *)view
{
    static AFAppDotNetAPIClient *_shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[AFAppDotNetAPIClient alloc]initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLAtring]];
        _shareClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        NSOperationQueue *queue = _shareClient.operationQueue;
        [_shareClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    MBProgressHUD *hud = [[MBProgressHUD alloc]init];
                    [view addSubview:hud];
                    hud.mode = MBProgressHUDModeIndeterminate;
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1.25);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                    }];
                    [queue setSuspended:NO];
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    
                    break;
                    
                default:
                {
                    [queue setSuspended:YES];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"网络不给力，请检查网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                    break;
            }
        }];
        [_shareClient.reachabilityManager startMonitoring];
    });
    return _shareClient;
}

@end
