//
//  Model.m
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "Model.h"

#define kHeadImage @"http://image.mp3.zdn.vn/"

@implementation Model

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (![dic isKindOfClass:[NSNull class]]) {
            self.title = dic[@"title"];
            self.artist = dic[@"artist"];
            NSString *str = kHeadImage;
            self.thumbnail = [str stringByAppendingFormat:@"%@" , dic[@"thumbnail"]];
            self.source = dic[@"source"];
            NSArray *arr = [self.source allKeys];
            // 将地址置空
            self.url240 = nil;
            self.url360 = nil;
            self.url480 = nil;
            self.url720 = nil;
            // 给存在的i赋值
            for (int i = 0; i < arr.count; i++) {
                if ([arr[i] isEqualToString:@"240"]) {
                    self.url240 = [self.source objectForKey:arr[i]];
                }else if ([arr[i] isEqualToString:@"360"]){
                    self.url360 = [self.source objectForKey:arr[i]];
                }else if ([arr[i] isEqualToString:@"480"]){
                    self.url480 = [self.source objectForKey:arr[i]];
                }else if ([arr[i] isEqualToString:@"720"]){
                    self.url720 = [self.source objectForKey:arr[i]];
                }
            }
            
        }
    }
    return self;
}
- (NSDictionary *)source
{
    if (!_source) {
        self.source = [NSDictionary dictionary];
    }
    return _source;
}

@end
