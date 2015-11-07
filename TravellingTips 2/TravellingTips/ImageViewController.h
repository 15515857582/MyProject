//
//  ImageViewController.h
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/26.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "TableViewController.h"

@interface ImageViewController : TableViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic) NSInteger index;
@end
