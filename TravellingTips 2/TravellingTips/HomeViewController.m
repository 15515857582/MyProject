
//
//  HomeViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "HomeViewController.h"
#import "CityCodeModel.h"
#import "CityViewController.h"
#import "appModel.h"
#import "AppCell.h"
#import "SearchViewController.h"
#import "JHRefresh.h"
#import "HomeHeaderView.h"
#import "MMLinearProgressView.h"
#import <iflyMSC/iflyMSC.h>
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,IFlyRecognizerViewDelegate>
@property (nonatomic,strong)NSMutableArray *plistArr;
@property(nonatomic,strong)NSMutableArray *headerArr;
@property(nonatomic,copy)NSString *cityCodeStr;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)IFlyRecognizerView *iFlyRecognizerView;
@property (nonatomic,strong)HomeHeaderView *myView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
//    [MMProgressHUD showWithTitle:@"欢迎使用" status:@"加载中..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"cityCode"];
    [userDefaults removeObjectForKey:@"cityNameAbbr"];
    [userDefaults removeObjectForKey:@"cityCodeStr"];
    [userDefaults removeObjectForKey:@"city"];
    [self addTitleView];
    [self initLocationManager];
    [self cityCode];
    [self initUI];
    [self creatSpeechButton];
    [self creatRefreshView];
   
    
}
-(void)creatSpeechButton{

    
    UIButton *button = [MyControl creatButtonWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 19, 25) target:self sel:@selector(speechClick) tag:789 image:@"speech.png" selectImage:@"" title:@""];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{



}
-(void)creatRefreshView{

    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        NSString *url = [NSString stringWithFormat:kHome,weakSelf.longitude,weakSelf.latitude,weakSelf.cityCodeStr];
        [weakSelf addTaskWithURL:url Refresh:YES];
    }];
}
-(void)endRefreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
    }

}
-(void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.nightBackgroundColor = [UIColor darkGrayColor];
    self.tableView.nightSeparatorColor = [UIColor darkGrayColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"AppCell" bundle:nil] forCellReuseIdentifier:@"AppCell"];
        [self.view addSubview:self.tableView];
    self.dataArr = [[NSMutableArray alloc]init];
    self.headerArr = [[NSMutableArray alloc]init];

}
-(void)cityClick:(UIButton *)button{
    __weak typeof(self) weakSelf =self;
    CityViewController *city = [[CityViewController alloc]init];
    [city setMyBlock:^(NSString *Code,NSString *city) {
        [MMProgressHUD setProgressViewClass:[MMLinearProgressView class]];
        [MMProgressHUD showDeterminateProgressWithTitle:@"拼命加载中..." status:nil];
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        }
        weakSelf.cityCodeStr = Code;
        NSString *url = [NSString stringWithFormat:kHome,weakSelf.longitude,weakSelf.latitude,weakSelf.cityCodeStr];
        [weakSelf addBarButtonItemWithTitle:city target:self action:@selector(cityClick:) isLeft:YES];
        [weakSelf addTaskWithURL:url Refresh:YES];
        NSString *Url = [NSString stringWithFormat:kAdlist,weakSelf.cityCodeStr];
        [weakSelf downloadHeaderWithUrl:Url isRefresh:YES];
        [weakSelf creatRefreshView];
      
    }];
    
    city.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:city animated:YES];
   

}
-(void)updateTimer:(NSTimer *)timer{


    [MMProgressHUD updateProgress:0.4];

}
-(void)cityCode{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:kPosition parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            self.plistArr = [[NSMutableArray alloc]init];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict=dict[@"data"];
            NSArray *array =dataDict[@"positionCity"];
            for (NSDictionary *Dict in array) {
                CityCodeModel *model = [[CityCodeModel alloc]init];
                [model setValuesForKeysWithDictionary:Dict];
                NSDictionary *CityCodeDict = @{model.cityName:model.cityCode};
                [self.plistArr addObject:CityCodeDict];
            }
        }
        [self initData];
        [self creatUrl];
        [self creatHeaderUrl];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
