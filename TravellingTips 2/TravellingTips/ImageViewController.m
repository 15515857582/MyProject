//
//  ImageViewController.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/26.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UICollectionViewDataSource>

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];

    self.collectionView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.3];
    self.collectionView.nightBackgroundColor = [UIColor blackColor];
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.7];
    view.nightBackgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 22, 50, 30);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}
-(void)back{

    [self dismissViewControllerAnimated:YES completion:nil];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.index] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
//}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.array.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    cell.frame = CGRectMake(25, 100, self.view.frame.size.width-50, self.view.frame.size.height-400);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.frame];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.yaochufa.com/%@",self.array[indexPath.section]]] placeholderImage:[UIImage imageNamed:@"back"]];
    [cell.contentView addSubview:imageView];
    return cell;
    
}


@end
