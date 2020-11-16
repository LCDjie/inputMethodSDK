//
//  UIImage+Common.m
//  RelievedInputMethod
//
//  Created by 蒋泽康 on 2020/8/27.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "UIImage+Common.h"

@implementation UIImage (Common)

//MARK: - 属性
- (BOOL)qmui_opaque {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = alphaInfo == kCGImageAlphaNoneSkipLast
    || alphaInfo == kCGImageAlphaNoneSkipFirst
    || alphaInfo == kCGImageAlphaNone;
    return opaque;
}

//MARK: - 方法
+ (UIImage *)rl_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)rl_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    color = color ? color : UIColor.clearColor;
    CGFloat a = 0;
    if ([color getRed:0 green:0 blue:0 alpha:&a]) {
    } else {
        a = 0;
    }
    BOOL opaque = (cornerRadius == 0.0 && a == 1.0);
    return [UIImage rl_imageWithSize:size opaque:opaque scale:0 actions:^(CGContextRef contextRef) {
        CGContextSetFillColorWithColor(contextRef, color.CGColor);
        
        if (cornerRadius > 0) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
            [path addClip];
            [path fill];
        } else {
            CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height));
        }
    }];
}

+ (UIImage *)rl_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale actions:(void (^)(CGContextRef contextRef))actionBlock {
    if (!actionBlock || size.width <= 0 || size.height <= 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    actionBlock(context);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}

- (UIImage *)rl_imageWithTintColor:(UIColor *)tintColor {
    CGFloat a = 0;
    if ([tintColor getRed:0 green:0 blue:0 alpha:&a]) {
    } else {
        a = 0;
    }
    BOOL opaque = self.qmui_opaque ? a >= 1.0 : NO;// 如果图片不透明但 tintColor 半透明，则生成的图片也应该是半透明的
    return [UIImage rl_imageWithSize:self.size opaque:opaque scale:self.scale actions:^(CGContextRef contextRef) {
        CGContextTranslateCTM(contextRef, 0, self.size.height);
        CGContextScaleCTM(contextRef, 1.0, -1.0);
        CGContextSetBlendMode(contextRef, kCGBlendModeNormal);
        CGContextClipToMask(contextRef, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
        CGContextSetFillColorWithColor(contextRef, tintColor.CGColor);
        CGContextFillRect(contextRef, CGRectMake(0, 0, self.size.width, self.size.height));
    }];
}

@end
