
//
//  DBManager.m
//  TravellingTips
//
//  Created by qianfeng01 on 15/7/25.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "DBManager.h"
#import "appModel.h"
@implementation DBManager
{
    FMDatabase *_database;

}
+(DBManager *)sharedManager{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[self alloc]init];
        }
    });
    return manager;
}
-(id)init{
    if (self = [super init]) {
        NSString *filePath = [self getFileFullPathWithFileName:@"app.db"];
        _database = [[FMDatabase alloc]initWithPath:filePath];
        if ([_database open]) {
            [self creatTable];
        }
    }
    return self;
}
-(NSString *)getFileFullPathWithFileName:(NSString *)str{

    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm  fileExistsAtPath:docPath]) {
        return  [docPath stringByAppendingPathComponent:str];
    }else{
        return nil;
    }

}
-(void)creatTable{

NSString *sql = @"create table if not exists appData(serial integer Primary Key Autoincrement,productName Varchar(1024),mImageUrl Varchar(1024),ProductId Varchar(1024))";
    [_database executeUpdate:sql];

}
-(void)insertModel:(id)model{
    appModel *appmodel = (appModel *)model;
    if ([self isExistWithProductName:appmodel.productName]) {
        return;
    }
NSString *sql = @"insert into appData (productName,mImageUrl,productId) values(?,?,?)";
    [_database executeUpdate:sql,appmodel.productName,appmodel.mImageUrl,appmodel.productId];

}
-(void)deleteModel{
NSString *sql = @"delete from appData";
    [_database executeUpdate:sql];

}
-(BOOL)isExistWithProductName:(NSString *)productName{
NSString *sql = @"select *from appData where productName = ?";
   FMResultSet *rs = [_database executeQuery:sql,productName];
    if ([rs next]) {
        return YES;
    }else{
        return NO;
    }

}
-(NSArray *)readModel{
NSString *sql = @"select *from appData";
    FMResultSet *rs = [_database executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([rs next]) {
        appModel *appmodel = [[appModel alloc]init];
        appmodel.productName = [rs stringForColumn:@"productName"];
        appmodel.mImageUrl = [rs stringForColumn:@"mImageUrl"];
        appmodel.productId = [rs stringForColumn:@"productId"];
        [array addObject:appmodel];
    }
    return array;
}
@end
