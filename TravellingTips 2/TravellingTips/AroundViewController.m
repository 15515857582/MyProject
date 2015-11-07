//
//  AroundViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "AroundViewController.h"
#import "AppCell.h"
#import "appModel.h"
#import "CityViewController.h"

@interface AroundViewController ()

@end

@implementation AroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
//    [MMProgressHUD showWithTitle:@"欢迎使用" status:@"加载中..."];
    [self addTitleViewWithTitle:@"周边新品"];
    [self initUI];
    [self creatRefresh];
    [self firstDownload];
}

-(void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.nightBackgroundColor = [UIColor darkGrayColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"AppCell" bundle:nil] forCellReuseIdentifier:@"AppCell"];
    [self.view addSubview:self.tableView];
    self.dataArr = [[NSMutableArray alloc]init];
    [self firstDownload];
}
-(void)creatRefresh{
    
    __weak typeof (self) weakSelf =self;

[self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
    if (weakSelf.isRefreshing) {
        return ;
    }
    weakSelf.isRefreshing = YES;
    weakSelf.currentPage = 1;
    NSString *url = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ccity = [userDefaults objectForKey:@"city"];
    NSString *cityNameAbbr = [userDefaults objectForKey:@"cityNameAbbr"];
    if (cityNameAbbr == nil) {
        
        if (ccity.length == 0) {
            ccity=@"北京";
            url = [NSString stringWithFormat:kAround,self.currentPage,self.longitude,self.latitude,ccity];
        }else{
            url = [NSString stringWithFormat:kAround,self.currentPage,self.longitude,self.latitude,[ccity substringToIndex:ccity.length-1]];
        }
    }else{
        
        url = [NSString stringWithFormat:kCityAround,self.currentPage,cityNameAbbr];
    }

    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [weakSelf addTaskWithUrl:url Refresh:YES];
    
}];


[self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
    if (weakSelf.isLoadMore) {
        return ;
    }
    weakSelf.isLoadMore = YES;
    weakSelf.currentPage ++;
    NSString *url = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ccity = [userDefaults objectForKey:@"city"];
    NSString *cityNameAbbr = [userDefaults objectForKey:@"cityNameAbbr"];
    if (cityNameAbbr == nil) {
        
        if (ccity.length == 0) {
            ccity=@"北京";
            url = [NSString stringWithFormat:kAround,self.currentPage,self.longitude,self.latitude,ccity];
        }else{
            url = [NSString stringWithFormat:kAround,self.currentPage,self.longitude,self.latitude,[ccity substringToIndex:ccity.length-1]];
        }
    }else{
        
        url = [NSString stringWithFormat:kCityAround,self.currentPage,cityNameAbbr];
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [weakSelf addTaskWithUrl:url Refresh:YES];
}];

}
-(void)endRefreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }


}
-(void)firstDownload{
    self.currentPage = 1;
    NSString *url = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ccity = [userDefaults objectForKey:@"city"];
    NSString *cityNameAbbr = [userDefaults objectForKey:@"cityNameAbbr"];
    if (cityNameAbbr == nil) {
        
    if (ccity.length == 0) {
        ccity=@"北京";
        url = [NSString stringWithFormat:kAround,self.currentPage,self.longitude,self.latitude,ccity];
    }else{
        url = [NSString stringWithFormat:kAround,self.currentPage,self.longitude,self.latitude,[ccity substringToIndex:ccity.length-1]];
    }
    }else{
    
        url = [NSString stringWithFormat:kCityAround,self.currentPage,cityNameAbbr];
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self addTaskWithUrl:url Refresh:NO];

}
-(void)addTaskWithUrl:(NSString *)url Refresh:(BOOL)isRefresh{
   
    NSString *path =[LZXHelper getFullPathWithFile:url];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
   
    BOOL isTimeout = [LZXHelper isTimeOutWithFile:url timeOut:24*60*60];
    if ((isRefresh == NO)&&(isExist == YES)&&(isTimeout == NO) ) {
        if (self.currentPage == 1) {
            [self.dataArr removeAllObjects];
        }
       
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        [self.dataArr removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDict = dict[@"data"];
        NSArray *itemsArr = dataDict[@"items"];
        for (NSDictionary *cDict in itemsArr) {
            appModel *model =[[appModel alloc]init];
            [model setValuesForKeysWithDictionary:cDict];
            [self.dataArr addObject:model];
        }
        if (self.dataArr.count == 0) {
            [UIAlertView showFailureNO];
        }else{
        [self.tableView  reloadData];
        }
  
        [MMProgressHUD dismissWithSuccess:@"完成"];
        
        return;
    }

    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
  
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.currentPage == 1) {
                [self.dataArr removeAllObjects];
            
        NSData *data = (NSData *)responseObject;
       [data writeToFile:[LZXHelper getFullPathWithFile:url] atomically:YES];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSArray *itemsArr = dataDict[@"items"];
            for (NSDictionary *cDict in itemsArr) {
                appModel *model =[[appModel alloc]init];
                [model setValuesForKeysWithDictionary:cDict];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
            [MMProgressHUD dismissWithSuccess:@"完成" title:@"下载完成"];
            [self endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"失败" title:@"网络不给力"];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityNameAbbr = [userDefaults objectForKey:@"cityNameAbbr"];
    if (cityNameAbbr == nil) {
        return;
    }else{
    
        [self creatRefresh];
    }


}
#pragma mark - <UITableViewDataSource,UITableViewDelegate>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell" forIndexPath:indexPath];
    if (self.dataArr.count == 0) {
        
    }else{
    appModel *model = self.dataArr[indexPath.row];
        [cell showDataWithModel:model];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *controller = [[DetailViewController alloc]init];
    appModel *model = self.dataArr[indexPath.row];
    controller.myTitle = model.productName;
    controller.productId = model.productId;
    [[DBManager sharedManager]insertModel:model];
    [self presentViewController:controller animated:NO completion:nil];
    
    
}
@end
