//
//  ViewController.m
//  LoopBannerView
//
//  Created by Yutian Duan on 2018/11/12.
//  Copyright © 2018年 Wanwin. All rights reserved.
//

#import "ViewController.h"
#import "LoopBannerView.h"

#import "LoopBannerPage.h"

@interface ViewController () <LoopBannerView> {
  UIImageView *tempImageView;
  LoopBannerPage *page;
}

@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  
  tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
  
  [self.view addSubview:tempImageView];
  
  // blur效果  iOS8+
  UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
  visualEfView.frame = tempImageView.bounds;
  visualEfView.alpha = 0.5;
  [tempImageView addSubview:visualEfView];

  
  
  self.imageArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg"];
 
  
  //! 轮播
  LoopBannerView *bannerView = [[LoopBannerView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width * 0.43)];
  bannerView.placeholderImage = [UIImage imageNamed:@""];
  bannerView.delegate = self;
  [self.view addSubview:bannerView];

  bannerView.imageArray = self.imageArray;

  
  //！扁平化page
  page = [[LoopBannerPage alloc] init];
  page.frame = CGRectMake(100, self.view.frame.size.height - 50, 100, 20);
  page.countBtnW = 100;
  [self.view addSubview:page];
  
  
}


#pragma mark - LoopBannerView

#pragma mark -
- (void)loopBannerView:(LoopBannerView *)bannerView didSelectItem:(NSInteger)index {
  NSLog(@"点击cell=%zi",index);
}

- (void)loopBannerview:(LoopBannerView *)bannerView didScrollItem:(NSInteger)index {
  tempImageView.image = [UIImage imageNamed:self.imageArray[index]];
}

@end
