//
//  UIImage+Common.h
//  NiudunInputMethod
//
//  Created by 一大口内涵 on 2018/11/30.
//  Copyright © 2018年 芯盾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Common)

/**
 *  创建一个纯色的UIImage
 *  @param  color           图片的颜色
 */
+ (UIImage *)rl_imageWithColor:(UIColor *)color;

/**
 *  创建一个纯色的UIImage
 *
 *  @param  color           图片的颜色
 *  @param  size            图片的大小
 *  @param  cornerRadius    图片的圆角
 *
 * @return 纯色的UIImage
 */
+ (UIImage *)rl_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/**
 *  保持当前图片的形状不变，使用指定的颜色去重新渲染它，生成一张新图片并返回
 *
 *  @param tintColor 要用于渲染的新颜色
 *
 *  @return 与当前图片形状一致但颜色与参数tintColor相同的新图片
 */
- (nullable UIImage *)rl_imageWithTintColor:(nullable UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
