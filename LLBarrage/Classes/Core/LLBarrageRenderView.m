//
//  LLBarrageRenderView.m
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import "LLBarrageRenderView.h"
#import "UIView+LLAdd.h"
#import "NSTimer+LLAdd.h"
#import "LLBarrageCell.h"
@interface LLBarrageRenderView ()
{
    dispatch_semaphore_t _barragesNumChangedLock;
    dispatch_semaphore_t _multipleBarrageCellsLock;
}
//定时器，定时处理移出屏幕的弹幕
@property (nonatomic, strong) NSTimer *timer;
//画布状态
@property (nonatomic, assign,readwrite) LLBarrageRenderStatus renderStatus;

@property (nonatomic, strong) NSMutableArray<LLBarrageCell *> *barrageCellArr;
//记录弹幕总数
@property (nonatomic, assign ,readwrite) NSUInteger totalBarrages;

//当前出现在画布上的弹幕下标
@property (nonatomic, assign) NSInteger index;
//产生下一个弹幕的时间间隔
@property (nonatomic, assign) CGFloat stepTime;

@property (nonatomic, assign) CFTimeInterval pasueMediaTime;

@property (nonatomic, strong) NSMutableDictionary *idAndClassDic;
@property (nonatomic, strong) NSMutableDictionary *idAndCellsDic;

@end

@implementation LLBarrageRenderView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _barragesNumChangedLock = dispatch_semaphore_create(1);
        _multipleBarrageCellsLock = dispatch_semaphore_create(1);
        _barrageCellArr = [NSMutableArray array];
        _idAndClassDic = [NSMutableDictionary dictionary];
        _idAndCellsDic = [NSMutableDictionary dictionary];
        _minHorizontalSpace = 10.0;
        _animationDuration = 10.0;
        _nextSpaceTime = 0.5;
        _stepTime = _nextSpaceTime;
    }
    return self;
}

- (void)setDataSource:(id)dataSource{
    _dataSource = dataSource;
}

- (void)addBarragesNum:(NSUInteger )num{
    dispatch_semaphore_wait(_barragesNumChangedLock, DISPATCH_TIME_FOREVER);
    self.totalBarrages += num;
    dispatch_semaphore_signal(_barragesNumChangedLock);
}

- (void)start{
    switch (self.renderStatus) {
        case BarrageRenderStarted:
            return;
            break;
        case BarrageRenderPaused:
        {
            [self stop];
            [self start];
            return;
        }
            break;
        case BarrageRenderResumed:
        {
            [self stop];
            [self start];
            return;
        }
            break;
            
        default:
            break;
    }
    self.renderStatus = BarrageRenderStarted;
    [self beginTimer];
    self.index = 0;
    [self addBarrageToRender];
}

- (void)pause{
    switch (self.renderStatus) {
        case BarrageRenderPaused:
        {
            return;
        }
            break;
        case BarrageRenderStoped:
        {
            return;
        }
            break;
        default:
            break;
    }
    self.renderStatus = BarrageRenderPaused;
   
    for (UIView *barrageCell in self.barrageCellArr) {
        CALayer *layer = barrageCell.layer;
        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.speed = 0.0;
        layer.timeOffset = pausedTime;
    }
    
    self.pasueMediaTime = CACurrentMediaTime();
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addBarrageToRender) object:nil];
}

- (void)resume{
    switch (self.renderStatus) {
        case BarrageRenderStarted:
            return;
            break;
        case BarrageRenderResumed:
        {
            return;
        }
            break;
        case BarrageRenderStoped:
        {
            [self start];
        }
            break;
            
        default:
            break;
    }
    self.renderStatus = BarrageRenderResumed;
    for (UIView *barrageCell in self.barrageCellArr) {
        CALayer *layer = barrageCell.layer;
        CFTimeInterval pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
    }
    CFTimeInterval diff = CACurrentMediaTime() - self.pasueMediaTime;
    if(diff > self.stepTime){
        self.stepTime = 0;
    }else{
        self.stepTime -= diff;
    }
    [self performSelector:@selector(addBarrageToRender) withObject:nil afterDelay:self.stepTime];
}

- (void)stop{
    switch (self.renderStatus) {
        case BarrageRenderStoped:
        {
            return;
        }
            break;
        default:
            break;
    }
    self.renderStatus = BarrageRenderStoped;
    [self stopTimer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addBarrageToRender) object:nil];
    for (UIView *barrageCell in self.barrageCellArr) {
        [barrageCell removeFromSuperview];
    }
    [self.barrageCellArr removeAllObjects];
}


