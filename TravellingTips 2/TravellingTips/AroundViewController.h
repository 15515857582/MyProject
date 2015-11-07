//
//  AroundViewController.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "TableViewController.h"
#import "JHRefresh.h"
@interface AroundViewController : TableViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
-(void)firstDownload;
-(void)addTaskWithUrl:(NSString *)url Refresh:(BOOL)isRefresh;
-(void)creatRefresh;
-(void)endRefreshing;
@end
