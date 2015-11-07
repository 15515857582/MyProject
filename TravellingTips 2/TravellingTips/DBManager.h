//
//  DBManager.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/25.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DBManager : NSObject
+(DBManager *)sharedManager;
-(void)insertModel:(id)model;
-(void)deleteModel;
-(NSArray *)readModel;
-(BOOL)isExistWithProductName:(NSString *)productName;
@end
