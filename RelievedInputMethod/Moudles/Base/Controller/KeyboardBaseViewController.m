//
//  KeyboardBaseViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "KeyboardBaseViewController.h"
#import "NDBubble.h"
#import "KeyboardState.h"
#import "SoundEffectEngine.h"
#import "NDPopListView.h"
#import "AXKeyBoardSaseButton.h"
#import "UIImage+Common.h"

@interface KeyboardBaseViewController ()

@property(nonatomic, strong)RIEngineManager *engine; //引擎
@property(nonatomic, strong)MenuCandidateBar * menuCandidateBar; //菜单候选词栏
@property(nonatomic, strong)NDPopListView *popView;
//判断是否是直输
@property (nonatomic,assign)BOOL isDirectInput;
//判断是否是大小写
@property (nonatomic,assign)BOOL isCapital;
@property (nonatomic,assign)BOOL isLongDelete; //是否是长按删除操作
@property (nonatomic,assign)BOOL isNewline; //分词是否可以执行

@property (nonatomic,strong)NSTimer *timer; //时间
@property (nonatomic,strong)NSMutableArray *longGestureArray;
@end

@implementation KeyboardBaseViewController

- (NSMutableArray *)longGestureArray {
    if(!_longGestureArray) {
        NSMutableArray *tempLongGestureArray = [[NSMutableArray alloc]init];
        _longGestureArray = tempLongGestureArray;
    }
    return _longGestureArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =Keyboard_Background_Color;
    self.engine =[RIEngineManager manger]; //引擎初始化
    self.menuCandidateBar = [MenuCandidateBar shareInstance];//菜单候选词栏初始化
    self.isCapital = YES;
    self.isLongDelete = NO;
    self.isNewline = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加return按钮状态改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeReturnButtonTitle:) name:KEYBOARD_RETURNTYPECHANGE object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KEYBOARD_RETURNTYPECHANGE object:nil];
}

- (void)changeReturnButtonTitle:(NSNotification *)notification{
    [self macthReturnButtonTitle];
}

- (NDPopListView *)popView {
    if (!_popView) {
        _popView = [[NDPopListView alloc]init];
        _popView.backgroundColor = [UIColor whiteColor];
        _popView.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
        _popView.layer.borderColor = [UIColor ly_colorWithHexString:@"#CCCCCC"].CGColor;//设置边框颜色
        _popView.layer.borderWidth = 0.5;//设置边框颜色
        [self.view addSubview:_popView];
    }
    return _popView;
}

//长按删除与返回按钮操作
- (void)setDeleteButton {
    //判断是否是长按删除
    if (self.isLongDelete) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer timerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [SoundEffectEngine play];
            [self.engine backDelete];
        }];
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        self.isNewline = NO;
         [self.returnButton setTitle:@"确定" forState:UIControlStateNormal];
    }
}
//删除
- (void) deleInputView {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:0.12 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [[GetKeyboardStatus status].textDocumentProxy deleteBackward];
    }];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)macthReturnButtonTitle{
    //判断是否是长按状态且上屏有内容
    if (self.isLongDelete) {
        [self deleInputView];
    }
    
    if (!self.returnButton) {
        return;
    }
    UIReturnKeyType currentType =[GetKeyboardStatus status].textDocumentProxy.returnKeyType;
    NSString * title =@"换行";
    self.isNewline = NO;
    [self addlLongTouchButton];
    switch (currentType) {
        case UIReturnKeyDefault: {
            title = @"换行";
            self.isNewline = YES;
        }
            break;
        case UIReturnKeyGo:
        {
            title =@"前往";
        }
            break;
        case UIReturnKeyJoin:
        {
            title =@"加入";
        }
            break;
        case UIReturnKeyNext:
        {
            title =@"发送";
        }
            break;
        case UIReturnKeyRoute:
        {
            title =@"换行";
            self.isNewline = YES;
        }
            break;
        case UIReturnKeySearch:
        {
            title =@"搜索";
        }
            break;
        case UIReturnKeySend:
        {
            title =@"发送";
        }
            break;
        case UIReturnKeyDone:
        {
            title =@"完成";
        }
            break;
        default:
            break;
    }
    [self.returnButton setTitle:title forState:UIControlStateNormal];
}

