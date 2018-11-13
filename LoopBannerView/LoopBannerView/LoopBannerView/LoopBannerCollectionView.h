//
//  LoopBannerCollectionView.h
//  Nanyiku
//
//  Created by 高飞研发 on 2017/11/6.
//  Copyright © 2017年 Gaofei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopBannerCollectionView : UICollectionView
//! 上下触摸
@property (nonatomic, copy) void(^didScorllBlock)(CGFloat offsetY);

@end
