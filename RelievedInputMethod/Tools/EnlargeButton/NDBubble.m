//
//  NDBubble.m
//  AXKeyboard
//
//  Created by liweijie on 2020/7/17.
//  Copyright © 2020 芯盾. All rights reserved.
//

#import "NDBubble.h"

//竖屏时的屏幕宽度
#define Screen_Protrait_W (SCREEN_WIDTH > SCREEN_HEIGHT ? SCREEN_HEIGHT : SCREEN_WIDTH)

//#define ScreespecOne    (Screen_Protrait_W / (Screen_Protrait_W == 320 ? 375 : 414))
#define _UPPER_WIDTH    (50.0 * [[UIScreen mainScreen] scale])
#define _LOWER_WIDTH    (33.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPER_RADIUS   (5.0 * [[UIScreen mainScreen] scale])
#define _PAN_LOWER_RADIUS   (5.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPDER_WIDTH   (_UPPER_WIDTH-_PAN_UPPER_RADIUS*2)
#define _PAN_UPPER_HEIGHT   (45.0 * [[UIScreen mainScreen] scale])

#define _PAN_LOWER_WIDTH    (_LOWER_WIDTH-_PAN_LOWER_RADIUS*2)
#define _PAN_LOWER_HEIGHT   (40.0 * [[UIScreen mainScreen] scale])

#define _PAN_UL_WIDTH       ((_UPPER_WIDTH-_LOWER_WIDTH)/2)

#define _PAN_MIDDLE_HEIGHT  (7.0 * [[UIScreen mainScreen] scale])
#define _PAN_CURVE_SIZE     (7.0 * [[UIScreen mainScreen] scale])

#define _PADDING_X          (15 * [[UIScreen mainScreen] scale])
#define _PADDING_Y          (11 * [[UIScreen mainScreen] scale])
#define _WIDTH              (_UPPER_WIDTH + _PADDING_X*2)
#define _HEIGHT             (_PAN_UPPER_HEIGHT + _PAN_MIDDLE_HEIGHT + _PAN_LOWER_HEIGHT + _PADDING_Y*2)

/** 屏幕 */
//判断iPHoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//#define SCREEN_WIDTH   (([[UIScreen mainScreen] bounds].size.width) > SCREEN_HEIGHT && iPhoneX_All ? kLandscapeIPhoneX_Width : ([[UIScreen mainScreen] bounds].size.width))

#define kLandscapeIPhoneX_Width 662
//判断是否iPhone X系列
#define iPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896 || [UIScreen mainScreen].bounds.size.width == 812 || [UIScreen mainScreen].bounds.size.width == 896)


enum {
    NHKBImageLeft = 0,
    NHKBImageInner,
    NHKBImageRight,
    NHKBImageMax
};

@implementation NDBubble

+ (UIImageView *)addBubble:(AXKeyBoardSaseButton *)btn targetTitle:(NSString *)tmp {
    CGFloat upperwidth = (btn.frame.size.width) * [[UIScreen mainScreen] scale] * 1.5;
    UIImageView *keyPop;
    CGFloat scale = [UIScreen mainScreen].scale;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(_PADDING_X/scale, _PADDING_Y/scale, upperwidth/scale, _PAN_UPPER_HEIGHT/scale)];
    
    if ([btn.titleLabel.text containsString:@"q"]
        || [btn.titleLabel.text containsString:@"Q"]) {
        keyPop = [[UIImageView alloc] initWithImage:[self createKeytopImageWithKind:NHKBImageRight with:btn]];
        keyPop.frame = CGRectMake(-14 , SCREEN_WIDTH > SCREEN_HEIGHT ? -71 : -58, keyPop.frame.size.width , keyPop.frame.size.height);
    }
    else if ([btn.titleLabel.text containsString:@"p"]
             || [btn.titleLabel.text containsString:@"P"]) {
        keyPop = [[UIImageView alloc] initWithImage:[self createKeytopImageWithKind:NHKBImageLeft with:btn]];
        keyPop.frame = CGRectMake(SCREEN_WIDTH > SCREEN_HEIGHT ? -44 * ScreespecOne : -31 *ScreespecOne  , SCREEN_WIDTH > SCREEN_HEIGHT ? -71 : -58, keyPop.frame.size.width, keyPop.frame.size.height);
    }
    else {
        keyPop = [[UIImageView alloc] initWithImage:[self createKeytopImageWithKind:NHKBImageInner with:btn]];
        keyPop.frame = CGRectMake(SCREEN_WIDTH > SCREEN_HEIGHT ? -28 * ScreespecOne : -23 * ScreespecOne, SCREEN_WIDTH > SCREEN_HEIGHT ? -71 : -58, keyPop.frame.size.width, keyPop.frame.size.height);
    }
    
    //

    
    [text setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
    [text setTextColor: [UIColor blackColor]];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setShadowColor:[UIColor whiteColor]];
    [text setText:tmp];
    
    keyPop.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;  // 阴影颜色, 可设置透明度等
    keyPop.layer.shadowOffset = CGSizeMake(0, 3.0);                             // 偏移量, xy表示view左上角, width表示阴影与x的偏移量, height表示阴影与y值的偏移量
    keyPop.layer.shadowOpacity = 1;                                             // 阴影透明度, 默认为0则看不到阴影. 因此要看到阴影这个值必须大于0, shadowColor的透明度也要大于0
    keyPop.layer.shadowRadius = 5.0;                                            // 模糊计算的半径, 取平均值的半径, 设置为0的话则为一个矩形块
    keyPop.layer.masksToBounds = NO;
    [keyPop addSubview:text];
    
    return keyPop;
}

