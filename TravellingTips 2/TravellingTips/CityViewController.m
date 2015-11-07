//
//  CityViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/4.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "CityViewController.h"
#import "CityCodeModel.h"

@interface CityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *UPArr;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray *hotModelArr;
@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addTitleViewWithTitle:@"选择城市"];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.nightTintColor = [UIColor darkGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.nightBackgroundColor = [UIColor darkGrayColor];
    self.view.nightBackgroundColor = [UIColor darkGrayColor];
    [self cityCode];
    
}

-(void)cityCode{
    self.arr = [[NSMutableArray alloc]init];
    self.modelArr = [[NSMutableArray alloc]init];
    self.hotModelArr = [[NSMutableArray alloc]init];
    NSString *path =[LZXHelper getFullPathWithFile:kPosition];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    BOOL isTimeout = [LZXHelper isTimeOutWithFile:kPosition timeOut:24*60*60];
    if ((isExist == YES)&&(isTimeout == NO) ) {
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:kPosition]];
        [self.dataArr removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDict=dict[@"data"];
        NSArray *array =dataDict[@"positionCity"];
        NSArray *hotArray = dataDict[@"hotCity"];
        for (NSDictionary *Dict in array) {
            CityCodeModel *model = [[CityCodeModel alloc]init];
            [model setValuesForKeysWithDictionary:Dict];
            if (model.pinYinName.length != 0) {
                [self.arr addObject:[model.pinYinName substringToIndex:1]];
                
            }
            
            [self.modelArr addObject:model];
            
        }
        
        for (NSDictionary *Dict in hotArray) {
            CityCodeModel *model = [[CityCodeModel alloc]init];
            [model setValuesForKeysWithDictionary:Dict];
            [self.hotModelArr addObject:model];
        }
        
   
    [self getSectionArray];
    [self.tableView reloadData];
    
    
        [MMProgressHUD dismissWithSuccess:@"成功" title:@"本地数据下载完成"];
        
        return;
    }
   //下面走网络路径
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:kPosition parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [self.dataArr removeAllObjects];
            NSData *data = (NSData *)responseObject;
            [data writeToFile:[LZXHelper getFullPathWithFile:kPosition] atomically:YES];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict=dict[@"data"];
            NSArray *array =dataDict[@"positionCity"];
            NSArray *hotArray = dataDict[@"hotCity"];
            for (NSDictionary *Dict in array) {
                CityCodeModel *model = [[CityCodeModel alloc]init];
                [model setValuesForKeysWithDictionary:Dict];
                if (model.pinYinName.length != 0) {
                    [self.arr addObject:[model.pinYinName substringToIndex:1]];
                  
                }
                
                [self.modelArr addObject:model];

            }
       
            for (NSDictionary *Dict in hotArray) {
                CityCodeModel *model = [[CityCodeModel alloc]init];
                [model setValuesForKeysWithDictionary:Dict];
                [self.hotModelArr addObject:model];
            }
            
        }
        [self getSectionArray];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)getSectionArray{
    self.UPArr = [[NSMutableArray alloc]init];
    for (NSString *str in self.arr) {
        [self.UPArr addObject:[str uppercaseString]];
    }

    _dict = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    for (NSInteger i =0;i< self.UPArr.count-1; i++) {
        
        [array1 addObject:self.modelArr[i]];
        
        for (NSInteger j = i+1; j<self.UPArr.count; j++) {
            if ([self.UPArr[j] isEqualToString:self.UPArr[i]]  ) {
                [array1 addObject:self.modelArr[j]];
                [self.UPArr removeObjectAtIndex:j];
                
                [self.modelArr removeObjectAtIndex:j];
                j--;
                
            }
        }
        NSArray *Arr = [[NSArray alloc]initWithArray:array1];
        [_dict setValue:Arr forKey:self.UPArr[i]];
        [array1 removeAllObjects];
        
    }
 
    [self initUI];
}
-(void)initUI{
    [self getCityData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.nightBackgroundColor = [UIColor darkGrayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
#pragma mark - 获取城市数据
-(void)getCityData

{

    [self.UPArr removeAllObjects];
    [self.UPArr addObjectsFromArray:[[self.dict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    //添加热门城市
    NSString *strHot = @"热";
    [self.UPArr insertObject:strHot atIndex:0];
    [self.dict setObject:self.hotModelArr forKey:strHot];
   
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    bgView.nightBackgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key =self.UPArr[section];
    if ([key rangeOfString:@"热"].location != NSNotFound) {
        titleLabel.text = @"热门城市";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.nightTextColor = [UIColor whiteColor];
    
    }
    else{
        titleLabel.text = key;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.nightTextColor = [UIColor whiteColor];
    }
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.UPArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.UPArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *key =self.UPArr[section];
    NSArray *citySection = _dict[key];
    return citySection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DKNightVersionManager addClassToSet:[UITableViewCell class]];

    static NSString *CellIdentifier = @"Cell";
    
    NSString *key =self.UPArr[indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    NSArray *title = _dict[key];
    CityCodeModel *model = title[indexPath.row];
    cell.textLabel.text = model.cityNameAbbr;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.nightTextColor = [UIColor whiteColor];
    cell.nightBackgroundColor = [UIColor darkGrayColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = self.UPArr[indexPath.section];
    NSArray *title = _dict[key];
  
    CityCodeModel *model = title[indexPath.row];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:model.cityCode forKey:@"cityCode"];
    [userDefaults setObject:model.cityNameAbbr forKey:@"cityNameAbbr"];
    if (_myBlock) {
        _myBlock(model.cityCode,model.cityNameAbbr);
    }
    [self.navigationController popViewControllerAnimated:YES];


}
-(void)setMyBlock:(CodeBlock)myBlock{
    if (_myBlock != myBlock) {
        _myBlock = [myBlock copy];
    }
}



@end