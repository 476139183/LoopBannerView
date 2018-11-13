//
//  LoopBannerPage.m
//  平移视差滚动
//
//  Created by duanyutian on 16/12/8.
//  Copyright © 2016年 高飞研发. All rights reserved.
//

#import "LoopBannerPage.h"

@interface LoopGressButton : UIButton

@property (nonatomic,strong) CALayer *progressLayer;
@property (nonatomic,assign) CGFloat currentViewWidth;

@end

@implementation LoopGressButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
  LoopGressButton * btn = [super buttonWithType:buttonType];
  if (btn) {
    btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
//    [btn setLayer];
  }
  return btn;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  self.currentViewWidth = frame.size.width;
}

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  if (selected) {
    self.backgroundColor = [UIColor whiteColor];
  } else {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
  }
//  [self setNeedsLayout];
}

- (void)setLayer {
  self.progressLayer = [CALayer layer];
  self.progressLayer.backgroundColor = [UIColor whiteColor].CGColor;
  self.progressLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
  [self.layer addSublayer:self.progressLayer];
}

// 开始出现渐变
- (void)startPoregress:(CGFloat)progress {
  if (progress <= 0) {
    self.progressLayer.frame = CGRectMake(0, 0, 0, self.frame.size.height);
  } else if (progress <= 1) {
    self.progressLayer.frame = CGRectMake(0, 0, progress *self.currentViewWidth, self.frame.size.height);
  } else {
    self.progressLayer.frame = CGRectMake(0, 0, self.currentViewWidth, self.frame.size.height);
  }
}

// 开始结束渐变
- (void)stopProgress:(CGFloat)progress {
  if (progress <= 0) { // 准备渐变出去
    self.progressLayer.frame = CGRectMake(0, 0, self.currentViewWidth, self.frame.size.height);
  } else if (progress <= 1) {
    self.progressLayer.frame = CGRectMake(progress *self.currentViewWidth, 0, (1-progress) *self.currentViewWidth, self.frame.size.height);
  } else { // 完全渐变出去
    self.progressLayer.frame = CGRectMake(0,0, 0, self.frame.size.height);
  }
}

//! 开始回退渐变
- (void)startBackProgress:(CGFloat)progress {
  if (progress <= 0) { // 准备渐变回来
    self.progressLayer.frame = CGRectMake(self.currentViewWidth, 0, 0, self.frame.size.height);
  } else if (progress <= 1) {
    self.progressLayer.frame = CGRectMake((1-progress) *self.currentViewWidth, 0,progress *self.currentViewWidth, self.frame.size.height);
  } else { //
    self.progressLayer.frame = CGRectMake(0, 0, self.currentViewWidth, self.frame.size.height);
  }

}

//! 开始结束回退渐变
- (void)stopBackProgress:(CGFloat)progress {
  if (progress <= 0) { // 准备渐变回来
    self.progressLayer.frame = CGRectMake(0, 0, self.currentViewWidth, self.frame.size.height);
  } else if (progress <= 1) {
    self.progressLayer.frame = CGRectMake(0, 0, (1-progress) *self.currentViewWidth, self.frame.size.height);
  } else { //
    self.progressLayer.frame = CGRectMake(0,0,0, self.frame.size.height);
  }
}


@end


@interface LoopBannerPage () {
  NSInteger VC_ImageCount;
  
  
  NSInteger tempPage;
  UIButton *tempBtn;
  CGRect tempFrame;
  CGFloat interval;
  
  LoopGressButton *oldButton;
  LoopGressButton *newButton;

  
  
}

@end

@implementation LoopBannerPage

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    tempFrame = frame;
    [self setDefult];
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setDefult];
  }
  return self;
}

- (void)setDefult {
  VC_ImageCount = 5;
  _countBtnW = 16;
  interval = 4;
}

- (void)createViews {
  // 间距离
  for (LoopGressButton *button  in self.subviews) {
    if ([button isKindOfClass:[LoopGressButton class]] && button.tag >=200) {
      [button removeFromSuperview];
    }
  }
  
  UIButton *tempButton = nil;
  for (int i = 0; i < VC_ImageCount; i++) {
    LoopGressButton *button = [LoopGressButton buttonWithType:UIButtonTypeCustom];
    if (tempButton == nil) {
      button.frame = CGRectMake(0 + interval, tempFrame.size.height - 3,_countBtnW, 2);
    } else {
      button.frame = CGRectMake(CGRectGetMaxX(tempButton.frame) + interval , tempFrame.size.height - 3,_countBtnW, 2);
    }
    button.tag = i + 200;
    [button setLayer];
    [self addSubview:button];
    if (i == self.currentI) {
      button.selected = YES;
      oldButton = button;
//      [button startPoregress:1.0f];
    }
    tempButton = button;
  }
}