//添加barrage，如果数量已经超过 self.totalBarrages 则等待
- (void)addBarrageToRender{
    self.stepTime = _nextSpaceTime;
    [self performSelector:@selector(addBarrageToRender) withObject:nil afterDelay:self.stepTime];
    if( self.index >= self.totalBarrages ){
        return;
    }
    CGSize barrageSize = [self.dataSource renderView:self sizeAtIndex:self.index];
    if(barrageSize.width == 0 ||
       barrageSize.height == 0){
        return;
    }
    NSMutableArray *tunnels = [NSMutableArray array];
    NSInteger tunnelCount = (NSInteger)(self.height/barrageSize.height);
    //碰撞处理
    for (NSInteger i = 0; i<tunnelCount; i++) {
        BOOL hasBarrage = NO;
        CGFloat pointX = self.width;
        CGFloat pointY = barrageSize.height * i;
        CGRect  barrageFrame = CGRectMake(pointX, pointY, barrageSize.width, barrageSize.height);
        for (NSInteger j = _barrageCellArr.count-1 ; j>=0; j--) {
            UIView *barrageCell = _barrageCellArr[j];
            CALayer *presentationLayer = barrageCell.layer.presentationLayer;
            hasBarrage = CGRectIntersectsRect(barrageFrame, presentationLayer.frame);
            if(hasBarrage){
                break;
            }
        }
        if(!hasBarrage){
            [tunnels addObject:@(i)];
        }
    }
    
    NSInteger tunnelIndex ;
    if(tunnels.count){
        if(tunnels.count == 1){
            tunnelIndex = [tunnels[0] integerValue];
        }else{
            tunnelIndex = [tunnels[arc4random()%(tunnels.count-1)] integerValue];
        }
    }else{
        //没有可用轨道
        return;
    }
//    NSLog(@"tunnel index: %ld",tunnelIndex);
    LLBarrageCell *barrageCell = [self.dataSource renderView:self cellAtIndex:self.index];
    NSCAssert(barrageCell, @"has no barrageCell");
    [self addSubview:barrageCell];
    [self.barrageCellArr addObject:barrageCell];
    barrageCell.frame = CGRectMake(self.width+self.minHorizontalSpace, tunnelIndex * barrageSize.height, barrageSize.width, barrageSize.height);
    [self addAnimationToBarrageView:barrageCell];
    NSLog(@"展示第 <%ld> 个 barrage ",self.index+1);
    self.index ++;
}

//给 BarrageCell 添加动画
- (void)addAnimationToBarrageView:(UIView *)barrageView{
    CGPoint startCenter = barrageView.center;
    CGPoint endCenter = CGPointMake(-(CGRectGetWidth(barrageView.bounds)), barrageView.center.y);
    NSString *keyPath = @"position";
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = @(startCenter);
    animation.toValue = @(endCenter);
    animation.duration = (startCenter.x-endCenter.x)/self.bounds.size.width * self.animationDuration;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [barrageView.layer addAnimation:animation forKey:keyPath];
}


//检查已移出屏幕外的 BarrageCell，将其添加到复用列表中
- (void)checkMoveOutBarrages{
    CGFloat height = 0;
    NSMutableArray *removedCellArr = [NSMutableArray array];
    for (NSInteger i = 0; i<self.barrageCellArr.count; i++) {
        LLBarrageCell *barrageCell = self.barrageCellArr[i];
        CALayer *presentationLayer = barrageCell.layer.presentationLayer;
        if(presentationLayer.frame.origin.x + presentationLayer.frame.size.width <= 0){
            [barrageCell removeFromSuperview];
            [removedCellArr addObject:barrageCell];
            NSString *identifier = barrageCell.identifier;
            NSMutableArray *cellArr = [self.idAndCellsDic objectForKey:identifier];
            //控制每种cell的复用池数据最多5个
            if(cellArr.count<5){
                dispatch_semaphore_wait(_multipleBarrageCellsLock, DISPATCH_TIME_FOREVER);
                [cellArr addObject:barrageCell];
                dispatch_semaphore_signal(_multipleBarrageCellsLock);
            }
        }
        height += presentationLayer.frame.size.height;
        if(height>=self.height){
            break;
        }
    }
     [self.barrageCellArr removeObjectsInArray:removedCellArr];
}

- (void)beginTimer{
    [self stopTimer];
    __weak typeof (self)weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        [weakSelf checkMoveOutBarrages];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc{
    NSLog(@"delloc：%@",NSStringFromClass([self class]));
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addBarrageToRender) object:nil];
    [self stopTimer];
}


- (nullable id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    Class cellClass = [self.idAndClassDic objectForKey:identifier];
    if(!cellClass){
        return nil;
    }
    LLBarrageCell *cell = nil;
    NSMutableArray *cellArr = [self.idAndCellsDic objectForKey:identifier];
    if(cellArr.count){
        cell = [cellArr firstObject];
        dispatch_semaphore_wait(_multipleBarrageCellsLock, DISPATCH_TIME_FOREVER);
        [cellArr removeObject:cell];
        dispatch_semaphore_signal(_multipleBarrageCellsLock);
    }else{
        cell = [cellClass new];
    }
    cell.identifier = identifier;
    return cell;
}


- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier{
    [self.idAndClassDic setObject:cellClass forKey:identifier];
    NSMutableArray *cellArr = [self.idAndCellsDic objectForKey:identifier];
    if(cellArr.count){
        [cellArr removeAllObjects];
    }else{
        NSMutableArray *newCellArr = [NSMutableArray array];
        LLBarrageCell *cell = [cellClass new];
        [newCellArr addObject:cell];
        [self.idAndCellsDic setObject:newCellArr forKey:identifier];
    }
}

@end
