//
//  DiscoverCell.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/6.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "DiscoverCell.h"

@implementation DiscoverCell

- (void)awakeFromNib {
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 9;

}
-(void)showDataWithModel:(appModel *)model{
    [DKNightVersionManager addClassToSet:self.class];
    self.nightBackgroundColor = [UIColor darkGrayColor];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"backImage"]];
    self.titleLabel.text = model.title;
    self.titleLabel.nightTextColor = [UIColor whiteColor];
    self.subTitleLabel.text = model.subTitle;
    self.subTitleLabel.nightTextColor = [UIColor whiteColor];
    self.districtNameLabel.text = model.districtName;
    self.districtNameLabel.nightTextColor = [UIColor whiteColor];
}


@end
