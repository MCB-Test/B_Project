//
//  Downloaded.h
//  B_Project
//
//  Created by lanouhn on 15/8/3.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Downloaded : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * title;

@end
