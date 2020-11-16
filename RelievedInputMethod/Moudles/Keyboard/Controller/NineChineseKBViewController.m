//
//  NineChineseKBViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "NineChineseKBViewController.h"
#import "NSArray+Sudoku.h"
#import "SudokuView.h"
#import "NineRightSide.h"
#import "NineBottomView.h"
#import "NineLeftSide.h"

@interface NineChineseKBViewController ()<RIEngineManagerDelegate, SudokuViewDelegate>{
    float width;
    float height;
}
@property(nonatomic,strong)SudokuView *sudokuView; //九宫格
@property(nonatomic,strong)NineRightSide *rightView; //右侧栏
@property(nonatomic,strong)NineBottomView *bottomView; //底栏
@property(nonatomic,strong)NineLeftSide *leftView; //左侧栏
//@property (nonatomic, strong)NineChineseModel *nineModel;
@property(nonatomic,assign)BOOL isFirstFarticiples;
@end

@implementation NineChineseKBViewController
//
//- (NineChineseModel *)nineModel{
//    if (!_nineModel) {
//        _nineModel = [CharacterManger getNineChineseKeyboardSymbool];
//    }
//    return _nineModel;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [GetKeyboardStatus status].currentKeyboardType = Keyboard_PinyinNine;
    self.isFirstFarticiples = true;
    // 创建九宫格
//    NSMutableArray *nineArray =[[NSMutableArray alloc]init];
//    for (int i = 0; i < 9; i++) {
//            AXKeyBoardSaseButton *btn = [AXKeyBoardSaseButton buttonWithType:UIButtonTypeCustom];
//            btn.KeyboardButtonType =AXKeyboardButtonTypeLetter;
//            [btn setTopText:self.nineModel.inputs[i].subSymbool text:self.nineModel.inputs[i].symbool];
//    //        btn.tag = 10 +i;
//            btn.tag = i;
//
//            [self manageActionWithFunctionButton:btn];
//            [nineArray addObject:btn];
//
////            [self addSubview:btn];
//        }
    
    self.sudokuView = [[SudokuView alloc] init];
    self.sudokuView.delegate = self;
    
//    self.sudokuView =[[SudokuView alloc]initWithNineItems:nineArray];

    [self.view addSubview:self.sudokuView];
    
    // 创建右侧栏
    NSMutableArray *rightArray =[[NSMutableArray alloc]init];
    NSMutableArray* typeArray = [[NSMutableArray alloc]init];
    [typeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeASCIIDelete]];
    [typeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeASCIIEnterAgain]];
    [typeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeAite]];
    [typeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeLineFeed]];
    for (int i = 0; i < 4; i++) {
        AXKeyBoardSaseButton *btn = [AXKeyBoardSaseButton buttonWithType:UIButtonTypeCustom];
        btn.KeyboardButtonType =(AXKeyboardButtonType)[typeArray[i] intValue];
        [self manageActionWithFunctionButton:btn];
        [rightArray addObject:btn];
    }
    self.rightView =[[NineRightSide alloc]initWithItems:rightArray];
    [self.view addSubview:self.rightView];
    
    // 创建底栏
    NSMutableArray *bottomArray =[[NSMutableArray alloc]init];
    NSMutableArray* bottomTypeArray = [[NSMutableArray alloc]init];
    [bottomTypeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeSymbol]];
    [bottomTypeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeToNumber]];
    if ([GetKeyboardStatus status].shouldAddChangeKeyboardButton) {
        [bottomTypeArray addObject:[NSString stringWithFormat:@"%ld", (long)AXKeyboardButtonTypeSwitchKeyBoard]];
    }
    [bottomTypeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeSpace]];
    [bottomTypeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeChToEn]];
    
    for (int i =0; i<bottomTypeArray.count; i++) {
        AXKeyBoardSaseButton *btn = [AXKeyBoardSaseButton buttonWithType:UIButtonTypeCustom];
        btn.KeyboardButtonType =(AXKeyboardButtonType)[bottomTypeArray[i] intValue];
        [self manageActionWithFunctionButton:btn];
        [bottomArray addObject:btn];
    }
    self.bottomView =[[NineBottomView alloc]initWithItems:bottomArray AndKeyboardType:Keyboard_PinyinNine];
    [self.view addSubview:self.bottomView];
    
    //创建左侧栏
    self.leftView =[[NineLeftSide alloc]initWithFrame:CGRectMake(NineKB_Space_Bound_X, NineKB_Space_Bound_Y, 20,50)];
    [self.view addSubview:self.leftView];
}

//约束布局必须在此方法内，否则布局无效
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    //九宫格布局
    [self.sudokuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(NineKB_Space_Bound_X + NineKB_Side_Bt_Width(width)) ;
        make.right.mas_equalTo(-(NineKB_Space_Bound_X + NineKB_Side_Bt_Width(width)));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo( height -(NineKB_Space_Bound_Y + NineKB_Bt_Height(height)));
    }];
    [self.sudokuView layoutWithWidth:width height:height];
    
    //右侧栏布局
    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sudokuView.mas_right);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    [self.rightView layoutWithWidth:width height:height];
    
    //底栏布局
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.rightView.mas_left);
        make.top.mas_equalTo(self.sudokuView.mas_bottom);
        make.bottom.mas_equalTo(self.rightView);
    }];
    [self.bottomView layoutWithWidth:width height:height];
    
    //左侧栏布局
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NineKB_Space_Bound_Y);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-NineKB_Space_Y);
        make.left.mas_equalTo(NineKB_Space_Bound_X);
        make.right.mas_equalTo(self.sudokuView.mas_left);
    }];
    [self.leftView layoutWithWidth:width height:height];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加引擎代理
    [[RIEngineManager manger]addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除引擎代理
    [[RIEngineManager manger]removeDelegate:self];
}

#pragma -mark RIEngineManagerDelegate 引擎代理方法
- (void)getFetchInputData:(NSArray<NSString *> *)candidateWords pinyin:(NSArray<NSString *> *)aPinyinWords confirmingPinyin:(NSString *)aConfirmingPinyin onScreenText:(NSString *)aOnScreenText preWordAndCurPinyin:(NSString *)preWordAndCurPinyin {
    //右侧栏显示字母
    self.leftView.spellArray =aPinyinWords;
    
    //Return按钮title刷新
    if (!kIsEmptyString(aOnScreenText)) {
        //有上屏词
        [self macthReturnButtonTitle];
    }else{
        //无上屏词
        if (kIsEmptyString(aConfirmingPinyin)) {
            //无待确定的拼音
            self.isFirstFarticiples = true;
            [self macthReturnButtonTitle];
        }else{
            self.isFirstFarticiples = false;
            //有待确定的拼音
            [self setDeleteButton];
        }
    }
}

#pragma mark - SudokuViewDelegate 九宫格按钮代理方法
- (void)longTouchAction:(UILongPressGestureRecognizer *)gesture {
    [self buttonLongTouch:gesture];
}
- (void)clickBtn:(AXKeyBoardSaseButton *)bt model:(MainButtonModel *)model {
        //调用引擎。判断是否是分词
        if ([model.symbool isEqual: @"分词"]) {
            if (self.isFirstFarticiples) {
                [[RIEngineManager manger] keyboardItemClicked:@"49"];
            } else {
                [[RIEngineManager manger] separateWord];
            }
        } else {
            [[RIEngineManager manger] keyboardItemClicked:model.code];
        }
}

@end
