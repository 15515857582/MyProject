//
//  SearchCell.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/6.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appModel.h"
@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sacelLabel;
-(void)showDataWithModel:(appModel *)model;
@end
