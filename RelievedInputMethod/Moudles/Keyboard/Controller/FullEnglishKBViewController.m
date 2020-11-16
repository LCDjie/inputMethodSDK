//
//  FullEnglishKBViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "FullEnglishKBViewController.h"

@interface FullEnglishKBViewController () <UIGestureRecognizerDelegate,RIEngineManagerDelegate>
@property (nonatomic, strong)NSMutableArray *dataSource;//!<数据源数组

@end

@implementation FullEnglishKBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource=[CharacterManger getAllEnglishKeyboardSymbool];
       
    self.view.backgroundColor = Keyboard_Background_Color;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FullEnglish" ofType:@"plist"];
    self.messageDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    self.buttonSpace = kAXASCIIKeyboardBtnHorizontalSpace;
    self.buttonHeight = kAXASCIIKeyboardBtnHeight;
    self.buttonWeight = [self btnWidth];
    self.functionButtonWidth = [self functionBtnWidth];
    self.resignButtonWidth = [self resignBtnWidth];
    [self createKeyBoard];
    self.isDirectInput = NO;
//    [self addLongPressGesture];
}

- (void)createKeyBoard
{
    if([GetKeyboardStatus status].numericKeypadLine) {
        [self createNumberKeyBoard:kAXASCIIKeyboardBtnVerticalSpace/2];
    } else {
        [self createFirstRow:kAXASCIIKeyboardBtnVerticalSpace/2];
    }
}

- (void)createNumberKeyBoard :(CGFloat)offsetY {
    
    CGFloat secondOffsetY = 0.0;
    for (int i=0; i<10;i++) {
        AXKeyBoardSaseButton *btn = [self createBtn];
        CGFloat sideSpace = 3;
        btn.frame = CGRectMake(sideSpace+i*(self.buttonSpace+self.buttonWeight), offsetY, self.buttonWeight, self.buttonHeight);
        btn.KeyboardButtonType = AXKeyboardButtonTypeFullBoardNumber;
        [btn setTitle:[NSString stringWithFormat:@"%d",((i+1)%10)] forState:UIControlStateNormal];
        secondOffsetY = CGRectGetMaxY(btn.frame) + kAXASCIIKeyboardBtnVerticalSpace;
        [self.view addSubview:btn];
        [self manageActionWithFunctionButton:btn];
    }
    [self createFirstRow:secondOffsetY];
    
}

- (void)createFirstRow:(CGFloat)offsetY
{
    CGFloat secondOffsetY = 0.0;
    //距两边间距
    CGFloat sideSpace = 3;
    for (int i = 0; i < allKeyBoardFirstLineNumber; i++) {
        AXKeyBoardSaseButton *btn = [self createBtn];
        btn.tag = i;
        MainButtonModel *item = self.dataSource[btn.tag];
        //富文本加载
        [btn setTopText:item.subSymbool text:item.samllSymbool ];
        btn.frame = CGRectMake(sideSpace+i*(self.buttonSpace+self.buttonWeight), offsetY, self.buttonWeight, self.buttonHeight);
        btn.KeyboardButtonType = AXKeyboardButtonTypeLetter;
        [self.view addSubview:btn];
        secondOffsetY = CGRectGetMaxY(btn.frame) + kAXASCIIKeyboardBtnVerticalSpace;
        [self manageActionWithFunctionButton:btn];
    }

    [self createSecondRow:secondOffsetY];
}

- (void)createSecondRow:(CGFloat)offsetY
{
    CGFloat thirdOffsetY = 0.0;
    //距两边间距
    CGFloat sideSpace = (SCREEN_WIDTH-(allKeyBoardSecondLineNumber)*self.buttonWeight - (allKeyBoardSecondLineNumber-1)*self.buttonSpace)/2;
    for (int i = 0; i < allKeyBoardSecondLineNumber; i++) {
        AXKeyBoardSaseButton *btn = [self createBtn];
        btn.tag = i + allKeyBoardFirstLineNumber;
        MainButtonModel *item = self.dataSource[btn.tag];
        [btn setTopText:item.subSymbool text:item.samllSymbool ];
        btn.frame = CGRectMake(sideSpace+i*(self.buttonSpace+self.buttonWeight), offsetY, self.buttonWeight, self.buttonHeight);
        btn.KeyboardButtonType = AXKeyboardButtonTypeLetter;
        [self.view addSubview:btn];
        thirdOffsetY = CGRectGetMaxY(btn.frame) + kAXASCIIKeyboardBtnVerticalSpace;
        [self manageActionWithFunctionButton:btn];
    }
    [self createThirdRow:thirdOffsetY];
}