- (void)manageActionWithFunctionButton:(AXKeyBoardSaseButton *)bt{
    switch (bt.KeyboardButtonType) {
        case AXKeyboardButtonTypeLineFeed:{
            self.returnButton =bt;
        }
            break;
        case AXKeyboardButtonTypeChToEn:{
            self.switchToEnButton=bt;
        }
            break;
        default:
            break;
    }
    if (bt.KeyboardButtonType == AXKeyboardButtonTypeSwitchKeyBoard) {
        //特殊的系统键盘选择
        [bt addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllEvents];
    } else {
        //按钮按下
       [bt addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
       //
       [bt addTarget:self action:@selector(btnTouchClick:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
       //按钮取消
       [bt addTarget:self action:@selector(btnTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        
        if (bt.KeyboardButtonType == AXKeyboardButtonTypeASCIIDelete) {
            //给删除按钮添加长按
            UILongPressGestureRecognizer *deleteLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(delegateLongTouch:)];
            deleteLongPress.minimumPressDuration = 0.6;
            [bt addGestureRecognizer:deleteLongPress];
        } else {
            //给按钮添加长按
            if (bt.KeyboardButtonType == AXKeyboardButtonTypeLetter || bt.KeyboardButtonType == AXKeyboardButtonTypeASCIIDecimal) {
                UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(buttonLongTouch:)];
                  longPress.minimumPressDuration = 0.7;  //定义长按时间
                  [bt addGestureRecognizer:longPress];
                [self.longGestureArray addObject:longPress];
//                  [self.longPress setEnabled:false];
            }
        }
        
    }
}
#pragma mark - 取消长按点击效果
- (void)cancelLongTouchButton {
    for (int i = 0; i<self.longGestureArray.count; i++) {
        UITapGestureRecognizer *temp = self.longGestureArray[i];
        [temp setEnabled:false];
    }
}
- (void)addlLongTouchButton {
    for (int i = 0; i<self.longGestureArray.count; i++) {
        UITapGestureRecognizer *temp = self.longGestureArray[i];
        [temp setEnabled:true];
    }
}

#pragma mark - 系统键盘选择
- (void)handleInputModeListFromView:(nonnull UIView *)view withEvent:(nonnull UIEvent *)event {
    NSArray *saveArray = [NSArray arrayWithObjects:view,event, nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCHSYSTEMBOARD object:saveArray];
    NSLog(@"更换键盘");
}

- (void)btnTouchDown:(AXKeyBoardSaseButton*)btn {
    NSLog(@"按钮按下");
    [btn setBackgroundColor: Keyboard_Select_Color];
    switch (btn.KeyboardButtonType) {
        case AXKeyboardButtonTypeLetter:{
            NSArray *array = [btn.titleLabel.text componentsSeparatedByString:@"\n"]; //从字符牌中分隔成2个元素的数组
            NSString *tmp = array[1];
            [btn addSubview:[NDBubble addBubble:btn targetTitle:tmp]];
        }
        break;
        case AXKeyboardButtonTypeFullBoardNumber: {
            NSString *tmp = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
            [btn addSubview:[NDBubble addBubble:btn targetTitle:tmp]];
        }
        break;
        case AXKeyboardButtonTypeEndCH: {
            NSString *tmp = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
                       [btn addSubview:[NDBubble addBubble:btn targetTitle:tmp]];
        }
        break;
        case AXKeyboardButtonTypeCommaCN: {
            NSString *tmp = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
                       [btn addSubview:[NDBubble addBubble:btn targetTitle:tmp]];
        }
        break;
        case AXKeyboardButtonTypeASCIIDecimal: {
            [btn addSubview:[NDBubble addBubble:btn targetTitle:@"."]];
        }
        break;
            
        default:
        break;
    }
}

- (void)btnTouchClick:(AXKeyBoardSaseButton*)btn {
    NSLog(@"点击btnTouchClick");
    [btn setBackgroundColor: kAXKeyboardBtnDefaultColor];
       //声音
    [SoundEffectEngine play];
            switch (btn.KeyboardButtonType) {
                  case AXKeyboardButtonTypeNumber:{

                   }
                       break;
                   case AXKeyboardButtonTypeDelete:{

                   }
                       break;
                   case AXKeyboardButtonTypeABC:{
            
                   }
                       break;
                   case AXKeyboardButtonTypeResign:{
            
                   }
                       break;
                   case AXKeyboardButtonTypeComplete:{
            
                   }
                       break;
                case AXKeyboardButtonTypeParticiples: {
                    
                    //
                    if (!self.isNewline) {
                        [self.engine separateWord]; //分词
                    } else {
                        NSLog(@"换行操作");
                    }
                    
                }
                    break;
                case AXKeyboardButtonTypeFullBoardNumber: {
                    NSString *itemStr = btn.titleLabel.text;
                    [[GetKeyboardStatus status].textDocumentProxy insertText:itemStr];
                    btn.backgroundColor = Main_Color;
                    NSArray *subs = [btn subviews];
                    if (subs.count == 2) {
                        [[subs lastObject] removeFromSuperview];
                    }
                    [self inputTextBase:btn.titleLabel.text tarBtn:btn];
                }
                        break;
                   case AXKeyboardButtonTypeDecimal:{ //数字键盘小数点
                       [[GetKeyboardStatus status].textDocumentProxy insertText:@"."];
                   }
                       break;
                   case AXKeyboardButtonTypeLetter:{
                       [self cancelLongTouchButton];
                       btn.backgroundColor = Main_Color;
                       NSLog(@"显示消失");
                       NSArray *subs = [btn subviews];
                       if (subs.count == 2) {
                           [[subs lastObject] removeFromSuperview];
                       }
                       [self inputTextBase:btn.titleLabel.text tarBtn:btn];
                   }
                       break;
                    case AXKeyboardButtonTypeASCIIDecimal:{
                        btn.backgroundColor = Main_Color;
                        NSArray *subs = [btn subviews];
                        if (subs.count == 2) {
                            [[subs lastObject] removeFromSuperview];
                        }
                        [self inputTextBase:btn.titleLabel.text tarBtn:btn];
                    }
                    break;
                    
                case AXKeyboardButtonTypeCommaCN: {
                    btn.backgroundColor = Main_Color;
                    NSArray *subs = [btn subviews];
                    if (subs.count == 2) {
                        [[subs lastObject] removeFromSuperview];
                    }
                    //逗号，中文
                    [[GetKeyboardStatus status].textDocumentProxy insertText:@"，"];
                }
                    break;
                    
                case AXKeyboardButtonTypeEndCH: {
                    btn.backgroundColor = Main_Color;
                    NSArray *subs = [btn subviews];
                    if (subs.count == 2) {
                        [[subs lastObject] removeFromSuperview];
                    }
                    //逗号，中文
                    [[GetKeyboardStatus status].textDocumentProxy insertText:@"。"];
                }
                    break;
                   case AXKeyboardButtonTypeToggleCase:{
                       NSLog(@"大小写");
                       [self.engine shiftKeyStatus:2];
                       [self keyBoardToggleCase:btn];
                   }
                       break;
                   case AXKeyboardButtonTypeASCIIDelete:{
                       NSLog(@"清除");
                       //字母键盘的删除
                       NSString * fristWord =self.menuCandidateBar.dataArray.count >0 ? self.menuCandidateBar.dataArray[0] :@"";
                       if (!kIsEmptyString(fristWord)) {
                           [self.engine backDelete];
                       }else{
                           //判断tool工具栏是否有值
                           [[GetKeyboardStatus status].textDocumentProxy deleteBackward];
                       }
                   }
                       break;
                       
                   case AXKeyboardButtonTypeComma:{
                       [self inputTextBase:btn.titleLabel.text tarBtn:btn];
                   }
                       break;
                       
                   case AXKeyboardButtonTypeToNumber:{ //切换数字键盘
                       [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)Keyboard_NumNine]];
                       [self.engine reset];
                       [self.engine numberExchange];//引擎数字
                   }
                       break;
                   case AXKeyboardButtonTypeASCIIEnterAgain:{
                       if ([self.menuCandidateBar.dataArray count] >0) {
                           [self.engine reset];
                       }
                   }
                       break;
                   case AXKeyboardButtonTypeAite:{
                       if (!kIsEmptyString(self.menuCandidateBar.spellStr)) {
                           [self.engine symbolItemClicked:@"64"];
                           break;
                       }
                       [RIFuntionBtClickManger showOnScreen:@"@"];
                   }
                       break;
                   case AXKeyboardButtonTypeLineFeed:{ //换行
                       if ([self.returnButton.titleLabel.text isEqualToString:@"确定"]) {
                           NSInteger items = [[MenuCandidateBar shareInstance].dataArray count];
                           [[GetKeyboardStatus status].textDocumentProxy insertText: items >0 ?[[MenuCandidateBar shareInstance].dataArray objectAtIndex:0] : @"" ];
                           [self.engine reset];
                           break;
                       }
                       
                       [[GetKeyboardStatus status].textDocumentProxy insertText:@"\n"];
                       [self.engine reset];
                   }
                       break;
                   case AXKeyboardButtonTypeChToEn: { //中文转英文
                       NSLog(@"中->英转换");
                       [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)Keyboard_ENFull]];
                   }
                       break;
                    case AXKeyboardButtonTypeSwitchKeyBoard: {
                        NSLog(@"切换键盘");
//                        [KeyboardState shareInstance].isSwitchSystemKeyBoard = true;
                    }
                        break;
                    case AXKeyboardButtonTypeEnToCh: {
                        NSLog(@"英->上一个中文 转换");
                        [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)[GetKeyboardStatus status].lastKeyCNboardType]];
                    }
                    break;
                case AXKeyboardButtonTypeSpace: { //中文键盘空格
                       if (self.menuCandidateBar.hidden) {
                           [[GetKeyboardStatus status].textDocumentProxy insertText:@" "];
                           break;
                       }
                       
                       if (!kIsEmptyString(self.menuCandidateBar.spellStr)) {
                           if (self.menuCandidateBar.dataArray.count >0) {
                               [self.engine clickCandidateAt:0];
                           }
                       }else {
                           [[GetKeyboardStatus status].textDocumentProxy insertText:@" "];
                           [self.engine reset];
                       }
                   }
                       break;
                   case AXKeyboardButtonTypeToBack: { //返回键
                       [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)[GetKeyboardStatus status].lastKeyboardType]];
                   }
                       break;
                   case AXKeyboardButtonTypeZero: { //数字0
                       [[GetKeyboardStatus status].textDocumentProxy insertText:@"0"];
                   }
                       break;
                   case AXKeyboardButtonTypeSymbol:{ //符号键盘
                       [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",Keyboard_SymbolCollection]];
                   }
                       break;
                case AXKeyboardButtonTypeDirectInput: {
                    if (self.isDirectInput == NO) {
                        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"abc"];
                        [attStr addAttribute:NSUnderlineStyleAttributeName
                        value:[NSNumber numberWithInteger:NSUnderlineStyleNone]
                        range:NSMakeRange(0, 3)];
                        [btn setAttributedTitle:attStr forState:UIControlStateNormal];
                        self.isDirectInput = YES;
                        NSLog(@"不是直输");
                    } else {
                        self.isDirectInput = NO;
                        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"abc"];
                        [attStr addAttribute:NSUnderlineStyleAttributeName
                        value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                        range:NSMakeRange(0, 3)];
                        [btn setAttributedTitle:attStr forState:UIControlStateNormal];
                        NSLog(@"直输");
                    }
                }
                    break;
                case AXKeyboardButtonTypeASCIINewline:{
        //            [textView resignFirstResponder];
                    NSLog(@"换行");
                }
                    break;
                   default:
                       break;
               }
}

