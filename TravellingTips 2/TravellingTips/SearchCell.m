//
//  SearchCell.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/6.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell


- (void)awakeFromNib {
    self.homeImageView.layer.masksToBounds = YES;
    self.homeImageView.layer.cornerRadius = 8;
    
    CGRect frame = self.retailPriceLabel.frame;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.nightBackgroundColor = [UIColor orangeColor];
    [self.retailPriceLabel addSubview:lineView];
}
-(void)showDataWithModel:(appModel *)model{
    [DKNightVersionManager addClassToSet:self.class];
    self.nightBackgroundColor = [UIColor darkGrayColor];
    [self.homeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.yaochufa.com/%@",model.homeImageUrl]] placeholderImage:[UIImage imageNamed:@"detail_facilities_load_icon"]];
    self.productNameLabel.text = model.productName;
    self.productNameLabel.nightTextColor = [UIColor whiteColor];
    
    self.contentLabel.text = [NSString stringWithFormat:@"[%@]%@",model.city,model.productTitleContent];
    self.contentLabel.nightTextColor = [UIColor whiteColor];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.priceLabel.nightTextColor = [UIColor whiteColor];
    self.retailPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.retailPrice];
    self.retailPriceLabel.nightTextColor = [UIColor whiteColor];
    self.sacelLabel.text = [NSString stringWithFormat:@"已售%@",model.saledCount];
    self.sacelLabel.nightTextColor = [UIColor whiteColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView *lineView = self.retailPriceLabel.subviews[0];
    lineView.backgroundColor = [UIColor lightGrayColor];
       lineView.nightBackgroundColor = [UIColor orangeColor];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    UIView *lineView = self.retailPriceLabel.subviews[0];
    lineView.backgroundColor = [UIColor lightGrayColor];
   lineView.nightBackgroundColor = [UIColor orangeColor];
}

@end
