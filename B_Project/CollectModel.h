//
//  CollectModel.h
//  B_Project
//
//  Created by lanouhn on 15/7/31.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CollectModel : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url240;
@property (nonatomic, retain) NSString * url360;
@property (nonatomic, retain) NSString * url480;
@property (nonatomic, retain) NSString * url720;

@end
