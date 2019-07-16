//
//  UIImageView+JSWebCache.m
//  SyncDownLoadImg
//
//  Created by ShenYj on 16/8/25.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "UIImageView+JSWebCache.h"
#import "JSDownLoadOperationManager.h"
#import <objc/runtime.h>

@interface UIImageView ()

// 记录当前图片UrlString
@property (nonatomic,copy) NSString *currentIconString;

@end


@implementation UIImageView (JSWebCache)


- (void)js_imageUrlString:(NSString *)urlString withPlaceHolderImage:(NSString *)placeHolderImage
{
    self.image = [UIImage imageNamed:placeHolderImage];
    // 取消之前图片的下载操作
    if ( ![urlString isEqualToString:self.currentIconString] ) {
        [[JSDownLoadOperationManager sharedManager] cancelOperationWithUrlString:self.currentIconString];
    }
    self.currentIconString = urlString;
    
    [[JSDownLoadOperationManager sharedManager] downloadImageWithUrlstring:urlString withCompleteHandler:^(UIImage *image) {
        self.image = image;
    }];
}

- (void)js_imageUrlString:(NSString *)urlString withPlaceHolderImage:(NSString *)placeHolderImage WithSize:(CGSize)size fillClolor:(UIColor *)fillColor completion:(void(^)(UIImage *img))completion
{
    self.image = [UIImage imageNamed:placeHolderImage];
    // 取消之前图片的下载操作
    if ( ![urlString isEqualToString:self.currentIconString] ) {
        [[JSDownLoadOperationManager sharedManager] cancelOperationWithUrlString:self.currentIconString];
    }
    self.currentIconString = urlString;
    
    [[JSDownLoadOperationManager sharedManager] downloadImageWithUrlstring:urlString withCompleteHandler:^(UIImage *image) {
        //self.image = image;
        // 异步处理
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 开启图形上下文
            UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
            // 设置rect
            CGRect rect = CGRectMake(0, 0, size.width, size.height);
            // 设置填充色
            [fillColor set];
            UIRectFill(rect);
            // 计算半径
            CGFloat cornerRadius = MIN(size.width, size.height) * 0.5;
            // 设置圆形路径并切割
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
            // 将原始图片绘制到图形上下文中
            [image drawInRect:rect];
            // 从图形上下获取图片
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭图形上下文
            UIGraphicsEndImageContext();
            // 主线程返回圆形图片
            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completion) {
//                    completion(image);
//                }
                self.image = image;
            });
        });
    }];
    
    
}

- (void)setCurrentIconString:(NSString *)currentIconString{
    
    objc_setAssociatedObject(self, "currentIconString", currentIconString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)currentIconString{
    
    return objc_getAssociatedObject(self, "currentIconString");
}

@end
