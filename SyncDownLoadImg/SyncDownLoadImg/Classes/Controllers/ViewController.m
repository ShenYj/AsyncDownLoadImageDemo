//
//  ViewController.m
//  SyncDownLoadImg
//
//  Created by ShenYj on 16/8/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "ViewController.h"
#import "JSAppsTableController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

// 设置视图
- (void)prepareView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"应用列表" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem:)];
}

- (void)clickRightBarButtonItem:(id)sender{
    
    JSAppsTableController *appsListController = [[JSAppsTableController alloc] initWithFileName:@"apps"];
    appsListController.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:appsListController animated:YES];
}

/*
 
 注意点及细节处理:
 1. 耗时操作放在子线程:下载操作如果耗时较长,在主线程执行就会卡死主界面
 2. 设置占位图:由于异步执行下载图片,在设置图片前Cell的数据源方法已经执行完毕,Cell的ImageView的frame为零,就会导致图片框不显示,滚动和点击Cell后显示图片
 3. 图片缓存池:避免移动网络下重复下载图片,对已经下载的图片进行缓存处理,当刷新Cell时,从内存获取图片,执行效率更高,并且节省流量
                放在模型中的缺点是当内存紧张时,不方便清理缓存图片
 4. 操作缓存池: 防止同一张图片多次下载
 5. Cell图片混乱: 当异步操作耗时足够长,快速滚动Cell时,会从缓存池中获取Cell,这时的Cell中可能有未执行完的任务而导致图片换乱,解决办法就是在主线以无动画的方式程刷新TableView,而不是根据下载好的图片进行赋值(在刷新UI前,图片肯定已经下载完成并进行了缓存,刷新后会从缓存中提取图片)
 6. 沙盒本地缓存图片
 7. 使用block时注意循环引用问题
 
 */

@end
