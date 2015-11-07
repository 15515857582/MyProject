//
//  DiscoverDetailViewController.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/7.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "AroundViewController.h"

@interface DiscoverDetailViewController : AroundViewController
@property(nonatomic,copy)NSString *myTitle;
@property(nonatomic,copy)NSString *mySubtitle;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *districtName;

@property(nonatomic,copy)NSString *themeId;
@property(nonatomic,copy)NSString *cityCode;
@end
