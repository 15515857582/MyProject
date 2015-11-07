//
//  appModel.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/4.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface appModel : NSObject
@property(nonatomic,copy)NSString *productId;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *productTitle;
@property(nonatomic,copy)NSString *mImageUrl;
@property(nonatomic,copy)NSString *homeImageUrl;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *retailPrice;
@property(nonatomic,copy)NSString *channelLinkId;
@property(nonatomic,copy)NSString *adress;
@property(nonatomic,copy)NSString *productTitleContent;
@property(nonatomic,copy)NSString *saledCount;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *coordinate;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subTitle;
@property(nonatomic,copy)NSString *districtName;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *themeId;
@property(nonatomic,copy)NSString *abstract;
@property(nonatomic,copy)NSString *app_picpath;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
/*
 "title": "巽寮湾精选餐厅",
 "subTitle": "海鲜大餐低至7折，免预约！",
 "description": "逛最美海岸，吃饕餮海鲜。巽寮湾精选餐厅将为您带来一场极度刺激味蕾的盛宴。不再犹豫，寻悠悠假日，带上好心情，美食美景尽在眼前。",
 "districtName": "广东",
 "imageUrl": "http://cdn6.yaochufa.com/uploads/201504/553df59175808.jpg",
 
 
 
 
"productId": 15354,
"productName": "方特欢乐世界刺激奇幻游",
"productDescription": "",
"productTitle": "方特世界以科幻和互动体验为特色，将动漫卡通、电影特技等时尚娱乐元素与中国传统文化符号精妙融合，创造出充满幻想和创意的神奇天地，被誉为“东方梦幻乐园”、“亚洲科幻神奇”。",
"productTitleContent": "方特欢乐世界一日游，含门票+往返接送+导游+责任险",
"mImageUrl": "images/AppList320/hl_15354_od_1_8007157992b045c5bd3018e270f7cd4e.jpg-scover3",
"url600x360": "images/AppList320/hl_15354_od_1_8007157992b045c5bd3018e270f7cd4e.jpg",
"url": "images/AppList320/hl_15354_od_1_8007157992b045c5bd3018e270f7cd4e.jpg",
"retailPrice": 248,
"price": 198,
"originalPrice": 248,
"isNew": false,
"flag": "",
"saledCount": 44,
"provinceName": "河南",
"cityName": "郑州市",
"scenicList": null,
"adress": "河南省郑州市郑州新区郑开大道与华强路交汇处",
"coordinate": "113.936032,34.768106",
"distance": 12185.937875051,
"goodRate": "5.000",
"channelLinkId": 69164,
"type": 0,
"mUrl": null,
"tags": [],
"viewCount": 0
*/