//! 需要添加填充特效
- (void)Join:(LoopGressButton *)sender {
  [sender startPoregress:1.0f];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
//  [super numberOfPages];
  VC_ImageCount = numberOfPages;
  [self createViews];
}

- (void)setCurrentPage:(NSInteger)currentPage {
  [super setCurrentPage:currentPage];

//  NSLog(@" 当前  %ld",(long)currentPage);
//  if (currentPage != self.currentI) {
//    LoopGressButton *button = (LoopGressButton *)[self viewWithTag:200 + currentPage];
//    oldButton = button;
//    _currentI = currentPage;
//    
//    for (LoopGressButton *tempButton  in self.subviews) {
//      if ([tempButton isKindOfClass:[LoopGressButton class]] && tempButton.tag >=200) {
//        if (tempButton != button) {
//          [tempButton startPoregress:0.0f];
//          tempButton.progressLayer.hidden = YES;
//        }
//      }
//    }
//    
//  }
  
}

- (void)setCurrentI:(NSInteger)currentI {
  _currentI = currentI;
  for (LoopGressButton *tempButton  in self.subviews) {
    if (tempButton.tag >= 200 ) {
      if (tempButton.tag == 200+currentI) {
        tempButton.selected = YES;
      } else {
        tempButton.selected = NO;
      }
    }
  }
  
}

//FIXME:滑动有Bug
- (void)chageValueWithProgress:(CGFloat)progress
                       andType:(PageBannerTransition)type {
  if (type == PageRight) {
    
    if (oldButton.tag-200 == VC_ImageCount-1) {
      //正常滑动方向
      newButton = (LoopGressButton *)[self viewWithTag:200];
    } else {
      newButton = (LoopGressButton *)[self viewWithTag:oldButton.tag+1];
    }
    [oldButton stopProgress:progress];
    [newButton startPoregress:progress];

  } else { //  向左滑动<或是滑到最后一个时候,下一个替换到第一个>
    // 此时 oldButton 为即将显示的index 当前 的变为newbutton

    if (oldButton.tag == 200+VC_ImageCount-1) {
      // 说明是从最后一个滑动第一个,此时获取当前page
      newButton = (LoopGressButton *)[self viewWithTag:200];
      [oldButton startBackProgress:1-progress];
      
      [newButton stopBackProgress:1-progress];

    } else {
      // 正常回退
      
      newButton = (LoopGressButton *)[self viewWithTag:oldButton.tag+1];
      
      [oldButton startBackProgress:1-progress];
      
      [newButton stopBackProgress:1-progress];
      
    }


    
    //正常滑动方向
//    if (oldButton.tag-200 == self.numberOfPages-1) {
//      newButton = (LoopGressButton *)[self viewWithTag:200];
//    } else {
//      newButton = (LoopGressButton *)[self viewWithTag:oldButton.tag+1];
//    }

//    if (oldButton.tag-200 == 0) {
//      newButton = (LoopGressButton *)[self viewWithTag:oldButton.tag-1];
//    } else {
//      newButton = (LoopGressButton *)[self viewWithTag:oldButton.tag+1];
//    }
//    NSLog(@"进度 和===%f",progress);
//    NSLog(@"oldButton==%d",oldButton.tag);
  }
  
  if (oldButton.progressLayer.hidden == YES) {
    oldButton.progressLayer.hidden = NO;
  }
  
  if (newButton.progressLayer.hidden == YES) {
    newButton.progressLayer.hidden = NO;
  }
  
}


- (void)chageView {
  
  
  [oldButton stopProgress:self.myProgress];
  
//  [newButton startPoregress:self.myProgress];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  tempFrame = frame;
  [self createViews];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
  CGSize size = [super sizeForNumberOfPages:pageCount];
  size.width = (_countBtnW + interval) * VC_ImageCount + interval;
  return size;
}


@end