+ (UIImage *)createKeytopImageWithKind:(int)kind with:(AXKeyBoardSaseButton *)btn {
    CGFloat upperwidth = (btn.frame.size.width) * [[UIScreen mainScreen] scale] * 1.5;
    CGFloat lowWidth = (btn.frame.size.width) * [[UIScreen mainScreen] scale];
    //NSLog(@"%f--------btn.width---------%f",btn.width,lowWidth);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint p = CGPointMake(_PADDING_X, _PADDING_Y);//15,11
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    p.x += _PAN_UPPER_RADIUS; // 7
    CGPathMoveToPoint(path, NULL, p.x, p.y);
    p.x += (upperwidth-_PAN_UPPER_RADIUS*2);
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    p.y += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 3.0*M_PI/2.0,
                 4.0*M_PI/2.0,
                 false);
    p.x += _PAN_UPPER_RADIUS;
    p.y += _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    switch (kind) {
        case NHKBImageLeft:
            p.x -=  (upperwidth - lowWidth);
            break;
            
        case NHKBImageInner:
            p.x -=  ((upperwidth - lowWidth)/2);
            break;
            
        case NHKBImageRight:
            break;
    }
    
    p.y += _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    p.y += _PAN_LOWER_HEIGHT - _PAN_CURVE_SIZE - _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    p.x -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 4.0*M_PI/2.0,
                 1.0*M_PI/2.0,
                 false);
    p.x -=   (lowWidth - _PAN_LOWER_RADIUS*2);
    p.y += _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    p.y -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 1.0*M_PI/2.0,
                 2.0*M_PI/2.0,
                 false);
    p.x -= _PAN_LOWER_RADIUS;
    p.y -= _PAN_LOWER_HEIGHT - _PAN_LOWER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    p1 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    switch (kind) {
        case NHKBImageLeft:
            break;
        case NHKBImageInner:
            p.x -=  ((upperwidth - lowWidth)/2);
            break;
        case NHKBImageRight:
            p.x -=  (upperwidth - lowWidth);
            break;
    }
    p.y -= _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y -= _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    p.x += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 2.0*M_PI/2.0,
                 3.0*M_PI/2.0,
                 false);
    //----
    CGContextRef context;
    UIGraphicsBeginImageContext(CGSizeMake( (upperwidth + _PADDING_X*2),
                                           _HEIGHT));
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, _HEIGHT);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextAddPath(context, path);
    CGContextClip(context);
    //----
    // draw gradient
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGFloat components[] = {
        1, 1,
        1, 1,
        1, 1,
        1, 1
    };
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 2);
    CGRect frame = CGPathGetBoundingBox(path);
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = frame.origin;
    endPoint.y = frame.origin.y + frame.size.height;
    
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef,
                                                                    components,
                                                                    NULL,
                                                                    count);
    
    CGContextDrawLinearGradient(context,
                                gradientRef,
                                startPoint,
                                endPoint,
                                kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown];
    
    CGImageRelease(imageRef);
    CFRelease(path);

    return result;
}

@end
