//
//  ScanViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/25.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "ScanViewController.h"
#import "appModel.h"
#import "DetailViewController.h"
#import "UIButton+WebCache.h"
#import "LZXHelper.h"
@interface ScanViewController ()
{
    NSMutableArray *_arr;
}
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showUI];
}

-(void)showUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.nightBackgroundColor = [UIColor darkGrayColor];
    NSArray *array = [[DBManager sharedManager]readModel];
    _arr = [[NSMutableArray alloc]init];
    for (appModel *appmodel in array) {
        [_arr addObject:appmodel];
    }
    UIScrollView *view = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.nightBackgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:view];
    //横向的间隔
    CGFloat wSpace = ([LZXHelper getScreenSize].width - 3*100)/4;
    
    //纵向的间隔
    CGFloat hSpace = ([LZXHelper getScreenSize].height-64-49 - 3*100)/4;
    for (int i = 0; i<_arr.count; i++) {
        //先获取model
        appModel *model = _arr[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 101+i;
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8;
        
        //从网络下载图片
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.yaochufa.com/%@",model.mImageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"detail_facilities_load_icon"]];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //九宫格坐标的小算法:(横坐标:i%横向显示个数的最大值;纵坐标:i/纵向的个数的最大值)
        [btn setFrame:CGRectMake(wSpace +(i%3)*(100+wSpace),hSpace +(i/3)*(hSpace+100), 100,100)];
        [view addSubview:btn];
        
        //创建label
        UILabel *label = [MyControl creatLabelWithFrame:CGRectMake(wSpace+(i%3)*(100+wSpace),hSpace+100 + (i/3)*(hSpace+100), 100, 20) text:model.productName];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.nightTextColor = [UIColor whiteColor];
        [view addSubview:label];
        view.contentSize = CGSizeMake(self.view.frame.size.width,CGRectGetMaxY(label.frame)+30);
    }
    
}
-(void)btnClicked:(UIButton *)btn{
    appModel *model = _arr[btn.tag - 101];
    DetailViewController *controller = [[DetailViewController alloc]init];
    controller.myTitle = model.productName;
    controller.productId = model.productId;
    controller.hidesBottomBarWhenPushed = YES;
    [self presentViewController:controller animated:NO completion:nil];
    
}
@end
