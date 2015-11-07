//
//  Define.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#ifndef TravellingTips_Define_h
#define TravellingTips_Define_h
#define kScreenSize [UIScreen mainScreen].bounds.size

#import "MyControl.h"
#import "UIAlertView+util.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"
#import "DKNightVersion.h"
#import "DBManager.h"

#define  PATH @"http://api.map.baidu.com/geocoder?output=json&location=%f,%f&key=dc40f705157725fc98f1fee6a15b6e60"
#define kPosition @"http://appapi.yaochufa.com/v2/Position/GetCityList?machineCode=864975021658966&version=4.2.5&system=android&channel=baiduactivity"
#define kHome @"http://apiphp.yaochufa.com/playpoint/recommend?userId=&longitude=%f&latitude=%f&version=4.2.5&imei=864975021658966&system=android&deviceToken=864975021658966&channel=baiduactivity&city=%@"

#define kAround @"http://appapi.yaochufa.com/v2/Product/GetAroundProductList?pageIndex=%d&longitude=%f&latitude=%f&machineCode=864975021658966&pageSize=20&channel=baiduactivity&city=%@"
#define kCityAround @"http://appapi.yaochufa.com/v2/Product/GetAroundProductList?pageIndex=%d&machineCode=864975021658966&version=4.2.5&sort=n&province=1&system=android&pageSize=20&channel=baiduactivity&city=%@"
#define kDiscover @"http://apiphp.yaochufa.com/portal/theme/areaThemeList?pageIndex=1&version=4.2.5&imei=864975021658966&system=android&pageSize=20&deviceToken=864975021658966&cityCode=%@&channel=baiduactivity"
#define kSearch @"http://appapi.yaochufa.com/v2/Search/Search?machineCode=864975021658966&version=4.2.5&sort=1&keyWord=%@&minPrice=0&system=android&p=1&channel=baiduactivity&maxPrice=999999&city=%@&s=20"
#define kDetail @"http://appapi.yaochufa.com/v2/Product/GetProductInfoById?productId=%@&machineCode=864975021658966&version=4.2.5&system=android&channel=baiduactivity"
#define kDisDetail @"http://apiphp.yaochufa.com/portal/theme/themeinfo?pageIndex=%d&version=4.2.5&imei=864975021658966&id=%@&system=android&pageSize=20&cityCode=%@"
#define kAdlist @"http://apiphp.yaochufa.com/you/advertiselist/AdList?area_code=%@&version=4.2.5&imei=864975021658966&system=android&deviceToken=864975021658966&channel=baiduactivity"
#define __UpLine__ // 上线的时候打开
#ifndef __UpLine__
//变参宏
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif




#endif