- (void)createThirdRow:(CGFloat)offsetY
{
    CGFloat fourthOffsetY = 0.0;
    //距两边间距
    CGFloat sideSpace = kAXASCIIKeyboardBtnHorizontalSpace/2;
    for (int i = 0; i < allKeyBoardThirdLineNumber; i++) {
        AXKeyBoardSaseButton *btn = [self createBtn];
        btn.tag = i + allKeyBoardFirstLineNumber + allKeyBoardSecondLineNumber;
        if (i == 0) {
            btn.frame = CGRectMake(sideSpace, offsetY, self.functionButtonWidth, self.buttonHeight);
            btn.KeyboardButtonType = AXKeyboardButtonTypeToggleCase;
        }else if (i == allKeyBoardThirdLineNumber - 1){
            btn.frame = CGRectMake(SCREEN_WIDTH-sideSpace-self.functionButtonWidth, offsetY, self.functionButtonWidth, self.buttonHeight);
            btn.KeyboardButtonType = AXKeyboardButtonTypeASCIIDelete;
        }else{
            btn.frame = CGRectMake(sideSpace+self.functionButtonWidth+self.buttonSpace+(i-1)*(self.buttonSpace+self.buttonWeight), offsetY, self.buttonWeight, self.buttonHeight);
            //富文本加载
            MainButtonModel *item = self.dataSource[btn.tag];
            [btn setTopText:item.subSymbool text:item.samllSymbool ];
            btn.KeyboardButtonType = AXKeyboardButtonTypeLetter;
        }
        [self manageActionWithFunctionButton:btn];
        [self.view addSubview:btn];
        fourthOffsetY = CGRectGetMaxY(btn.frame) + kAXASCIIKeyboardBtnVerticalSpace;
    }
    [self createFourthRow:fourthOffsetY];
    
}
- (void)createFourthRow:(CGFloat)offsetY
{
    //距两边间距
    CGFloat sideSpace = kAXASCIIKeyboardBtnHorizontalSpace/2;
    CGFloat resignX = SCREEN_WIDTH-sideSpace-kAXAllKLWidth;
    CGFloat ceX = resignX - kAXAllKLWidth - self.buttonSpace;
    CGFloat decimalX = ceX - self.buttonWeight - self.buttonSpace;
    for (int i = 0; i < 7; i ++) {
        AXKeyBoardSaseButton *btn = [self createBtn];
        btn.tag = i + 28;
        if (i == 0) {
            //符号键盘
            btn.KeyboardButtonType = AXKeyboardButtonTypeSymbol;
            btn.frame = CGRectMake(sideSpace, offsetY, self.buttonWeight, self.buttonHeight);
        } else if (i == 1) {//切换数字键盘
            btn.KeyboardButtonType = AXKeyboardButtonTypeToNumber;
            btn.frame = CGRectMake(sideSpace + self.buttonWeight + self.buttonSpace, offsetY,self.buttonWeight, self.buttonHeight);
        } else if (i == 2) {
            //直输模式
            btn.KeyboardButtonType = AXKeyboardButtonTypeDirectInput;
            btn.frame = CGRectMake(sideSpace + (self.buttonWeight  + self.buttonSpace)*2, offsetY, self.buttonWeight, self.buttonHeight);
        }
        else if (i == 6){//换行
            btn.KeyboardButtonType = AXKeyboardButtonTypeLineFeed;
            btn.frame = CGRectMake(resignX, offsetY,kAXAllKLWidth, self.buttonHeight);
        } else if (i == 5) {
            //中/英文
            btn.KeyboardButtonType = AXKeyboardButtonTypeEnToCh;
            btn.frame = CGRectMake(ceX, offsetY,kAXAllKLWidth, self.buttonHeight);
        } else if(i == 4){//小数点
            
            MainButtonModel *item = self.dataSource[32];
            [btn setTopText:item.subSymbool text:item.samllSymbool ];
            btn.KeyboardButtonType = AXKeyboardButtonTypeASCIIDecimal;
            btn.frame = CGRectMake(decimalX, offsetY, self.buttonWeight, self.buttonHeight);
            
        } else if (i == 3){//空格
            btn.KeyboardButtonType = AXKeyboardButtonTypeSpace;
            CGFloat x = sideSpace + (self.buttonWeight + self.buttonSpace)*3;
            btn.frame = CGRectMake(x, offsetY, SCREEN_WIDTH- (sideSpace*2 + (self.buttonWeight  + self.buttonSpace)*4) - (self.buttonSpace *2  + kAXAllKLWidth *2),
                                   self.buttonHeight);
        }
        [self manageActionWithFunctionButton:btn];
        [self.view addSubview:btn];
    }
}


/**
 按钮自定义
 */
- (AXKeyBoardSaseButton *)createBtn
{
    AXKeyBoardSaseButton *btn = [AXKeyBoardSaseButton buttonWithType:UIButtonTypeCustom];
    return btn;

}

 /**
  按钮的宽度

  @return 按钮的宽度
  */
 - (CGFloat)btnWidth
 {
     return (SCREEN_WIDTH-self.buttonSpace*allKeyBoardFirstLineNumber)/allKeyBoardFirstLineNumber;
 }
/**
 大小写切换，退格，切换数字键盘按钮宽度
 */
- (CGFloat)functionBtnWidth
{
    CGFloat functionBtnWidth = (SCREEN_WIDTH-(allKeyBoardThirdLineNumber -2)*self.buttonWeight - (allKeyBoardThirdLineNumber)*self.buttonSpace)/2;
    return functionBtnWidth;
}

/**
 收起键盘按钮宽度

 @return 收起键盘按钮宽度
 */
- (CGFloat)resignBtnWidth
{
    return self.buttonWeight + self.buttonSpace + self.functionButtonWidth;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void)getFetchInputData:(nonnull NSArray<NSString *> *)candidateWords pinyin:(nonnull NSArray<NSString *> *)aPinyinWords confirmingPinyin:(nonnull NSString *)aConfirmingPinyin onScreenText:(nonnull NSString *)aOnScreenText preWordAndCurPinyin:(nonnull NSString *)preWordAndCurPinyin {
    
    //Return按钮title刷新
    if (!kIsEmptyString(aOnScreenText)) {
        //有上屏词
        [self macthReturnButtonTitle];
    }else{
        //无上屏词
        if (kIsEmptyString(aConfirmingPinyin)) {
            //有待确定的拼音
            [self macthReturnButtonTitle];
        }else{
            
            [self setDeleteButton];
            //没有待确定的拼音
//            [self.returnButton setTitle:@"确定" forState:UIControlStateNormal];
        }
    }
    
}


@end
