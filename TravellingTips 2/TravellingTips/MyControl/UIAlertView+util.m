//
//  UIAlertView+util.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "UIAlertView+util.h"

@implementation UIAlertView (util)
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
    [alertView show];
  
    
}
+ (void)showFailure {
    [self showAlertWithTitle:@"定位失败" message:@"请手动选择城市"];
}
+(void)showFailureUnabled{

    [self showAlertWithTitle:@"定位未打开" message:@"请开启定位"];
}
+(void)showFailureNO{

[self showAlertWithTitle:@"暂无数据" message:@"看看其他城市"];

}
@end
