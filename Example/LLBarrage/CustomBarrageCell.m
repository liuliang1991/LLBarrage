//
//  CustomBarrageCell.m
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import "CustomBarrageCell.h"
#import "CustomBarrageModel.h"
#import "UIView+LLAdd.h"
#import "NSString+LLAdd.h"
@implementation CustomBarrageCell

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
        [self configUI];
    }
    return self;
}

- (void)setModel:(CustomBarrageModel *)model{
    _model = model;
    self.contentLab.text= model.content;
    CGFloat contentWidth = [model.content widthForFont:self.contentLab.font];
    self.bgBlackView.frame = CGRectMake(0, 4.0, 35.0 + contentWidth, 24.0);
    self.contentLab.frame = CGRectMake(26.0, 0, contentWidth, 24.0);
    self.contentView.size =  CGSizeMake(35.0 + contentWidth, 32.0);
}

- (void)configUI{
    [self.contentView addSubview:self.bgBlackView];
    [self.bgBlackView addSubview:self.iconImgView];
    [self.bgBlackView addSubview:self.contentLab];
    self.iconImgView.frame = CGRectMake(3.0, 2.0, 20.0, 20.0);
    [self.iconImgView clipAllRoundCorner:10.0];
}

- (UIImageView *)iconImgView{
    if(!_iconImgView){
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"placeholder_icon"];
        _iconImgView = imgView;
    }
    return _iconImgView;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        UILabel *lab = [UILabel new];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:12.f];
        _contentLab = lab;
    }
    return _contentLab;
}

- (UIView *)bgBlackView{
    if(!_bgBlackView){
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        view.layer.cornerRadius = 13.0;
        _bgBlackView = view;
    }
    return _bgBlackView;
}


@end
