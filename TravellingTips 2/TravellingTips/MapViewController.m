//
//  MapViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/25.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
@interface MapViewController ()<MAMapViewDelegate>
@property (nonatomic,strong) MAMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.7];
    view.nightBackgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:view];
    UIButton *button = [MyControl creatButtonWithFrame:CGRectMake(5, 30, 50, 25) target:self sel:@selector(back:) tag:123 image:@"ButtonOrange" selectImage:@"" title:@"返回"];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    button.titleLabel.nightTextColor = [UIColor whiteColor];
    [view addSubview:button];
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _mapView.mapType = MAMapTypeStandard;
    NSArray *array = [self.coordinate componentsSeparatedByString:@","];
    
    _mapView.region = MACoordinateRegionMake(CLLocationCoordinate2DMake(fabsf([array[1] floatValue]), fabsf([array[0] floatValue])), MACoordinateSpanMake(0.01, 0.01));
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc]init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(fabsf([array[1] floatValue]), fabsf([array[0] floatValue]));
    pointAnnotation.title =self.myTitle;
    pointAnnotation.subtitle = self.productTitle;
    [_mapView addAnnotation:pointAnnotation];
    
}
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier =@"reuse";
        MAPinAnnotationView *view = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (view == nil) {
            view = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        view.canShowCallout = YES;
        view.animatesDrop = YES;
        
        view.pinColor = MAPinAnnotationColorPurple;
        return view;
    }
    return nil;
}
-(void)back:(UIButton *)button{

    [self dismissViewControllerAnimated:NO completion:nil];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
