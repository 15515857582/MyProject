//
//  DiscoverDetailViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/7.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "DiscoverDetailViewController.h"
#import "appModel.h"
#import "HeaderView.h"
#import "JHRefresh.h"
@interface DiscoverDetailViewController ()

@end

@implementation DiscoverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
//    [MMProgressHUD showWithTitle:@"欢迎使用" status:@"下载中"];
    [self addTitleViewWithTitle:self.myTitle];
    [self firstDownload];
    [self addHeaderView];
    [self creatRefresh];
   
}
-(void)creatRefresh{
  
};
-(void)endRefreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
    }

}
-(void)addHeaderView{

    HeaderView *view = [[HeaderView alloc]init];
    view.frame = CGRectMake(0, 0, kScreenSize.width, 260);
    
    view.subtitle = self.mySubtitle;
    view.imageUrl = self.imageUrl;
  
    view.districtName = self.districtName;
    [view createView];
    self.tableView.tableHeaderView = view;
    

}
-(void)firstDownload{
   
    self.currentPage = 1;
    NSString *url = [NSString stringWithFormat:kDisDetail,self.currentPage,self.themeId,self.cityCode];
    [self addTaskWithUrl:url Refresh:NO];
}

-(void)addTaskWithUrl:(NSString *)url Refresh:(BOOL)isRefresh{
    self.dataArr = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[ AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
          
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *cDict = dict[@"content"];
        NSArray *productList = cDict[@"productList"];
        for (NSDictionary *oDict in productList) {
            appModel *model = [[appModel alloc]init];
            [model setValuesForKeysWithDictionary:oDict];
            [self.dataArr addObject:model];
        }
    }
        
     [self.tableView reloadData];
   
//        [MMProgressHUD dismissWithSuccess:@"完成"];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
//        [MMProgressHUD dismissWithError:@"网络不给力"];
    }];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
        DetailViewController *controller = [[DetailViewController alloc]init];
        appModel *model = self.dataArr[indexPath.row];
        controller.myTitle = model.productName;
        controller.productId = model.productId;
    [[DBManager sharedManager]insertModel:model];
        [self presentViewController:controller animated:NO completion:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    CATransition *animation = [CATransition animation];
    animation.type = @"pageCurl";
    animation.duration = 0.5;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];


}
@end
