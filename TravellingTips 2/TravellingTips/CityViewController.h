//
//  CityViewController.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/4.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "TableViewController.h"
typedef void(^CodeBlock)(NSString *Code,NSString *city);
@interface CityViewController : TableViewController
@property(nonatomic,copy)CodeBlock myBlock;
-(void)setMyBlock:(CodeBlock)myBlock;
@end
