//
//  CityCodeModel.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityCodeModel : NSObject
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *pinYinName;
@property(nonatomic,copy)NSString *cityNameAbbr;
@property(nonatomic,copy)NSString *url;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
/*
{
    "cityId": 137,
    "cityCode": "370300",
    "pinYinName": "ZiBo",
    "cityName": "淄博市",
    "cityNameAbbr": "淄博",
    "isHot": false
}
*/