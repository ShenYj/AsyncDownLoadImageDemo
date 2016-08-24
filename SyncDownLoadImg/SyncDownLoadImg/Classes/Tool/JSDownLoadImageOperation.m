//
//  JSDownLoadImageOperation.m
//  SyncDownLoadImg
//
//  Created by ShenYj on 16/8/24.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSDownLoadImageOperation.h"

@implementation JSDownLoadImageOperation

- (void)main{
    
    NSAssert(self.completeHandler != nil, @"completeHandler == nil");
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlString]]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.completeHandler(image);
    }];
    
}

+ (instancetype)downLoadWithImageUrlString:(NSString *)urlString withCompleteHandler:(void (^)(UIImage *))completeHandler{
    JSDownLoadImageOperation *operation = [[self alloc] init];
    operation.urlString = urlString;
    operation.completeHandler = completeHandler;
    return operation;
}

@end
