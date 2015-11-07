//
//  TabBarController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "TabBarController.h"
#import "TableViewController.h"
#import "HomeViewController.h"
#import "AroundViewController.h"
#import "DiscoverViewController.h"
#import "MyViewController.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatViewControllers];
    [self creatLaunchImageAnimation];
}
- (void)creatLaunchImageAnimation{
    UIImageView *startView = [MyControl creatImageViewWithFrame:self.view.bounds imageName:[NSString stringWithFormat:@"Default%u",arc4random()%5]];
    [self.view addSubview:startView];
    [UIView animateWithDuration:3 animations:^{
        startView.alpha = 0;
    } completion:^(BOOL finished) {
        [startView removeFromSuperview];
    }];


}
-(void)creatViewControllers{

   
    NSArray *cls =@[[HomeViewController class],[AroundViewController class],[DiscoverViewController class],[MyViewController class]];
    NSArray *titles = @[@"首页",@"周边",@"发现",@"我"];
    NSArray *customNames = @[@"tab_bar_home_icon",@"tab_bar_around_icon",@"tab_bar_discover_icon",@"tab_bar_my_icon"];
    NSArray *selectedNames = @[@"tab_bar_home_icon_current",@"tab_bar_around_icon_current",@"tab_bar_discover_icon_current",@"tab_bar_my_icon_current"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0;i<cls.count ; i++) {
        TableViewController *controller = [[cls[i] alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
        nav.navigationBar.nightBarTintColor = [UIColor darkGrayColor];
        nav.tabBarItem.title = titles[i];
       
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
        [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:16 weight:50]} forState:UIControlStateNormal];
        nav.tabBarItem.image = [UIImage imageNamed:customNames[i]];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [arr addObject:nav];
    }
    self.viewControllers = arr;

}


@end
