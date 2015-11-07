//
//  TableViewController.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailViewController.h"
#import "LZXHelper.h"
@interface TableViewController :UIViewController<UISearchBarDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong)CLLocationManager *manager;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic,copy) NSString *city;
@property (nonatomic) int currentPage;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic)BOOL isRefreshing;
@property(nonatomic)BOOL isLoadMore;
-(void)addTitleViewWithTitle:(NSString *)title;
-(void)addTitleView;
-(void)addBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;
-(void)initLocationManager;

@end
