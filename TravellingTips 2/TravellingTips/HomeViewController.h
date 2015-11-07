//
//  HomeViewController.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "TableViewController.h"

@interface HomeViewController : TableViewController
@property(nonatomic,strong)UITableView *tableView;
-(void)addTaskWithURL:(NSString *)url Refresh:(BOOL)isRefresh;
-(void)creatUrl;
@end
