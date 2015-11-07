//
//  AppCell.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/4.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appModel.h"
@interface AppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *origalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saledLLabel;


-(void)showDataWithModel:(appModel *)model;

@end
