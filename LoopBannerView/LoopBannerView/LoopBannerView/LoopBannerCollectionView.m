//
//  LoopBannerCollectionView.m
//  Nanyiku
//
//  Created by 高飞研发 on 2017/11/6.
//  Copyright © 2017年 Gaofei. All rights reserved.
//

#import "LoopBannerCollectionView.h"

@interface LoopBannerCollectionView () {
  CGPoint oldPoint;

}

@end

@implementation LoopBannerCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithFrame:frame collectionViewLayout:layout];
  if (self) {
    
  }
  return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  //获取触摸对象
  UITouch * touch = touches.anyObject;
  oldPoint = [touch previousLocationInView:touch.view];
  CGPoint point = [touch locationInView:touch.view];
  if (self.didScorllBlock) {
    self.didScorllBlock(oldPoint.y - point.y);
  }
}

@end
