//
//  LLBarrageRenderView.h
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,LLBarrageRenderStatus) {
    BarrageRenderStoped = 0,
    BarrageRenderStarted,
    BarrageRenderPaused,
    BarrageRenderResumed
};

@class LLBarrageRenderView,LLBarrageCell;

@protocol BarrageDataSource <NSObject>

//第index个展示的Barrage
- (LLBarrageCell *)renderView:(LLBarrageRenderView *)renderView cellAtIndex:(NSInteger )index;

//为即将展示barrage设置size
- (CGSize)renderView:(LLBarrageRenderView *)renderView sizeAtIndex:(NSInteger )index;

@end

@interface LLBarrageRenderView : UIView

@property (nonatomic, weak  ) id dataSource;

@property (nonatomic, assign, readonly) LLBarrageRenderStatus renderStatus;

@property (nonatomic, assign, readonly) NSUInteger totalBarrages;

//设置动画时间 ,default = 10.0
@property (nonatomic, assign) CGFloat animationDuration;
//设置 barrage 最小水平间距 ，default：10.0
@property (nonatomic, assign) CGFloat minHorizontalSpace;
//产生下一个 barrage 的间隔时间,这个值会作为常量使用 ， default :0.5
@property (nonatomic, assign) CGFloat nextSpaceTime;

- (nullable id )dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;


- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

- (void)addBarragesNum:(NSUInteger )num;

@end


NS_ASSUME_NONNULL_END
