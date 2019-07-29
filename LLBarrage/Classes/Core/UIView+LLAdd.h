//
//  UIView+LLAdd.h
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LLAdd)

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize  size;

//四周切圆角
- (void )clipAllRoundCorner:(CGFloat)cornerRadius;

//切一个边或多个边圆角
-(void)clipCorner:(CGFloat)cornerRadius
       andTopLeft:(BOOL)topLeft
      andTopRight:(BOOL)topRight
    andBottomLeft:(BOOL)bottomLeft
   andBottomRight:(BOOL)bottomRight;

@end

NS_ASSUME_NONNULL_END
