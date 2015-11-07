//
//  DiscoverViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "DiscoverViewController.h"
#import "appModel.h"
#import "DiscoverCell.h"
#import "JHRefresh.h"
#import "DiscoverDetailViewController.h"
@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
//    [MMProgressHUD showWithTitle:@"欢迎使用" status:@"加载中..."];
    [self addTitleViewWithTitle:@"专题精品"];
    [self initUI];
    [self creatRefreshView];
    [self firstload];
}

-(void)initUI{

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.nightBackgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverCell" bundle:nil] forCellReuseIdentifier:@"DiscoverCell"];
    self.dataArr = [[NSMutableArray alloc]init];

}
-(void)creatRefreshView{
    __weak typeof (self) weakSelf =self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *cityCodeStr = [userDefaults objectForKey:@"cityCodeStr"];
        NSString *cityCode = [userDefaults objectForKey:@"cityCode"];
        NSString *url = nil;
        if (cityCode == nil) {
            url = [NSString stringWithFormat:kDiscover,cityCodeStr];
        }else {
            
            url = [NSString stringWithFormat:kDiscover,cityCode];
        }
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
}
-(void)endRefreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
}
-(void)firstload{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityCodeStr = [userDefaults objectForKey:@"cityCodeStr"];
    NSString *cityCode = [userDefaults objectForKey:@"cityCode"];
    NSString *url = nil;
    if (cityCode == nil) {
        url = [NSString stringWithFormat:kDiscover,cityCodeStr];
    }else {
        url = [NSString stringWithFormat:kDiscover,cityCode];
    }
    [self addTaskWithUrl:url isRefresh:NO];

}
-(void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh{

 
    NSString *path =[LZXHelper getFullPathWithFile:url];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    BOOL isTimeout = [LZXHelper isTimeOutWithFile:url timeOut:24*60*60];
    if ((isRefresh == NO)&&(isExist == YES)&&(isTimeout == NO) ) {
        
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        [self.dataArr removeAllObjects];
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
        NSDictionary *contentDict =dict[@"content"];
        NSArray *themeList = contentDict[@"themeList"];
        for (NSDictionary *objDict in themeList) {
            appModel *model = [[appModel alloc]init];
            [model setValuesForKeysWithDictionary:objDict];
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
        [MMProgressHUD dismissWithSuccess:@"完成"];
        return;
    }

    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [self.dataArr removeAllObjects];
            NSData *data = (NSData *)responseObject;
            [data writeToFile:[LZXHelper getFullPathWithFile:url] atomically:YES];
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil ];
            NSDictionary *contentDict =dict[@"content"];
            NSArray *themeList = contentDict[@"themeList"];
            for (NSDictionary *objDict in themeList) {
                appModel *model = [[appModel alloc]init];
                [model setValuesForKeysWithDictionary:objDict];
                [self.dataArr addObject:model];
            }
        }
        if (self.dataArr.count == 0) {
            [UIAlertView showFailureNO];
//            [MMProgressHUD dismissWithSuccess:@"Done" title:@"下载完成"];
        }else{
        [self.tableView reloadData];
//            [MMProgressHUD dismissWithSuccess:@"Done" title:@"下载完成"];
        }
        
        [self endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MMProgressHUD dismissWithError:@"Failure" title:@"网络不给力"];
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
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell" forIndexPath:indexPath];
    if (self.dataArr.count == 0) {
        
    }else{
    appModel *model =self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverDetailViewController *controller =[[ DiscoverDetailViewController alloc]init];
    appModel *model =self.dataArr[indexPath.row];
    controller.myTitle = model.title;
    controller.mySubtitle = model.subTitle;
    controller.imageUrl = model.imageUrl;
    controller.districtName = model.districtName;
    controller.themeId = model.themeId;
 
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityCodeStr = [userDefaults objectForKey:@"cityCodeStr"];
    NSString *cityCode = [userDefaults objectForKey:@"cityCode"];
    if (cityCode == nil) {
        controller.cityCode = cityCodeStr;
    }else{
        controller.cityCode =cityCode;
    }
    controller.hidesBottomBarWhenPushed = YES;
    CATransition *animation = [CATransition animation];
    animation.type = @"pageUnCurl";
    animation.duration = 1;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:controller animated:YES];

}
@end
