//
//  UIColor+Expanded.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/15.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Expanded)

/**
 *  从十六进制字符串获取颜色，支持#开头
 */
+ (UIColor *)ly_colorWithHexString:(NSString *)color;

@end

NS_ASSUME_NONNULL_END
