//
//  NSString+LLAdd.h
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (LLAdd)

- (CGFloat)widthForFont:(UIFont *)font ;

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
