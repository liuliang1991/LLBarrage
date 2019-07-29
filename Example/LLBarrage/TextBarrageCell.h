//
//  TextBarrageCell.h
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import "LLBarrageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextBarrageCell : LLBarrageCell
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, copy  ) NSString *text;
@end

NS_ASSUME_NONNULL_END
