//
//  HeaderView.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/7.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *districtName;

@property(nonatomic)NSInteger height;
-(void)createView;
@end
