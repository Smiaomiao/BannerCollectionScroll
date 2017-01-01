//
//  TopScrollBannerView.h
//  wanChai
//
//  Created by 杜菲 on 2016/12/27.
//  Copyright © 2016年 杜菲. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WSelf           __weak typeof(self) wself = self
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height
#define DefaultRedColor [UIColor redColor]
#define WhiteColor [UIColor whiteColor]
#define PlaceHolderImg @"2-5"

@protocol BannerScrollChooseDelegate <NSObject>
@optional
-(void)bannerViewDidClicked:(NSUInteger)index;
@end

@interface TopScrollBannerView : UIView

@property (nonatomic, weak) id <BannerScrollChooseDelegate> delegate;

- (void)setBannerCollectionWithImg:(NSArray *)imageArr;

@end
