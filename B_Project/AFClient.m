//
//  AFClient.m
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "AFClient.h"

@implementation AFClient
+(AFClient *)shareClient
{
    static AFClient *afClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        afClient = [AFClient manager];
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript", @"application/x-javascript", @"text/plain",@"application/json", nil];
        afClient.responseSerializer = responseSerializer;
    });
    return afClient;
}
@end
