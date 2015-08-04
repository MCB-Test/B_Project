//
//  Model.h
//  B_Project
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic , copy) NSString *video_id;
@property (nonatomic , copy) NSString *song_id_encode;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *artist;
@property (nonatomic , copy) NSString *thumbnail;
@property (nonatomic , copy) NSString *duration;
@property (nonatomic , retain) NSDictionary *source;

@property (nonatomic , copy) NSString *url240;
@property (nonatomic , copy) NSString *url360;
@property (nonatomic , copy) NSString *url480;
@property (nonatomic , copy) NSString *url720;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
