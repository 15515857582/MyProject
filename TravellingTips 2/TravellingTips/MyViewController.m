//
//  MyViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "MyViewController.h"
#import "SDImageCache.h"
#import "UMSocial.h"
#import "DKNightVersionManager.h"
#import "ScanViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate>
{
    UITableView *_tableView;
    NSArray *arr1;

}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self dataInit];
}

-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.nightBackgroundColor = [UIColor darkGrayColor];
    _tableView.tableHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting.jpg"]];
    
    [self.view addSubview:_tableView];

}
-(void)dataInit{
    arr1 = @[@"夜间模式",@"浏览历史",@"清除缓存",@"分享",@"联系我们:1037624434@qq.com"];
    [_tableView reloadData];
    
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return arr1.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [DKNightVersionManager addClassToSet:[UITableViewCell class]];
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text =arr1[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.nightTextColor = [UIColor whiteColor];
    cell.nightBackgroundColor = [UIColor lightGrayColor];
    return cell;
}
-(double)getCachesSize{
    double sdSize = [[SDImageCache sharedImageCache] getSize];
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingFormat:@"Library/Caches/Myches"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    double mySize = 0;
    for (NSString *fileName in enumerator) {
        NSString *filePath = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        mySize += dict.fileSize;
    }
    double totalSize = (mySize +sdSize)/1024/1024;
    return totalSize;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
                [DKNightVersionManager dawnComing];
                      arr1 = @[@"夜间模式",@"浏览历史",@"清除缓存",@"分享",@"联系我们:1037624434@qq.com"];
            }else{
                [DKNightVersionManager nightFalling];
                      arr1 = @[@"日间模式",@"浏览历史",@"清除缓存",@"分享",@"联系我们:1037624434@qq.com"];
            }
       
            
            [_tableView reloadData];
        }
            break;
        case 1:{
            ScanViewController *controller = [[ScanViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.type = @"rippleEffect";
            transition.duration = 1;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
           // self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:NO];
        }
            break;
       
        case 2:{
            NSString *title = [NSString stringWithFormat:@"删除文件:%.2fM",[self getCachesSize]];
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除缓存" otherButtonTitles:@"删除浏览历史",nil];
            [sheet showInView:self.view];
        }
            break;
        case 3:{
        
           [self share];
        }
            break;
        case 4:{
        
        }
            break;
        default:
            break;
    }

}
-(void)share{
    NSString *text = [NSString stringWithFormat:@"旅游小助手https://itunes.apple.com/cn/app/lu-you-xiao-zhu-shou/id1020189982?mt=8"];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010"
                                      shareText:text
                                     shareImage:[UIImage imageNamed: @"account_candou"]
                                shareToSnsNames:@[UMShareToSina,UMShareToSms,UMShareToEmail,UMShareToQQ,UMShareToWechatTimeline]
                                       delegate:self];

}
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        NSString *myCachePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/MyCaches"];
        [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
    }else if (buttonIndex == actionSheet.firstOtherButtonIndex){
        [[DBManager sharedManager]deleteModel];
    }

}

@end
