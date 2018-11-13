//
//  LoopBannerCell.m
//  平移视差滚动
//
//  Created by duanyutian on 16/12/8.
//  Copyright © 2016年 高飞研发. All rights reserved.
//

#import "LoopBannerCell.h"


@interface LoopBannerCell ()
//! 背景
//@property (nonatomic, strong) UIView *topMaskView;

@end

@implementation LoopBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _parllexSpeed = 0.5;
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.scrollEnabled = NO;
  _scrollView.userInteractionEnabled = NO;
  [self.contentView addSubview:_scrollView];
  
  _imageView = [[UIImageView alloc] init];
  _imageView.backgroundColor = [UIColor whiteColor];
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  [_scrollView addSubview:_imageView];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  //! 修正位置
  _scrollView.contentSize = self.bounds.size;
  _scrollView.frame = self.bounds;
  _imageView.frame = _scrollView.bounds;
}

- (void)setIndexRow:(NSInteger)indexRow {
  
  _indexRow = indexRow;
  //TODO:修正偏移量误差
  self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)moveBackgroundImage:(CGFloat)aIndex {
  
  CGFloat minusX = aIndex - self.frame.origin.x;
  // _parllexSpeed
  CGFloat imageOffsetX = -minusX * _parllexSpeed;
  
  self.scrollView.contentOffset = CGPointMake(imageOffsetX, 0);

}

@end