- (void)btnTouchCancel:(AXKeyBoardSaseButton*)btn {
    NSLog(@"所有触摸btnTouchCancel");
    if (btn.KeyboardButtonType == AXKeyboardButtonTypeASCIIDelete) {
//        btn.backgroundColor = kAXKeyboardBtnDefaultColor;
    } else {
        btn.backgroundColor = Keyboard_Select_Color;
        NSArray *subs = [btn subviews];
        if (subs.count == 2) {
            [[subs lastObject] removeFromSuperview];
        }
    }
}

#pragma mark -删除按钮长按
- (void)delegateLongTouch:(UILongPressGestureRecognizer *)gestureRecognizer {
//    UIButton *item = [gestureRecognizer superclass];
    UIButton *item = (UIButton*)gestureRecognizer.view;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"删除长按");
            self.isLongDelete = YES;
            [self.engine backDelete];
            [item setImage:[[UIImage imageNamed:@"button_backspace_delete"] rl_imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        }
            break;
        case UIGestureRecognizerStateEnded:
            self.isLongDelete = NO;
            NSLog(@"删除结束");
            [item setImage:[UIImage imageNamed:@"button_backspace_delete"] forState:UIControlStateNormal];
            item.backgroundColor = kAXKeyboardBtnDefaultColor;
            [self.timer invalidate];
            self.timer = nil;
            break;
            
        default:
            break;
    }
}

