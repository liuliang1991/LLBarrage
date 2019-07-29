//
//  TextBarrageCell.m
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import "TextBarrageCell.h"
#import "NSString+LLAdd.h"
@implementation TextBarrageCell

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
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.contentLab.text = text;
    CGFloat width = [text widthForFont:self.contentLab.font];
    self.contentLab.frame = CGRectMake(0, 10.0, width, 20.0);
    self.contentView.frame = CGRectMake(5.0, 0, width, 30.0);
}

- (UILabel *)contentLab{
    if(!_contentLab){
        UILabel *lab = [UILabel new];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14.f];
        _contentLab = lab;
    }
    return _contentLab;
}

@end
