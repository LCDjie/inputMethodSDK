//
//  FullEnglishKBViewController.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
英文全键
*/

#import "KeyboardBaseViewController.h"
#import "AXKeyBoardSaseButton.h"
#import "NDBubble.h"
#import "SoundEffectEngine.h"
#import "KeyboardState.h"
NS_ASSUME_NONNULL_BEGIN

@interface FullEnglishKBViewController : KeyboardBaseViewController
//所有高度
@property (nonatomic,assign)CGFloat buttonHeight;
//输入按钮宽度
@property (nonatomic,assign)CGFloat buttonWeight;
//按钮之前的间距
@property (nonatomic,assign)CGFloat buttonSpace;
//功能按钮宽度
@property (nonatomic,assign)CGFloat functionButtonWidth;
//收起键盘按钮宽度
@property (nonatomic,assign)CGFloat resignButtonWidth;
//判断是否是直输
@property (nonatomic,assign)BOOL isDirectInput;
//选中button
@property (nonatomic,strong)UIColor *clickColor;
//@property (nonatomic,assign)BOOL isLetter;
@property (nonatomic,strong)NSDictionary *messageDic;
- (void)createKeyBoard;
- (CGFloat)btnWidth;
- (CGFloat)functionBtnWidth;
- (CGFloat)resignBtnWidth;
- (void)createFourthRow:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END
