//
//  BaseModuleView.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/23.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
基础键盘view
*/

#import <UIKit/UIKit.h>
#import "AXKeyBoardSaseButton.h"
#import "CharacterModel.h"
#import "CharacterManger.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModuleView : UIView
@property (nonatomic, strong) RIEngineManager *engineManager;//!< 输入法引擎

//设置按钮约束
- (void)layoutWithWidth:(float)width height:(float)height;
//设置普通按钮点击事件
- (void)manageActionWithCommonButton:(AXKeyBoardSaseButton *)bt;

@end

NS_ASSUME_NONNULL_END
