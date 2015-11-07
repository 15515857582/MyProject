//
//  HeaderView.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/7.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "HeaderView.h"
#import "NSString+util.h"
@implementation HeaderView

-(void)createView{
    CGRect frame = CGRectMake(0, 5, kScreenSize.width, 200);
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:frame];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 8;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"backImage"]];
    [self addSubview:imageView];
    frame.origin.y = CGRectGetMaxY(frame)+20;
    frame.size.height = 10;
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = self.subtitle;
    label.textColor = [UIColor blackColor];
    label.nightTextColor = [UIColor whiteColor];
    [self addSubview:label];
    frame.origin.y = CGRectGetMaxY(frame);
    frame.origin.x = frame.size.width - 60;
    frame.size.width = 13;
    frame.size.height = 17;
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:frame];
    imageView1.image = [UIImage imageNamed:@"288"];
    [self addSubview:imageView1];
    frame.origin.y = CGRectGetMaxY(frame)-18;
    frame.origin.x = CGRectGetMaxX(frame)+5;
    frame.size.width = 40;
    UILabel *label3 = [[UILabel alloc]initWithFrame:frame];
    label3.text = self.districtName;
    label3.nightTextColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:12];
    [self addSubview:label3];
   


}

@end
