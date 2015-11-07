//
//  UIAlertView+util.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (util)
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showFailure;
+ (void)showFailureUnabled;
+ (void)showFailureNO;
@end
