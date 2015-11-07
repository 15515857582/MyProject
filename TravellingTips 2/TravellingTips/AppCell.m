//
//  AppCell.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/4.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "AppCell.h"

@implementation AppCell

- (void)awakeFromNib {
    self.urlImageView.layer.masksToBounds = YES;
    self.urlImageView.layer.cornerRadius = 8;
    
    CGRect frame = self.origalPriceLabel.frame;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.nightBackgroundColor = [UIColor orangeColor];
    [self.origalPriceLabel addSubview:lineView];
}
-(void)showDataWithModel:(appModel *)model{
    [DKNightVersionManager addClassToSet:self.class];
    self.nightBackgroundColor = [UIColor darkGrayColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.yaochufa.com/%@",model.mImageUrl]] placeholderImage:[UIImage imageNamed:@"detail_facilities_load_icon"]];
    self.productNameLabel.text = model.productName;
    self.productNameLabel.nightTextColor = [UIColor whiteColor];
    self.contentLabel.text = [NSString stringWithFormat:@"[%@]%@",model.cityName,model.productTitleContent];
    self.contentLabel.nightTextColor = [UIColor whiteColor];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.priceLabel.nightTextColor = [UIColor whiteColor];
    self.origalPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.retailPrice];
    self.origalPriceLabel.nightTextColor = [UIColor whiteColor];
    self.saledLLabel.text = [NSString stringWithFormat:@"已售%@",model.saledCount];
    self.saledLLabel.nightTextColor = [UIColor whiteColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UIView *lineView = self.origalPriceLabel.subviews[0];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.nightBackgroundColor = [UIColor orangeColor];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    UIView *lineView = self.origalPriceLabel.subviews[0];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.nightBackgroundColor = [UIColor orangeColor];
}
@end
