//
//  LoopBannerView.m
//  平移视差滚动
//
//  Created by duanyutian on 16/12/8.
//  Copyright © 2016年 高飞研发. All rights reserved.
//

#import "LoopBannerView.h"

#import "LoopBannerView.h"
#import <objc/message.h>

#import "LoopBannerCell.h"
#import "LoopPageControl.h"
#import "LoopBannerCollectionView.h"

#if __has_include(<YYWebImage/YYWebImage.h>)
#import "YYWebImage.h"
#elif __has_include(<SDWebImage/SDWebImage.h>)
#import "SDWebImage.h"
#endif

static NSString *const LoopImageCellId = @"LoopImageCell";

@interface LoopBannerView () < UICollectionViewDelegate, UICollectionViewDataSource> {
  UICollectionViewFlowLayout *flowLayout;
  LoopPageControl * pageControl;
}

/** 用来显示图片的collectionView */
@property (nonatomic, strong) LoopBannerCollectionView  *collectionView;
/** 时间间隔 默认5秒*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
/** 定时器 */
@property (nonatomic, assign) CFRunLoopTimerRef timer;
/** 总page数 */
@property (nonatomic, assign) NSInteger totalPageCount;
/** 前一页的索引*/
@property (nonatomic, assign) NSInteger previousPageIndex;

/** 首次点击*/
@property (nonatomic, assign) CGFloat firstContentX;
@end

@implementation LoopBannerView

- (instancetype)init {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setDefult];
    [self createCollectionView];
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (self.totalPageCount == 0) {
    return;
  }
  
  flowLayout.itemSize = self.frame.size;
  self.collectionView.frame = self.bounds;
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.totalPageCount * 0.5
                                               inSection:0];
  [self.collectionView scrollToItemAtIndexPath:indexPath
                              atScrollPosition:UICollectionViewScrollPositionNone
                                      animated:NO];
  
  [self createPageControl];
}

- (void)removeFromSuperview {
  [self pauseTimer];
  [super removeFromSuperview];
}

- (void)setDefult {
  _transitionMode = Parallex;
  _timeInterval = 5;
  _alignment = PageControlAlignCenter;
}

//! 配置page
- (void)createPageControl {
  if (!pageControl) {
    
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.frame) - 15, CGRectGetWidth(self.frame), 10);
    pageControl = [[LoopPageControl alloc] initWithFrame:frame
                                         indicatorMargin:5.f
                                          indicatorWidth:5.f
                                   currentIndicatorWidth:14.f
                                         indicatorHeight:5];
    
    //    pageControl = [[LoopBannerPage alloc] init];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.pageIndicatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    pageControl.currentPageIndicatorColor = [UIColor whiteColor];
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    pageControl.scrollView = self.collectionView;
    
  }
  
  [self bringSubviewToFront:pageControl];
  pageControl.numberOfPages = self.imageArray.count;
  
}

- (void)createCollectionView {
  flowLayout = [[UICollectionViewFlowLayout alloc] init];
  flowLayout.itemSize = self.bounds.size;
  flowLayout.minimumLineSpacing = 0;
  flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  
  self.collectionView = [[LoopBannerCollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
  self.collectionView.backgroundColor = [UIColor lightGrayColor];
  self.collectionView.pagingEnabled = YES;
  self.collectionView.showsHorizontalScrollIndicator = NO;
  self.collectionView.showsVerticalScrollIndicator = NO;
  self.collectionView.scrollsToTop = NO;
  [self.collectionView  registerClass:[LoopBannerCell class]
           forCellWithReuseIdentifier:LoopImageCellId];
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  [self addSubview:self.collectionView];
    
}

/** 设置frame*/
- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  flowLayout.itemSize = frame.size;
}

- (void)setImageArray:(NSArray *)imageArray {
  if (![imageArray isKindOfClass:[NSArray class]]) {
    return;
  }
  
  if (imageArray == nil || imageArray.count == 0) {
    self.collectionView.scrollEnabled = NO;
    [self pauseTimer];
    self.totalPageCount = 0;
    [self.collectionView reloadData];
    return;
  }
  
  if (_imageArray != imageArray) {
    _imageArray = imageArray;
    if (imageArray.count > 1) {
      self.collectionView.scrollEnabled = YES;
      self.totalPageCount = imageArray.count * 50;
      [self startTimer];
      [self createPageControl];
    } else {
      [self pauseTimer];
      self.totalPageCount = 1;
      self.collectionView.scrollEnabled = NO;
      if (pageControl) {
        [pageControl removeFromSuperview];
      }
    }
    [self.collectionView reloadData];
  }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  self.collectionView.backgroundColor = backgroundColor;
}

- (void)setAlignment:(PageControlAlignment)alignment {
  if (_alignment != alignment) {
    _alignment = alignment;
    [self createPageControl];
    [self.collectionView reloadData];
  }
}

#pragma mark - methods
//! 停止定时
- (void)pauseTimer {
  if (self.timer) {
    CFRunLoopTimerInvalidate(self.timer);
    CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
  }
}

//! 开启定时
- (void)startTimer {
  if (self.imageArray.count <= 1) {
    return;
  }
  
  if (_timer) {
    CFRunLoopTimerInvalidate(_timer);
    CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), _timer, kCFRunLoopCommonModes);
    _timer = nil;
  }
  
  __weak __typeof(self) weakSelf = self;
  
  CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + _timeInterval, _timeInterval, 0, 0, ^(CFRunLoopTimerRef timer) {
    //    NSLog(@"定时");
    [weakSelf autoScroll];
  });
  
  self.timer = timer;
  CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
}

