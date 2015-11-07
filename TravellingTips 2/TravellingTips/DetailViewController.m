//
//  DetailViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/8.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "DetailViewController.h"
#import "appModel.h"
#import "CityCodeModel.h"
#import "NSString+util.h"
#import "UMSocial.h"
#import "MyControl.h"
#import "JHRefresh.h"
#import "MapViewController.h"
#import "ImageViewController.h"
@interface DetailViewController ()<UMSocialUIDelegate>
@property (nonatomic,strong)appModel *model;
@property(nonatomic,strong) NSMutableArray *imageArr;
@property(nonatomic,copy)NSString *Ttitle;
@property(nonatomic,copy)NSString *abstract;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back"]]];
    self.view.nightBackgroundColor = [UIColor darkGrayColor];
    UIFont *font = [UIFont systemFontOfSize:14];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.7];
    view.nightBackgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [self.view addSubview:view];
    UIButton *button = [MyControl creatButtonWithFrame:CGRectMake(5, 30, 50, 25) target:self sel:@selector(back) tag:123 image:@"ButtonOrange" selectImage:@"" title:@"返回"];
    [button.titleLabel setFont:font];
    button.titleLabel.nightTextColor = [UIColor whiteColor];
    [view addSubview:button];
    UIButton *button1 = [MyControl creatButtonWithFrame:CGRectMake(self.view.frame.size.width-55, 30, 50, 25) target:self sel:@selector(itemClick) tag:124 image:@"ButtonOrange" selectImage:@"" title:@"分享"];
    [button1.titleLabel setFont:font];
    button1.titleLabel.nightTextColor = [UIColor whiteColor];
    [view addSubview:button1];
    UIButton *button2 = [MyControl creatButtonWithFrame:CGRectMake(self.view.frame.size.width-110, 30, 50, 25) target:self sel:@selector(itemClick1) tag:124 image:@"ButtonOrange" selectImage:@"" title:@"地图"];
    [button2.titleLabel setFont:font];
    button2.titleLabel.nightTextColor = [UIColor whiteColor];
    [view addSubview:button2];
    UILabel *detail = [MyControl creatLabelWithFrame:CGRectMake(self.view.frame.size.width/2.0-40, 30, 80, 30) text:@"详情介绍"];
    detail.font = font;
    detail.nightTextColor = [UIColor whiteColor];
    [view addSubview:detail];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"欢迎使用" status:@"下载中..."];
    [self initData];


    
}
-(void)itemClick1{
    MapViewController *controller= [[MapViewController alloc]init];
    controller.coordinate = self.coordinate;//这里的self相当于detail页面，而detail页面的coordinate是由主页传递过来的
    controller.myTitle = self.myTitle;
    controller.productTitle = self.productTitle;
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = @"suckEffect";
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self presentViewController:controller animated:NO completion:nil];
}
-(void)itemClick{

    NSString *text = [NSString stringWithFormat:@"旅游小助手https://itunes.apple.com/cn/app/lu-you-xiao-zhu-shou/id1020189982?mt=8"];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010"shareText:text
        shareImage:[UIImage imageNamed:@"Icon"]
        shareToSnsNames:@[UMShareToSina,UMShareToSms,UMShareToEmail,UMShareToQQ,UMShareToWechatTimeline]delegate:self];
}
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)initData{
 
    NSString *url = [NSString stringWithFormat:kDetail,self.productId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[ AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (responseObject) {
             self.imageArr = [[NSMutableArray alloc]init];
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             NSDictionary *dataDict =dict[@"data"];
             id reDict = dataDict[@"recommendTrip"];
             appModel *model =[[appModel alloc]init];
             if ((NSNull *)reDict == [NSNull null]) {
                 [MMProgressHUD dismissWithError:@"无详情数据"];
             }else{
             [model setValuesForKeysWithDictionary:(NSDictionary *)reDict];
             self.Ttitle = model.title;
             self.abstract = model.abstract;
             NSArray *arr =dataDict[@"imageList"];
             for (NSDictionary *imageDict in arr) {
                 CityCodeModel *cityModel =[[ CityCodeModel alloc]init];
                 [cityModel setValuesForKeysWithDictionary:imageDict];
                 [self.imageArr addObject:cityModel.url];
             }
             }
         }
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.nightBackgroundColor = [UIColor darkGrayColor];
        [self creatSrollView];
        [MMProgressHUD dismissWithSuccess:@"完成"];
        
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MMProgressHUD dismissWithError:@"网络不给力"];
     }];
}
-(void)creatSrollView{
    if (self.imageArr.count == 0) {
        UILabel *label = [MyControl creatLabelWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 20) text:@"暂无详情,敬请期待"];
        label.nightTextColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        self.view.backgroundColor = [UIColor lightGrayColor];
    }else{
    UIFont *font = [UIFont systemFontOfSize:14];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-64)];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, [self.myTitle heightWithFont:font width:self.view.frame.size.width]);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:frame];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.myTitle;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.nightTextColor = [UIColor whiteColor];
    [scrollView addSubview:titleLabel];
    frame.origin.y = CGRectGetMaxY(frame)+5;
    frame.size.height = 170;
    UIImageView *imageView =[[ UIImageView alloc]initWithFrame:frame];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 8;
        imageView.tag = 201;
        imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.yaochufa.com/%@",self.imageArr[0]]] placeholderImage:[UIImage imageNamed:@"backImage"]];
        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap0];
    [scrollView addSubview:imageView];
    
    
    frame.origin.y = CGRectGetMaxY(frame);
    frame.size.height = [self.Ttitle heightWithFont:font width:frame.size.width];
    UILabel *contentLabel =[[UILabel alloc]initWithFrame:frame];
    contentLabel.font = font;
    contentLabel.numberOfLines = 0;
    contentLabel.text = self.Ttitle;
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.nightTextColor = [UIColor whiteColor];
    [scrollView addSubview:contentLabel];
    frame.origin.y = CGRectGetMaxY(frame)+5;
    frame.size.height = 170;

    UIImageView *imageView1 =[[ UIImageView alloc]initWithFrame:frame];
    imageView1.layer.masksToBounds = YES;
    imageView1.layer.cornerRadius = 8;
        imageView1.tag = 202;
        imageView1.userInteractionEnabled = YES;
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.yaochufa.com/%@",self.imageArr[1]]] placeholderImage:[UIImage imageNamed:@"backImage"]];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView1 addGestureRecognizer:tap1];
    [scrollView addSubview:imageView1];
      
    frame.origin.y = CGRectGetMaxY(frame);
    frame.size.height = [self.abstract heightWithFont:font width:frame.size.width];
    UILabel *abLabel =[[UILabel alloc]initWithFrame:frame];
    abLabel.font =font;
    abLabel.numberOfLines = 0;
        abLabel.textColor = [UIColor blackColor];
        abLabel.nightTextColor = [UIColor whiteColor];
    abLabel.text = self.abstract;
    [scrollView addSubview:abLabel];
    for (int i = 2; i<self.imageArr.count; i++) {
        UIImageView *imageView2 =[[ UIImageView alloc]initWithFrame:CGRectMake(0, (i-2)*175+CGRectGetMaxY(frame)+5, frame.size.width, 170)];
        imageView2.layer.masksToBounds = YES;
        imageView2.layer.cornerRadius = 8;
        imageView2.tag = 203+i;
        imageView2.userInteractionEnabled = YES;
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.yaochufa.com/%@",self.imageArr[i]]] placeholderImage:[UIImage imageNamed:@"backImage"]];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView2 addGestureRecognizer:tap2];
        [scrollView addSubview:imageView2];
   
    }
    
    scrollView.contentSize = CGSizeMake(frame.size.width, CGRectGetMaxY(frame)+(self.imageArr.count-2)*175+20);
    [self.view addSubview:scrollView];
    }
}
-(void)back{

    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    ImageViewController *controller = [[ImageViewController alloc]init];
    UIImageView *imageView= (UIImageView *)tap.view;
    controller.index = imageView.tag - 201;
    controller.array = self.imageArr;
    [self presentViewController:controller animated:YES completion:nil];
    

}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:NO];
//    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]];
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(itemClick)];
//    
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(itemClick1)];
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    self.toolbarItems = @[item1,spaceItem,item2,item3];
//}
@end
