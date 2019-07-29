//
//  CustomBarrageCell.h
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import "LLBarrageCell.h"

NS_ASSUME_NONNULL_BEGIN
@class CustomBarrageModel;
@interface CustomBarrageCell : LLBarrageCell
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIView *bgBlackView;
@property (nonatomic, strong) CustomBarrageModel *model;
@end

NS_ASSUME_NONNULL_END
