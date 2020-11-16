//
//  SudokuView.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/16.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "SudokuView.h"
#import "NSArray+Sudoku.h"

@interface SudokuView ()
@property (nonatomic, strong)NineChineseModel *nineModel;
//@property (nonatomic,strong)NSMutableArray *longGestureArray;

@end

@implementation SudokuView

- (instancetype)init {
    self =[super init];
    if (self) {
        self.engineManager =[RIEngineManager manger];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    for (int i = 0; i < 9; i++) {
        AXKeyBoardSaseButton *btn = [AXKeyBoardSaseButton buttonWithType:UIButtonTypeCustom];
        btn.KeyboardButtonType =AXKeyboardButtonTypeNineLetter;
        [btn setTopText:self.nineModel.inputs[i].subSymbool text:self.nineModel.inputs[i].symbool];
//        btn.tag = 10 +i;
        btn.tag = i;
        [self manageActionWithCommonButton:btn];
        [self addSubview:btn];
    }
}

- (void)btnTouchClick:(AXKeyBoardSaseButton*)bt {
    if (_delegate) {
        [_delegate clickBtn:bt model:self.nineModel.inputs[bt.tag]];
    }
}

- (NineChineseModel *)nineModel{
    if (!_nineModel) {
        _nineModel = [CharacterManger getNineChineseKeyboardSymbool];
    }
    return _nineModel;
}

- (void)manageActionWithCommonButton:(AXKeyBoardSaseButton *)bt {
    [super manageActionWithCommonButton:bt];
    
    //给按钮添加长按
    if (bt.KeyboardButtonType == AXKeyboardButtonTypeNineLetter) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(buttonLongTouch:)];
          longPress.minimumPressDuration = 0.6;  //定义长按时间
          [bt addGestureRecognizer:longPress];
//        [self.longGestureArray addObject:longPress];
    }
}

//给按钮布局
- (void)layoutWithWidth:(float)width height:(float)height{
    [self.subviews  mas_distributeSudokuViewsWithFixedLineSpacing:NineKB_Space_Y fixedInteritemSpacing:NineKB_Space_X warpCount:3 topSpacing:NineKB_Space_Bound_Y bottomSpacing:NineKB_Space_Y leadSpacing:NineKB_Space_X tailSpacing:NineKB_Space_X];
}

#pragma mark - 按钮长按
- (void)buttonLongTouch:(UILongPressGestureRecognizer*)gestureRecognizer {
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(longTouchAction:)]) {
        [_delegate longTouchAction:gestureRecognizer];
    }


}


@end
