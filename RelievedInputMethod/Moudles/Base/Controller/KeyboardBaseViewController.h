//
//  KeyboardBaseViewController.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
基础键盘控制器
*/

#import <UIKit/UIKit.h>
#import "AXKeyBoardSaseButton.h"
#import "MenuCandidateBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardBaseViewController : UIViewController

//添加按钮点击事件
- (void)manageActionWithFunctionButton:(AXKeyBoardSaseButton *)bt;

//Return按钮 title更新
- (void)macthReturnButtonTitle;
- (void)setDeleteButton;
@property(nonatomic, strong)AXKeyBoardSaseButton *returnButton; //return按钮
@property(nonatomic, strong)AXKeyBoardSaseButton *switchToEnButton; //中文转英文按钮

//按钮长按
- (void)buttonLongTouch:(UILongPressGestureRecognizer*)gestureRecognizer;

@end

NS_ASSUME_NONNULL_END
