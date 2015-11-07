//
//  AppDelegate.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import <iflyMSC/iflyMSC.h>
#import <MAMapKit/MAMapKit.h>

@interface AppDelegate ()<UIScrollViewDelegate>
{
    BOOL isOut;
}
@end

@implementation AppDelegate

-(void)initUM{
[UMSocialData
 setAppKey:@"507fcab25270157b37000010"];
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.1000phone.com"];

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initUM];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    TabBarController *controller= [[TabBarController alloc]init];
    self.window.rootViewController = controller;
     [IFlySpeechUtility createUtility:@"appid=54ca389d"];
    [MAMapServices sharedServices].apiKey = @"eb498062bf2bc989409b8f3a40d10801";
    isOut = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExists = [fm fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/ex.txt"]];
    if (isExists) {
        [self gotoMain];
    }else{
    
        [self makeLaunchView];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)makeLaunchView{
    UIScrollView *scr = [[UIScrollView alloc]initWithFrame:self.window.bounds];
    scr.contentSize = CGSizeMake(self.window.bounds.size.width*5, self.window.bounds.size.height);
    scr.pagingEnabled  = YES;
 
    scr.delegate = self;
    scr.bounces = NO;
    for (int i = 0; i<5; i++) {
        UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.window.bounds.size.width, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Default%d",i]];
        [scr addSubview:imageView];
    }
    [self.window.rootViewController.view addSubview:scr];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 4*self.window.bounds.size.width) {
        isOut = YES;
        
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (isOut == YES) {
        [UIView animateWithDuration:3 animations:^{
            scrollView.alpha = 0;
        } completion:^(BOOL finished) {
            [scrollView removeFromSuperview];
            [self gotoMain];
        }];
    }
}
-(void)gotoMain{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/ex.txt"]]) {
        [fm createFileAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/ex.txt"] contents:nil attributes:nil];
    }

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
 
}

@end
