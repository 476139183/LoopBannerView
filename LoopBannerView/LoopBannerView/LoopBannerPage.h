//
//  LoopBannerPage.h
//  平移视差滚动
//  扁平化 PageControl
//  Created by duanyutian on 16/12/8.
//  Copyright © 2016年 高飞研发. All rights reserved.
//

#import <UIKit/UIKit.h>

//! page的滑动方向
typedef enum {
  PageRight = 0, // 向右<正常>
  PageLeft = 1  // 向左
} PageBannerTransition;


@interface LoopBannerPage : UIPageControl

//! 宽度
@property (nonatomic, assign) CGFloat countBtnW;
@property (nonatomic, assign) CGFloat myProgress;
//! 当前的index
@property (nonatomic, assign) NSInteger currentI;


/**
 *  设置进度
 *
 *  @param progress 进度 0-1
 *  @param type     方向
 */
- (void)chageValueWithProgress:(CGFloat)progress andType:(PageBannerTransition)type;

@end
