//
//  DataManager.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-14.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "DataManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

#define MYLOG(a) NSLog(@"DataManager log : %@",a)

static DataManager *_manager = nil;
@implementation DataManager
{
    FMDatabase *_dataBase;
}

+(id)shareDataManager{
    if (_manager == nil) {
        _manager = [[DataManager alloc]init];
    }
    return _manager;
}
// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [_dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %d", count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)createDataBaseAndTables{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath lastObject];
    NSLog(@"%@",filePath);
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"db.sqlite"];
    _dataBase = [FMDatabase databaseWithPath:dbFilePath];
    if (![_dataBase open]) {
        MYLOG(@"数据库打开失败");
        return;
    }
    //为数据库设置缓存，提高查询效率
    [_dataBase setShouldCacheStatements:YES];
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self isTableOK:@"creHistory"])
    {
        BOOL is = [_dataBase executeUpdate:@"CREATE TABLE \"creHistory\" (\"id\" integer NOT NULL PRIMARY KEY AUTOINCREMENT,\"type\" text NOT NULL,\"content\" text NOT NULL,\"image\" BLOB NOT NULL,\"date\" text NOT NULL);"];
        if (is) {
            MYLOG(@"crehistory 表创建完成");
            
        }else{
            MYLOG(@"crehistory 表创建失败");
        }
    }
    if(![self isTableOK:@"scanHistory"])
    {
        BOOL is = [_dataBase executeUpdate:@"CREATE TABLE \"scanHistory\" (\"id\" integer NOT NULL PRIMARY KEY AUTOINCREMENT,\"type\" text NOT NULL,\"content\" text NOT NULL,\"image\" BLOB NOT NULL,\"date\" text NOT NULL);"];
        if (is) {
            MYLOG(@"scanHistory 表创建完成");
        }else{
            MYLOG(@"scanHistory 表创建失败");
        }
    }
    [_dataBase close];
    MYLOG(@"数据库初始化完成");
}



-(void)addDataToCreTable:(DataModel *)model{
    [self addDataToTable:@"creHistory" WithModel:model];
}
- (NSArray *)resaultOfCreTable{
    return [self allItemFromTable:@"creHistory"];
}

-(void)addDataToScanTable:(DataModel *)model{
    [self addDataToTable:@"scanHistory" WithModel:model];
}
-(NSArray *)resaultOfScanTable{
    return [self allItemFromTable:@"scanHistory"];
}
#pragma mark mothod
-(void)addDataToTable:(NSString *)tableName WithModel:(DataModel *)model{
    
    if (![_dataBase open]) {
        MYLOG(@"数据库打开失败");
        return;
    }
    if (model.type == nil || model.content == nil || model.image == 0) {
        return;
    }
//    NSDate *date = [NSDate date];
//    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/%f",NSHomeDirectory(),[date timeIntervalSince1970]];
//    NSData *data = UIImagePNGRepresentation(model.image);
//    [data writeToFile:path atomically:YES];

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (type, content, image, date) VALUES (?,?,?,?);",tableName];
    [_dataBase executeUpdate:sql,model.type,model.content,UIImagePNGRepresentation(model.image),[NSDate date]];
    
    [_dataBase close];
}
-(void)updateDataTotable:(NSString *)tableName WithModel:(DataModel *)model{
    
    if (![_dataBase open]) {
        MYLOG(@"数据库打开失败");
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where id = ?;",tableName];
    FMResultSet *rs = [_dataBase executeQuery:sql,[NSString stringWithFormat:@"%d",model.key]];
    if([rs next])
    {
        sql = [NSString stringWithFormat:@"update %@ set type = ?, content = ?, image = ?, date = ? where id = ?;",tableName];
        if ([_dataBase executeUpdate:sql,model.type,model.content,UIImagePNGRepresentation(model.image),[NSDate date],[NSString stringWithFormat:@"%d",model.key]]) {
            MYLOG(@"更新数据成功");
        }else{
            MYLOG(@"更新数据失败");
        }
    }
    
    [_dataBase close];
    
}
-(NSArray *)allItemFromTable:(NSString *)tableName{
    if (![_dataBase open]) {
        MYLOG(@"数据库打开失败");
        return nil;
    }
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithArray:0];
    //先查date 为空的字段
    NSString *sql = [NSString stringWithFormat:@"select * from %@ ORDER BY id DESC;",tableName];
    FMResultSet *rs = [_dataBase executeQuery:sql];
    while ([rs next]) {
        DataModel *model = [[DataModel alloc]init];
        model.key = [rs intForColumn:@"id"];
        model.type = [rs stringForColumn:@"type"];
        model.content = [rs stringForColumn:@"content"];
        NSData *data = [rs dataForColumn:@"image"];
        model.image = [UIImage imageWithData:data];
        model.date = [rs dateForColumn:@"date"];
        //将查询到的数据放入数组中。
        [modelArray addObject:model];
    }
    [_dataBase close];
    return modelArray;
}

@end
