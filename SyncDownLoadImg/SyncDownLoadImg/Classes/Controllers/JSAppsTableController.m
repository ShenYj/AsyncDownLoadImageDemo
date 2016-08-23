//
//  JSAppsTableController.m
//  SyncDownLoadImg
//
//  Created by ShenYj on 16/8/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSAppsTableController.h"
#import "JSAppsModel.h"
#import "JSAppCell.h"


static NSString * const reuseIdentifier = @"reuseIdentifier";

@implementation JSAppsTableController{
    NSArray <JSAppsModel *>      *_data;             //  数据容器
    NSOperationQueue             *_queue;            //  全局队列
    NSMutableDictionary          *_operationCache;   //  操作缓存池
    NSMutableDictionary          *_imageCache;       //  图片缓存池
    
}

- (instancetype)initWithFileName:(NSString *)fileName{
    self = [super init];
    if (self) {
        
        // 成员变量初始化
        _data = [JSAppsModel loadAppsDataWithFileName:fileName];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 5;
        _operationCache = [NSMutableDictionary dictionaryWithCapacity:5];
        _imageCache = [NSMutableDictionary dictionaryWithCapacity:5];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[JSAppCell class] forCellReuseIdentifier:reuseIdentifier];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JSAppCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    JSAppsModel *model = _data[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.download;
    
    // 设置占位图
    cell.imageView.image = [UIImage imageNamed:@"user_default"];
    
    
    // 从缓存中取出图片
    if ([_imageCache objectForKey:model.icon]) {
        cell.imageView.image = [_imageCache objectForKey:model.icon];
        NSLog(@"从内存图片缓存池中获取图片");
        return cell;
    }
    
    // 判断操作是否存在
    if ([_operationCache objectForKey:model.icon]) {
        NSLog(@"图片正在下载中...");
        return cell;
    }
    
    // 异步下载图片
    NSBlockOperation *downLoadImageOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [NSThread sleepForTimeInterval:5]; // 模拟延迟
        
        // 下载图片
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]];
        UIImage *image = [UIImage imageWithData:data];
        
        // 将下载好的图片进行缓存
        // model.downloadImage = image;
        [_imageCache setObject:image forKey:model.icon];
        
        // 返回主线程刷新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            // cell.imageView.image = image; 避免重用Cell中有正在执行的下载操作导致图片混乱,直接刷新TableView从内存获取图片
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
    }];
    
    // 将操作添加到队列中
    [_queue addOperation:downLoadImageOperation];
    
    // 将每一个下载图片的操作都添加到操作缓存池中(如果操作已经存在,就不再重复执行)
    [_operationCache setObject:downLoadImageOperation forKey:model.icon];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"----->ImageCacheCounts:%zd ----> OperationCacheCounts:%zd ---->CurrentOperationCounts:%zd",_imageCache.count,_operationCache.count,_queue.operationCount);
    
}

- (void)didReceiveMemoryWarning{
//    [super didReceiveMemoryWarning];
    
    [_imageCache removeAllObjects];
    
}



@end
