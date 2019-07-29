//
//  LLViewController.m
//  LLBarrage
//
//  Created by liuliang on 07/29/2019.
//  Copyright (c) 2019 liuliang. All rights reserved.
//

#import "LLViewController.h"
#import "LLBarrageRenderView.h"
#import "CustomBarrageCell.h"
#import "TextBarrageCell.h"
#import "CustomBarrageModel.h"
#import "NSString+LLAdd.h"
@interface LLViewController ()<BarrageDataSource>
@property (nonatomic, strong) LLBarrageRenderView *renderView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, assign) NSInteger hasShowedNum;
@end

@implementation LLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self addControlButton];
    [self.view addSubview:self.numLab];
    self.numLab.frame = CGRectMake(10.0,CGRectGetHeight(self.view.frame)-150.0 , 200.0, 30.0);
    
    //添加弹幕画布
    self.renderView = [[LLBarrageRenderView alloc]initWithFrame:CGRectMake(0, 100.0, [UIScreen mainScreen].bounds.size.width, 150.0)];
    self.renderView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.renderView.dataSource = self;
    [self.view addSubview:self.renderView];
    [self.renderView registerClass:[CustomBarrageCell class] forCellReuseIdentifier:@"cell"];
    [self.renderView registerClass:[TextBarrageCell class] forCellReuseIdentifier:@"cell1"];
    self.renderView.animationDuration = 5.0;
    self.renderView.nextSpaceTime = 0.25;
    //reload data
    [self addNewData];
}

- (void)addNewData{
    NSArray *textArr = @[@"~这是个t弹幕消息~",@"哈哈哈哈哈哈哈哈哈哈😄😄～～～",@"赞👍",@"棒～",@"什么啊，孙悟空不作死，何来的至尊宝",@"g✈️❌撒俺的撒啊啊啊,何来的至尊宝"];
    if(!self.dataList){
        self.dataList = [NSMutableArray array];
    }
    [self.dataList addObjectsFromArray:textArr];
    [self.renderView addBarragesNum:textArr.count];
    
    self.numLab.text = [NSString stringWithFormat:@"总数 :%ld,已展示：%ld ",self.renderView.totalBarrages,self.hasShowedNum];
}

- (void)startBarrage{
    [self.renderView start];
}

- (void)pasueBarrage{
    [self.renderView pause];
}

- (void)resumeBarrage{
    [self.renderView resume];
}

- (void)stopBarrage{
    [self.renderView stop];
}



- (CGSize)renderView:(LLBarrageRenderView *)renderView sizeAtIndex:(NSInteger)index{
    NSString *text = self.dataList[index];
    if(index % 2){
        CGFloat contentWidth = [text widthForFont:[UIFont systemFontOfSize:12.f]];
        return CGSizeMake( contentWidth + 35.0, 32.0);
    }else{
        CGFloat contentWidth = [text widthForFont:[UIFont systemFontOfSize:14.f]];
        return CGSizeMake( contentWidth + 10.0, 30.0);
    }
    
}

- (LLBarrageCell *)renderView:(LLBarrageRenderView *)renderView cellAtIndex:(NSInteger)index{
    self.hasShowedNum = index+1;
    self.numLab.text = [NSString stringWithFormat:@"总数 :%ld,已展示：%ld ",self.renderView.totalBarrages,self.hasShowedNum];
    if(index%2){
        CustomBarrageCell *barrage = [renderView dequeueReusableCellWithIdentifier:@"cell"];
        CustomBarrageModel *model = [CustomBarrageModel new];
        model.content = self.dataList[index];
        barrage.model = model;
        return barrage;
    }else{
        TextBarrageCell *textbarrage =  [renderView dequeueReusableCellWithIdentifier:@"cell1"];
        textbarrage.text = self.dataList[index];
        return textbarrage;
    }
}


- (void)addControlButton{
    CGFloat originY = CGRectGetHeight(self.view.frame) - 100.0;
    
    UIButton *button = [self button:@"开始" action:@selector(startBarrage)];
    button.frame= CGRectMake(10.0, originY, 50.0, 40.0);
    [self.view addSubview:button];
    
    UIButton *button2 = [self button:@"暂停" action:@selector(pasueBarrage)];
    button2.frame= CGRectMake(CGRectGetMaxX(button.frame)+10.0, originY, 50.0, 40.0);
    [self.view addSubview:button2];
    
    UIButton *button3 = [self button:@"继续" action:@selector(resumeBarrage)];
    button3.frame= CGRectMake(CGRectGetMaxX(button2.frame)+10.0, originY, 50.0, 40.0);
    [self.view addSubview:button3];
    
    UIButton *button4 = [self button:@"停止" action:@selector(stopBarrage)];
    button4.frame= CGRectMake(CGRectGetMaxX(button3.frame)+10.0, originY, 50.0, 40.0);
    [self.view addSubview:button4];
    
    UIButton *button5 = [self button:@"添加新数据" action:@selector(addNewData)];
    button5.frame= CGRectMake(CGRectGetMaxX(button4.frame)+10.0, originY, 100.0, 40.0);
    [self.view addSubview:button5];
}

- (UIButton *)button:(NSString *)title action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor orangeColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)numLab{
    if(!_numLab){
        UILabel *lab = [UILabel new];
        lab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont monospacedDigitSystemFontOfSize:14.f weight:UIFontWeightRegular];
        _numLab = lab;
    }
    return _numLab;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