//! 自动滚动
- (void)autoScroll {
  
  CGPoint offset = self.collectionView.contentOffset;
  offset.x += self.collectionView.frame.size.width;
  [self.collectionView setContentOffset:offset animated:YES];
  
}

//! 重置cell的位置到中间
- (void)resetPosition {
  // 滚动完毕时，自动显示最中间的cell
  NSInteger oldItem = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
  NSInteger newItem = (_totalPageCount / 2) + (oldItem % self.imageArray.count);
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:newItem inSection:0];
  [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return self.totalPageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  LoopBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LoopImageCellId forIndexPath:indexPath];
  
  NSInteger itemIndex = indexPath.item % self.imageArray.count;
  if (itemIndex < self.imageArray.count) {
    NSString *urlString = self.imageArray[itemIndex];
    if ([urlString isKindOfClass:[UIImage class]]) {
      cell.imageView.image = (UIImage *)urlString;
    } else if ([urlString hasPrefix:@"http://"]
               || [urlString hasPrefix:@"https://"]
               || [urlString rangeOfString:@"/"].location != NSNotFound) {
      
#if __has_include(<YYWebImage/YYWebImage.h>)
      //! 网络图片
      [cell.imageView yy_setImageWithURL:[NSURL URLWithString:urlString]
                             placeholder:self.placeholderImage
                                 options:YYWebImageOptionSetImageWithFadeAnimation|YYWebImageOptionProgressiveBlur
                                progress:nil
                               transform:nil
                              completion:nil];
      
#elif __has_include(<SDWebImage/SDWebImage.h>)
      [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:self.placeholderImage options:SDWebImageProgressiveLoad progress:nil completed:nil];
#endif
      
    } else {
      if (urlString.length != 0) {
        cell.imageView.image = [UIImage imageNamed:urlString];
      } else {
        cell.imageView.image = self.placeholderImage;
      }
    }
  }
  cell.indexRow = itemIndex;
  return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.totalPageCount != 0) {
    if (_delegate && [_delegate respondsToSelector:@selector(loopBannerView:didSelectItem:)]) {
      [_delegate loopBannerView:self didSelectItem:indexPath.item%self.imageArray.count];
    }
  }
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (self.totalPageCount != 0 && scrollView == self.collectionView) {
    
    NSInteger oldItem = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    
    NSInteger newItem = (oldItem % self.imageArray.count);
    pageControl.currentPage = newItem;
    
    CGFloat x = scrollView.contentOffset.x - self.collectionView.frame.size.width;
    
    NSUInteger index = fabs(x) / self.collectionView.frame.size.width;
    
    CGFloat fIndex = fabs(x) / self.collectionView.frame.size.width;
    
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(loopBannerview:didScrollItem:)] && fabs(fIndex - (CGFloat)index) <= 0.00001) {
      [_delegate loopBannerview:self didScrollItem:newItem];
    }
    
    NSArray *visibleArray = _collectionView.visibleCells;
    for (LoopBannerCell *cell in visibleArray) {
      if ([cell isKindOfClass:[LoopBannerCell class]]) {
        [self handleEffect:cell];
      }
    }
  }
  
}

//! 停止定时器->手滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self pauseTimer];
  self.firstContentX = scrollView.contentOffset.x;
}

//! 开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [self startTimer];
}

/**
 * scrollView滚动完毕的时候调用（通过setContentOffset:animated:滚动）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  [self resetPosition];
}

/**
 * scrollView滚动完毕的时候调用（人为拖拽滚动）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self resetPosition];
}

- (void)handleEffect:(LoopBannerCell *)cell {
  switch (_transitionMode) {
      case Parallex: {
        [cell moveBackgroundImage:self.collectionView.contentOffset.x];
      }
      break;
      case Normal: {
        
      }
      break;
    default:
      break;
  }
}

@end
