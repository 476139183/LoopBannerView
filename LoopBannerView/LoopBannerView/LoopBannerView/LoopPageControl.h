//
//  LoopPageControl.h
//  Nanyiku
//
//  Created by 高飞研发 on 17/4/10.
//  Copyright © 2017年 Gaofei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopPageControl : UIControl

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, strong) UIColor * pageIndicatorColor;
@property (nonatomic, strong) UIColor * currentPageIndicatorColor;
@property (nonatomic, assign) NSInteger currentPage;

- (instancetype)initWithFrame:(CGRect)frame
              indicatorMargin:(CGFloat)margin
               indicatorWidth:(CGFloat)indicatorWidth
        currentIndicatorWidth:(CGFloat)currentIndicatorWidth
              indicatorHeight:(CGFloat)indicatorHeight;

@end
