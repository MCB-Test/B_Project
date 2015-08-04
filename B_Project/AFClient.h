//
//  AFClient.h
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFClient : AFHTTPRequestOperationManager
+ (AFClient *)shareClient;
@end