#pragma mark - 按钮长按
- (void)buttonLongTouch:(UILongPressGestureRecognizer*)gestureRecognizer {
    UIButton *touchButton = (UIButton *)gestureRecognizer.view;
    if (!touchButton) {
        return;
    }
    CGPoint location = [gestureRecognizer locationInView:self.view];
    NSInteger tag = touchButton.tag;
    NSArray *itemArray;
    
    switch ([GetKeyboardStatus status].currentKeyboardType) {
        case Keyboard_PinyinFull:
            itemArray = [CharacterManger getAllChineseKeyboardSymbool];
            break;
        case Keyboard_PinyinNine:
            itemArray = [CharacterManger getNineChineseKeyboardSymbool].inputs;
            break;
        case Keyboard_ENFull:
            itemArray = [CharacterManger getAllEnglishKeyboardSymbool];
            break;
        default:
            break;
    }
    
    if (!itemArray) {
        return;
    }
    MainButtonModel *itemModel = itemArray[tag];
    
    NSArray *itemStr = [[NSArray alloc]init];
    NSArray *itemCode = [[NSArray alloc]init];

    if ([itemModel.chars isEqualToString:@".a,"]) {
        itemStr = [itemModel.chars componentsSeparatedByString:@"a"];
        itemCode = [itemModel.codeChars componentsSeparatedByString:@"a"];
    } else {
        itemStr = [itemModel.chars componentsSeparatedByString:@","];
        itemCode = [itemModel.codeChars componentsSeparatedByString:@","];
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (touchButton) {
                NSArray *subs = [touchButton subviews];
//                if (subs.count == 2) {
//                    [[subs lastObject] removeFromSuperview];
//                }
                if ([GetKeyboardStatus status].currentKeyboardType == Keyboard_PinyinNine) {
//                    [touchButton setBackgroundImage:[UIImage rl_imageWithColor:Keyboard_Select_Color size:CGSizeMake(80.0f, 45.0f) cornerRadius:5.0f] forState:UIControlStateNormal];
                    [touchButton setBackgroundColor:Keyboard_Select_Color];
                } else {
                    if (subs.count == 2) {
                        [[subs lastObject] removeFromSuperview];
                    }
                    [touchButton setBackgroundColor:Keyboard_Select_Color];
                }
                
                [self.popView showFrameWithButton:touchButton btnarr:itemStr];
                self.popView.hidden = NO;
            } else {
                NSLog(@"没有合适的判断");
            }
            [self.popView selectButton:location.x];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"长按按钮结束");
            self.popView.hidden = YES;
            for (UIButton *btView in self.popView.subviews) {
                if ([btView isKindOfClass:[UIButton class]]) {
                    if (btView.selected) {
                        touchButton.backgroundColor = UIColor.whiteColor;
                        NSInteger tag = [itemStr indexOfObject:btView.titleLabel.text];
                        NSLog(@"clickButton==%@==%@",itemCode[tag],itemStr[tag]);
//                        if (self.isDirectInput) {
                            [[GetKeyboardStatus status].textDocumentProxy insertText:itemStr[tag]];
//                        } else {
//                            [[RIEngineManager manger]keyboardItemClicked:itemCode[tag]];
//                        }
                    }
                }
            }
            break;
        case UIGestureRecognizerStateChanged: {
            NSLog(@"长按按钮改变%f",location.x);
                [self.popView selectButton:location.x];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"长按取消");
            break;
        }
        default:
            break;
    }
}