-(void)initData{
    if (self.city) {

        [self addBarButtonItemWithTitle:self.city target:self action:@selector(cityClick:) isLeft:YES];
    }else{
        [self addBarButtonItemWithTitle:@"北京" target:self action:@selector(cityClick:) isLeft:YES];
    }
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in self.plistArr) {
        NSString *str = dict[self.city];
       
        if (str != NULL) {
          [array addObject:str];
        }
    }
    if (array.count != 0) {
        _cityCodeStr= array[0];

    }else{
    
    _cityCodeStr = @"110100";
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_cityCodeStr forKey:@"cityCodeStr"];
    [userDefaults setObject:self.city forKey:@"city"];
    [userDefaults synchronize];

}
-(void)creatHeaderUrl{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [userDefaults objectForKey:@"cityCode"];
    NSString *Url = nil;
    if (code == nil) {
        Url = [NSString stringWithFormat:kAdlist,self.cityCodeStr];
    }else{
        
        Url = [NSString stringWithFormat:kAdlist,code];
        
    }
    [self downloadHeaderWithUrl:Url isRefresh:NO];

}
-(void)downloadHeaderWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh{
 
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [self.headerArr removeAllObjects];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *contentDict = dict[@"content"][0];
            NSArray *adArr = contentDict[@"ad"];
            for (NSDictionary *adDict in adArr) {
                NSDictionary *ctDict = adDict[@"ct"];
                appModel *model =[[appModel alloc]init];
                [model setValuesForKeysWithDictionary:ctDict];
                [self.headerArr addObject:model.app_picpath];
            }
        }
        [self addHeaderView];
        [self endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)addHeaderView{

    _myView = [[HomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130)];
    _myView.arr = [NSArray arrayWithArray:self.headerArr];
    [_myView creatHeaderView];
    if (_myView.arr.count == 0) {
        self.tableView.tableHeaderView = nil;
    }else{
    self.tableView.tableHeaderView = _myView;
    }
}
-(void)creatUrl{
    NSString *url = [NSString stringWithFormat:kHome,self.longitude,self.latitude,self.cityCodeStr];
    [self addTaskWithURL:url Refresh:NO];

}
-(void)addTaskWithURL:(NSString *)url Refresh:(BOOL)isRefresh{
  
 
 
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [self.dataArr removeAllObjects];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *contentArr = dict[@"content"];
            for (NSDictionary *cDict in contentArr) {
                appModel *model =[[appModel alloc]init];
                [model setValuesForKeysWithDictionary:cDict];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count == 0) {
                [UIAlertView showFailureNO];
            }else{
                [self.tableView reloadData];}
            
            [MMProgressHUD dismissWithSuccess:@"完成" title:@"下载完成"];
            [self endRefreshing];
        }
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"失败" title:@"网络不给力"];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }];
    
}
-(void)speechClick{
    if (_iFlyRecognizerView == nil) {
        [self initRecognizer];
    }
    [_iFlyRecognizerView start];
}
-(void)initRecognizer{
    
    _iFlyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:self.view.center];
    _iFlyRecognizerView.delegate = self;
    
    
}
- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}
-(void)onR5t:(NSArray *)resultArray isLast:(BOOL)isLast{
    NSDictionary *dict = resultArray[0];
    NSString *resultKey = nil;
    for (NSString *key in dict) {
        resultKey = key;
    }
    NSString *str = [self stringFromJson:resultKey];
    if ([str isEqualToString:@"。"] == NO) {
         [self push:str];
    }
   
    
}
-(void)push:(NSString *)str{

    SearchViewController *controller = [[SearchViewController alloc]init];
    controller.keyword = str;
    [self searchControllerAppear:controller];
}
-(void)onError:(IFlySpeechError *)error{

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    SearchViewController *controller = [[SearchViewController alloc]init];
    controller.keyword = searchBar.text;
    [self searchControllerAppear:controller];
   
}
-(void)searchControllerAppear:(SearchViewController *)controller{
    NSUserDefaults *user = [[NSUserDefaults alloc]init];
    NSString *city =[user objectForKey:@"cityNameAbbr"];
    if (city == nil) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in self.plistArr) {
            NSString *str = dict[_cityCodeStr];
            
            if (str != NULL) {
                [array addObject:str];
            }
        }
        if (array.count != 0) {
            controller.myCity= array[0];
            
        }else{
            
            controller.myCity = @"郑州";
        }
    }else{
        
        controller.myCity=city;
        
    }
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];

}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_myView openTimer];
    });

}
-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController setToolbarHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    if (_myView.arr.count>1) {
        [_myView closeTimer];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [_myView closeTimer];
    
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{

    if (_myView.arr.count>1) {
        [_myView openTimer];
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
    controller.productTitle = model.productTitle;
    controller.coordinate = model.coordinate;
    [[DBManager sharedManager]insertModel:model];
    controller.hidesBottomBarWhenPushed = YES;
    [self presentViewController:controller animated:NO completion:nil];
//    [self.navigationController pushViewController:controller animated:YES];
}
@end
