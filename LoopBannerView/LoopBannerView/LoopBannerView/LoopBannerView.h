//
//  LoopBannerView.h
//  平移视差滚动
//
//  Created by duanyutian on 16/12/8.
//  Copyright © 2016年 高飞研发. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoopBannerView;


//! 是否支持平移视差
typedef enum {
  Normal = 0,
  Parallex = 1
} ParallexBannerTransition;

//! page 是否居中
typedef NS_ENUM(NSInteger) {
  /**
   *  For the center type, only show the page control without any text
   */
  PageControlAlignCenter = 1 ,
  /**
   *  For the align right type, will show the page control and show the ad text
   */
  PageControlAlignRight  = 2
} PageControlAlignment;


@protocol LoopBannerView <NSObject>
/**
 *  点击的Item
 *
 *  @param bannerView loopBannerView
 *  @param index      index
 */
- (void)loopBannerView:(LoopBannerView *)bannerView didSelectItem:(NSInteger)index;
- (void)loopBannerview:(LoopBannerView *)bannerView didScrollItem:(NSInteger)index;
@end

@interface LoopBannerView : UIView

/** 需要显示的图片数据(要求里面存放UIImage\NSURL对象) */
@property (nonatomic, copy) NSArray *imageArray;

/** 下载远程图片时的占位图片 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 用来监听框架内部事件的代理 */
@property (nonatomic, weak) id<LoopBannerView> delegate;
/** 滑动类型*/
@property (nonatomic, assign) ParallexBannerTransition transitionMode;
/** 滑块位置类型*/
@property (nonatomic, assign) PageControlAlignment alignment;

- (void)startTimer;
- (void)pauseTimer;

@end
