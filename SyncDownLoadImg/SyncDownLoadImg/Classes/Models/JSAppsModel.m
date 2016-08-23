//
//  JSAppsModel.m
//  SyncDownLoadImg
//
//  Created by ShenYj on 16/8/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSAppsModel.h"

@implementation JSAppsModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)appWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"name:%@ -icon:%@ -download:%@",_name,_icon,_download];
    
}

+ (NSArray <JSAppsModel *> *)loadAppsDataWithFileName:(NSString *)fileName{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    NSArray *data = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        
        JSAppsModel *model = [self appWithDict:dict];
        
        [mArr addObject:model];
    }
    
    return mArr.copy;
}


@end
