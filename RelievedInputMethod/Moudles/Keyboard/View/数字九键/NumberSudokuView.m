//
//  NumberSudokuView.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/8/4.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "NumberSudokuView.h"
#import "NSArray+Sudoku.h"

@interface NumberSudokuView ()

@property (nonatomic, strong)NineNumberModel *nineNumberModel;

@end

@implementation NumberSudokuView

- (instancetype)init {
    self =[super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    for (int i =0; i<9; i++) {
        AXKeyBoardSaseButton *btn = [AXKeyBoardSaseButton buttonWithType:UIButtonTypeCustom];
        btn.KeyboardButtonType = AXKeyboardButtonTypeNumber ;
        btn.tag = 20 +i;
        [btn setTitle:[NSString stringWithFormat:@"%@",self.nineNumberModel.inputs[i]] forState:UIControlStateNormal];
        [self manageActionWithCommonButton:btn];
        [self addSubview:btn];
    }
}

- (void)layoutWithWidth:(float)width height:(float)height{
    // 给按钮布局
    [self.subviews mas_distributeSudokuViewsWithFixedLineSpacing:NineKB_Space_Y fixedInteritemSpacing:NineKB_Space_X warpCount:3 topSpacing:NineKB_Space_Bound_Y bottomSpacing:NineKB_Space_Y leadSpacing:NineKB_Space_X tailSpacing:NineKB_Space_X];
}

- (NineNumberModel *)nineNumberModel {
    if (!_nineNumberModel) {
        _nineNumberModel = [CharacterManger getNineNumberKeyboardSymbool];
    }
    return _nineNumberModel;
}

- (void)btnTouchClick:(AXKeyBoardSaseButton*)bt {
    //数字上屏
    [[GetKeyboardStatus status].textDocumentProxy insertText:[NSString stringWithFormat:@"%@",self.nineNumberModel.inputs[bt.tag -20]]];
}

@end
