//
//  LoopBannerCell.h
//  平移视差滚动
//
//  Created by duanyutian on 16/12/8.
//  Copyright © 2016年 高飞研发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopBannerCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
/** 平移视差*/
@property (nonatomic, assign) CGFloat parllexSpeed;
//! 位移
- (void)moveBackgroundImage:(CGFloat)aIndex;
@end
