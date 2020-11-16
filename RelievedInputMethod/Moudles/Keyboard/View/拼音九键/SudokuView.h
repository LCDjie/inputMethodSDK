//
//  SudokuView.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/16.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
拼音九键九宫格view
*/

#import <UIKit/UIKit.h>
#import "BaseModuleView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SudokuViewDelegate <NSObject>
//长按方法
- (void)longTouchAction:(UILongPressGestureRecognizer *)gesture;
//点击效果
- (void)clickBtn:(AXKeyBoardSaseButton *)bt model:(MainButtonModel *)model;


@end

@interface SudokuView : BaseModuleView

@property (nonatomic, weak) id <SudokuViewDelegate> delegate;

//- (instancetype)initWithNineItems:(NSArray *)items;


@end

NS_ASSUME_NONNULL_END
