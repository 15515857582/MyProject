//
//  TableViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.nightBackgroundColor = [UIColor blackColor];
 

}

-(void)initLocationManager{
  
    if (!self.manager) {
        self.manager = [[CLLocationManager alloc]init];
        //设置精确度
        self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        CGFloat version = [[[UIDevice currentDevice]systemVersion] floatValue];
        if (version >= 8.0) {
            [self.manager requestAlwaysAuthorization];
        }
        self.manager.delegate = self;
    }
    
    [self begineLocation];
    
}
-(void)begineLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        [self.manager startUpdatingLocation];
 
    }else{
        
        [UIAlertView showFailureUnabled];
        
    }
 
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [UIAlertView showFailure];
    if(error.code == kCLErrorLocationUnknown)
    {
        //NSLog(@"Currently unable to retrieve location.");
    }
    else if(error.code == kCLErrorNetwork)
    {
        NSLog(@"Network used to retrieve location is unavailable.");
    }
    else if(error.code == kCLErrorDenied)
    {
        NSLog(@"Permission to retrieve location is denied.");
        [manager stopUpdatingLocation];
    }
    
}
#pragma mark - CLLocationManagerDelegate协议
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (locations.count) {
        CLLocation *location = [locations lastObject];
        CLLocationCoordinate2D coordinate = location.coordinate;
        self.longitude = coordinate.longitude;
        self.latitude = coordinate.latitude;

        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks) {
                CLPlacemark *place = placemarks[0];
                NSString *cityName = place.addressDictionary[@"City"];
                self.city = cityName;
               
          
            }
        }];
    }


}


-(void)addTitleViewWithTitle:(NSString *)title{
    UILabel *titleLabel = [MyControl creatLabelWithFrame:CGRectMake(0, 0, 200, 30) text:title];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor orangeColor];
  
    self.navigationItem.titleView = titleLabel;
    
}
-(void)addTitleView{
    _searchBar = [MyControl createSearchBarWithFrame:CGRectMake(0, 0, 200, 30) placeHolder:@"请输入城市名" delegate:self];
    self.navigationItem.titleView = _searchBar;
}


-(void)addBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft{

    UIButton *button = [MyControl creatButtonWithFrame:CGRectMake(0, 0, 60, 30) target:target sel:action tag:0 image:@"btn_background_icon_normal" selectImage:@"btn_background_icon_selected" title:title];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont systemFontOfSize:12];
    button.titleLabel.textAlignment =NSTextAlignmentRight;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(48, 13, 7, 5)];
    imageView.image =[UIImage imageNamed:@"reservation_arrow_down"];
    [button addSubview:imageView];
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithCustomView:button];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
       
    }else{
        self.navigationItem.rightBarButtonItem = item;
        
    }
    
}


#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
    
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text= @"";
    [searchBar resignFirstResponder];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];

}

@end