- (void)inputTextBase:(NSString *)text tarBtn:(AXKeyBoardSaseButton *)btn
{
    
    if ([text containsString:@"\n"]){
        //判断是否选择英文
        NSInteger num = btn.tag;
        
        MainButtonModel* item = [CharacterManger getAllEnglishKeyboardSymbool][num];
        
        NSArray *arrayItem = [[NSArray alloc]init];
        if ([item.chars isEqualToString:@".a,"]) {
            arrayItem = [item.codeChars componentsSeparatedByString:@"a"];
            if (self.isDirectInput) {
                [[GetKeyboardStatus status].textDocumentProxy insertText:@"."];
            } else {
                [[GetKeyboardStatus status].textDocumentProxy insertText:@"."];

//                [[RIEngineManager manger]keyboardItemClicked:arrayItem[0]];
            }
            
        } else if ([item.codeChars containsString:@","])  {
            arrayItem = [item.codeChars componentsSeparatedByString:@","];
            //判断是否是大小写
              if (self.isCapital) {
                  if (self.isDirectInput) {
                      
                      
                      [[GetKeyboardStatus status].textDocumentProxy insertText:item.samllSymbool];
                  } else {
                      [[RIEngineManager manger]keyboardItemClicked:arrayItem[0]];
                  }
              } else {
                  if (self.isDirectInput) {
                      [[GetKeyboardStatus status].textDocumentProxy insertText:item.symbool];
                  } else {
                      //大写
                      [[RIEngineManager manger]keyboardItemClicked:arrayItem[2]];
                  }
                  [self.engine shiftKeyStatus:0];
                  //之后转换小写
                  [self keyBoardToggleCase:btn];
              }
        }
    } else {
          NSLog(@"选中%@",text);
    }
    //打印获取的选中
//    [UIResponder inputText:text];
}
#pragma mark 切换大小写
- (void)keyBoardToggleCase:(AXKeyBoardSaseButton *)btn
{
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[AXKeyBoardSaseButton class]]) {
            AXKeyBoardSaseButton *subBtn = (AXKeyBoardSaseButton *)subview;
            if (subBtn.KeyboardButtonType == AXKeyboardButtonTypeLetter) {
                NSArray *array = [subBtn.titleLabel.text componentsSeparatedByString:@"\n"]; //从字符牌中分隔成2个元素的数组
                /*
                 * 可不可以优化
                 */
                [subBtn setTopText:array[0] text:self.isCapital ? [array[1] uppercaseString] : [array[1] lowercaseString]];
            } else if (subBtn.KeyboardButtonType == AXKeyboardButtonTypeToggleCase) {
                //大小写按钮
                subBtn.selected = !subBtn.selected;
            }
        }
    }
    self.isCapital = !self.isCapital;
}
@end
