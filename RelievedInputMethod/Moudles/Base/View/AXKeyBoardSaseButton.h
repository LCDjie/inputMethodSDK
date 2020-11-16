//
//  AXKeyBoardSaseButton.h
//  RelievedInputMethod
//
//  Created by liweijie on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
基础普通按钮
*/

#import <Foundation/Foundation.h>
#import "AdaptiveDefine.h"
#import "ColorDefine.h"
#import "FontDefine.h"
#import "KeyboardDefine.h"
@interface AXKeyBoardSaseButton : UIButton

@property (nonatomic, assign)AXKeyboardButtonType KeyboardButtonType; //按钮类型
/**
 * 给按键主标签与上标签字符内容
 */
- (void)setTopText:(NSString *)upText text:(NSString *)text;

@end


