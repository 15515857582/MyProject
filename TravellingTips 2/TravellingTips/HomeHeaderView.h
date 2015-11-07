//
//  HomeHeaderView.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/8.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderView : UIView<UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UILabel *imageNum;
-(void)creatHeaderView;
-(void)openTimer;
-(void)closeTimer;
@end
