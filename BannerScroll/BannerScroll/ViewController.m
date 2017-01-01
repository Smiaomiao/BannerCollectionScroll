//
//  ViewController.m
//  BannerScroll
//
//  Created by 杜菲 on 2016/12/30.
//  Copyright © 2016年 杜菲. All rights reserved.
//

#import "ViewController.h"
#import "TopScrollBannerView.h"

@interface ViewController ()<BannerScrollChooseDelegate>

@property (nonatomic, strong) TopScrollBannerView *topScrollBanner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.topScrollBanner];
    [self.topScrollBanner setBannerCollectionWithImg:@[@"news.jpg",@"news.jpg"]];
}

- (void)bannerViewDidClicked:(NSUInteger)index{
    NSLog(@"%ld",(long)index);
}

- (TopScrollBannerView *)topScrollBanner{
    if (!_topScrollBanner) {
        _topScrollBanner = [[TopScrollBannerView alloc]init];
        _topScrollBanner.frame = CGRectMake(0, 0, KScreenWidth, 150);
        _topScrollBanner.delegate = self;
    }
    return _topScrollBanner;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
