//
//  TopScrollBannerView.m
//  wanChai
//
//  Created by 杜菲 on 2016/12/27.
//  Copyright © 2016年 杜菲. All rights reserved.
//


#import "TopScrollBannerView.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BannerCollectionShow : UICollectionViewCell
@property (nonatomic, strong) UIImageView * fileImg;
@end


@implementation BannerCollectionShow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self loadUI];
    }
    return self;
}
- (void)loadUI {
    WSelf;
    [self addSubview:self.fileImg];
    [self.fileImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself);
    }];
}

- (void)loadImgWithLocolImg:(UIImage *)img{
    WSelf;
    
    self.fileImg.image = img;
    
    [self.fileImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself);
    }];
}

- (void)loadImgWithModel:(NSString *)imgUrl{
    
    WSelf;
    
    [self.fileImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:PlaceHolderImg]];
    
    [self.fileImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself);
    }];
}

- (UIImageView *)fileImg{
    if (!_fileImg) {
        _fileImg = [UIImageView new];
        _fileImg.userInteractionEnabled = YES;
    }
    return _fileImg;
}

@end

@interface TopScrollBannerView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TopScrollBannerView

{
    NSMutableArray *imgArr;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)loadUI {
    
    [self layoutIfNeeded];
    
    WSelf;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself);
    }];
    
    if (imgArr.count <= 3) {
        self.pageControl.hidden = YES;
        self.collectionView.scrollEnabled = NO;
    } else {
        [self.pageControl setNumberOfPages:imgArr.count - 2];
        self.collectionView.scrollEnabled = YES;
    }
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.bottom.equalTo(wself).offset(-7);
        make.height.equalTo(@(7));
    }];
    
    if (self.timer != nil){
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (imgArr.count >= 3) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    }

    
}

- (void)runTimePage{
    
    if (imgArr.count == 3) {
        [self.timer invalidate];
        return;
    }
    
    NSInteger page = self.pageControl.currentPage;
    page++;
    
    page = page > [imgArr count]-3 ? 0 : page ;
    
    NSInteger pointNum = page == 0 ? imgArr.count - 1 : page + 1;
    
    self.pageControl.currentPage = page;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pointNum inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


- (void)setBannerCollectionWithImg:(NSArray *)imageArr{
    imgArr = [[NSMutableArray alloc]init];
    [imgArr addObject:imageArr.lastObject];
    [imgArr addObjectsFromArray:imageArr];
    [imgArr addObject:imageArr.firstObject];
    [self loadUI];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * collectionViewFlowLayout = [UICollectionViewFlowLayout new];
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        
        [_collectionView registerClass:[BannerCollectionShow class] forCellWithReuseIdentifier:@"BannerShowIdenti"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.currentPage=0;
        _pageControl.currentPageIndicatorTintColor = DefaultRedColor;
        _pageControl.pageIndicatorTintColor = WhiteColor;
    }
    return _pageControl;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self performSelector:@selector(showFirst) withObject:nil afterDelay:0.0001];
    return imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BannerCollectionShow * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BannerShowIdenti" forIndexPath:indexPath];
    
    NSString *imgStr = imgArr[indexPath.row];
    
    if ([imgStr rangeOfString:@"http://"].location != NSNotFound || [imgStr rangeOfString:@"https://"].location != NSNotFound) {
        [cell loadImgWithModel:imgArr[indexPath.row]];
    } else {
        [cell loadImgWithLocolImg:[UIImage imageNamed:imgArr[indexPath.row]]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self.delegate bannerViewDidClicked:indexPath.row];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.frame.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
// item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
// item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.pageControl.currentPage = self.collectionView.contentOffset.x/CGRectGetWidth(self.frame) - 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[self.collectionView class]]) {
        [self.timer invalidate];
    }
    if ((self.collectionView.contentOffset.x/CGRectGetWidth(self.frame)) >= imgArr.count - 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if ((self.collectionView.contentOffset.x/CGRectGetWidth(self.frame)) <= 0){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:imgArr.count-2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.timer.valid == NO) {
        [self.timer fire];
    }
}

- (void)showFirst{
    
    if ((self.collectionView.contentOffset.x/CGRectGetWidth(self.frame)) <= CGRectGetWidth(self.frame)){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    }
    
}

@end
