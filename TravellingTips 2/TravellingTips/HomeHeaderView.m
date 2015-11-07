//
//  HomeHeaderView.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/8.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "HomeHeaderView.h"
#import "UIImage+WebP.h"
@implementation HomeHeaderView
-(void)creatHeaderView {

    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    for (NSInteger i = 0; i<_arr.count+2; i++) {
        UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        if (_arr.count != 0) {
            
        
        if (i==0 ) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_arr[_arr.count-1]] placeholderImage:[UIImage imageNamed:@"backImage"]];
        }
       else if(i == _arr.count+1) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_arr[0]] placeholderImage:[UIImage imageNamed:@"backImage"]];
        }
        else  {
            
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_arr[i-1]] placeholderImage:[UIImage imageNamed:@"backImage"]];
        [_scrollView addSubview:imageView];
        }
        }
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*(_arr.count+2), _scrollView.frame.size.height);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
//    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, CGRectGetWidth(self.frame), 20)];
////    containerView.backgroundColor = [UIColor clearColor];
//    [self addSubview:containerView];
//    UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame))];
//    alphaView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5];
//    alphaView.nightBackgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
//    alphaView.alpha = 0.7;
//    [containerView addSubview:alphaView];
//    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width-80, self.frame.size.height-20, 60, 20)];
//    _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    _pageControl.currentPage = 1 ;
//    _pageControl.numberOfPages = _arr.count;
//    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
//    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    
//    [self addSubview:_pageControl];
//    _imageNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(containerView.frame)-20, 20)];
//    _imageNum.font = [UIFont boldSystemFontOfSize:15];
//    _imageNum.backgroundColor = [UIColor clearColor];
//    _imageNum.textColor = [UIColor orangeColor];
//    _imageNum.textAlignment = NSTextAlignmentRight;
//    [containerView addSubview:_imageNum];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer setFireDate:[NSDate distantPast]];
    

}
-(void)timerAction:(NSTimer *)timer{
    if (_arr.count>1) {
        CGPoint newOffset = _scrollView.contentOffset;
        newOffset.x = newOffset.x + CGRectGetWidth(_scrollView.frame);
        if (newOffset.x >(CGRectGetWidth(_scrollView.frame)*(_arr.count+1))) {
            newOffset.x = _scrollView.frame.size.width;
        }
        if ((int)newOffset.x <_scrollView.frame.size.width) {
            newOffset.x=_scrollView.frame.size.width*_arr.count;
        }
        int index = newOffset.x/CGRectGetWidth(_scrollView.frame);
        newOffset.x = index*CGRectGetWidth(_scrollView.frame);
//        _imageNum.text = [NSString stringWithFormat:@"%d / %ld",index+1,_arr.count];
        [_scrollView setContentOffset:newOffset animated:YES];
    }else{
    
        [_timer setFireDate:[NSDate distantFuture]];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if ((int)point.x <_scrollView.frame.size.width) {
        [scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*_arr.count, 0) animated:NO];
    }
    if((int)point.x > _scrollView.frame.size.width*_arr.count){
    
        [scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    }
//    int index = fabs(scrollView.contentOffset.x-_scrollView.frame.size.width)/scrollView.frame.size.width;
//    
//    _pageControl.currentPage = index;

}
-(void)openTimer{

    [_timer setFireDate:[NSDate distantPast]];
}
-(void)closeTimer{

    [_timer setFireDate:[NSDate distantFuture]];
}
@end
