//
//  DiscoverCell.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/6.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appModel.h"
@interface DiscoverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
-(void)showDataWithModel:(appModel *)model;
@end
