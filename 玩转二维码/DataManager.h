//
//  DataManager.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-14.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface DataManager : NSObject

+(id)shareDataManager;
-(void)createDataBaseAndTables;

-(void)addDataToCreTable:(DataModel *)model;
- (NSArray *)resaultOfCreTable;


-(void)addDataToScanTable:(DataModel *)model;
- (NSArray *)resaultOfScanTable;

@end
