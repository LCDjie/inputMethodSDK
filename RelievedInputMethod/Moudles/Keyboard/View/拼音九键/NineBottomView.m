//
//  NineBottomView.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/17.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "NineBottomView.h"
#import "NSArray+Sudoku.h"

@interface NineBottomView ()

@property (nonatomic, strong) UIView *centerView ;
@property (nonatomic, strong) AXKeyBoardSaseButton *symbolButton ; //左侧符号键
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation NineBottomView

- (instancetype)initWithItems:(NSArray *)items AndKeyboardType:(KeyboardType)keyboardType{
    self = [super init];
    if (self) {
        [self setUIWithItems:items AndKeyboardType:keyboardType];
    }
    return self;
}

- (void)setUIWithItems:(NSArray *)items AndKeyboardType:(KeyboardType)keyboardType{
    self.backgroundColor = Keyboard_Background_Color;
    BOOL hasAddSpaceButton = false;
    for (AXKeyBoardSaseButton *btn in items) {
        if (btn.KeyboardButtonType == AXKeyboardButtonTypeSymbol) {
            self.symbolButton =btn;
            [self addSubview:btn];
            continue;
        } else if (keyboardType == Keyboard_NumNine) {
            [self.centerView addSubview:btn];
            continue;
        } else if (btn.KeyboardButtonType == AXKeyboardButtonTypeSpace) {
            hasAddSpaceButton = true;
            [self.centerView addSubview:btn];
            continue;
        }
        if (!hasAddSpaceButton) {
            [self.leftView addSubview:btn];
        } else {
            [self.rightView addSubview:btn];
        }
    }
}

- (void)layoutWithWidth:(float)width height:(float)height{
    //符号键size与其他键不同，单独设置约束
    if (self.symbolButton) {
        [self.symbolButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(NineKB_Space_Bound_X);
            make.width.mas_equalTo(NineKB_Side_Bt_Width(width));
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(NineKB_Bt_Height(height));
        }];
    }
    
    if (_leftView) {
        if (_leftView.subviews.count > 1) {
            [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(NineKB_Side_Bt_Width(width) + NineKB_Space_X);
                make.top.bottom.mas_equalTo(self);
                make.width.mas_equalTo(NineKB_Center_Bt_Width(width));
            }];
        } else {
            [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(NineKB_Side_Bt_Width(width) + NineKB_Space_X);
                make.top.bottom.mas_equalTo(self);
                make.width.mas_equalTo(NineKB_Center_Bt_Width(width) / 4 * 3);
            }];
        }
        [self.leftView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:NineKB_Space_Y fixedInteritemSpacing:NineKB_Space_X warpCount:self.leftView.subviews.count topSpacing:0 bottomSpacing:NineKB_Space_Bound_Y leadSpacing:NineKB_Space_X tailSpacing:0];
    }
    
    if (_rightView) {
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.mas_equalTo(self);
            make.width.mas_equalTo(NineKB_Center_Bt_Width(width) / 4 * 3);
        }];
        [self.rightView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:NineKB_Space_Y fixedInteritemSpacing:NineKB_Space_X warpCount:1 topSpacing:0 bottomSpacing:NineKB_Space_Bound_Y leadSpacing:0 tailSpacing:NineKB_Space_X];
    }
    
    if (!_rightView && !_leftView) {
        [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(NineKB_Side_Bt_Width(width) + NineKB_Space_X);
            make.right.top.bottom.mas_equalTo(self);
        }];

        //给按钮布局
        [self.centerView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:NineKB_Space_Y fixedInteritemSpacing:NineKB_Space_X warpCount:self.centerView.subviews.count topSpacing:0 bottomSpacing:NineKB_Space_Bound_Y leadSpacing:NineKB_Space_X tailSpacing:NineKB_Space_X];
    } else {
        [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftView.mas_right).offset(NineKB_Space_X);
            make.top.bottom.mas_equalTo(self);
            make.right.mas_equalTo(self.rightView.mas_left).offset(-NineKB_Space_X);
        }];
        
        //给按钮布局
        [self.centerView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:NineKB_Space_Y fixedInteritemSpacing:NineKB_Space_X warpCount:self.centerView.subviews.count topSpacing:0 bottomSpacing:NineKB_Space_Bound_Y leadSpacing:0 tailSpacing:0];
    }
}

#pragma mark - Lazy Var
- (UIView *)leftView {
    if (!_leftView) {
        UIView * tempView = [[UIView alloc] init];
        _leftView = tempView;
        [self addSubview:_leftView];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        UIView * tempView = [[UIView alloc] init];
        _rightView = tempView;
        [self addSubview:_rightView];
    }
    return _rightView;
}

- (UIView *)centerView {
    if (!_centerView) {
        UIView * tempView = [[UIView alloc] init];
        _centerView = tempView;
        [self addSubview:_centerView];
    }
    return _centerView;
}

@end
