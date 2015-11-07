//
//  SearchViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/6.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "SearchViewController.h"
#import "appModel.h"
#import "SearchCell.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showWithTitle:@"欢迎使用" status:@"加载中..."];
    [self addTitleView];
    [self   firstDownload];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
    [self creatRefresh];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    SearchViewController *controller =[[SearchViewController alloc]init];
    controller.keyword = searchBar.text;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}
-(void)creatRefresh{
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        NSString *url =[NSString stringWithFormat:kSearch,weakSelf.keyword,weakSelf.myCity];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [weakSelf addTaskWithUrl:url Refresh:YES];
    }];
}
-(void)endRefreshing{
    if (self.isRefreshing) {
    self.isRefreshing = NO;
    [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];

}
}
-(void)firstDownload{
    NSString *url =[NSString stringWithFormat:kSearch,self.keyword,self.city];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self addTaskWithUrl:url Refresh:NO];

}
-(void)addTaskWithUrl:(NSString *)url Refresh:(BOOL)isRefresh{

    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            self.dataArr = [[NSMutableArray alloc]init];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSArray *itemsArr = dataDict[@"rows"];
            for (NSDictionary *cDict in itemsArr) {
                appModel *model =[[appModel alloc]init];
                [model setValuesForKeysWithDictionary:cDict];
                [self.dataArr addObject:model];
            }
            if (self.dataArr == nil) {
                [UIAlertView showFailureNO];
            }else{
                [self.tableView reloadData];}
            [MMProgressHUD dismissWithSuccess:@"Done" title:@"下载完成"];
            [self endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"Failure" title:@"网络不给力"];
    }];
    
}
#pragma mark - <UITableViewDataSource,UITableViewDelegate>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    appModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
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
