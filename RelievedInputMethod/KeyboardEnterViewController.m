//
//  KeyboardEnterViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "KeyboardEnterViewController.h"
#import "GetKeyboardStatus.h"

#import "NineChineseKBViewController.h"
#import "FullChineseKBViewController.h"
#import "FullEnglishKBViewController.h"
#import "NineNumKBViewController.h"
#import "SymbolKBViewController.h"
#import "MenuViewController.h"
#import "ExternalViewController.h"
#import "RICandidateWordViewController.h"
#import "SwitchKeyBoardViewController.h"
@interface KeyboardEnterViewController (){
    ExternalViewController *externalVC;
    MenuViewController * menuVC;
    KeyboardBaseViewController * keyboardVC ;
    RICandidateWordViewController * candidateVC;
    SwitchKeyBoardViewController * switchKeyBoard;
}
@end

@implementation KeyboardEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    //基础设置
//    [self baseSetting];
//
//    //添加菜单栏
    [self addMenuChildVC];
//    NSLog(@"加载键盘2");
    [self addKBChildVC:[GetKeyboardStatus status].currentKeyboardType];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    //切换键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchKeyboard:) name:KEYBOARD_SWITCH object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KEYBOARD_SWITCH object:nil];
    
//   if (keyboardVC) {
//       [keyboardVC removeFromParentViewController];
//       [keyboardVC.view removeFromSuperview];
//       keyboardVC = nil;
//   }
    //引擎关闭
    [[RIEngineManager manger]keyboardDismiss];
    
    //单例释放
    [RIEngineManager destroy];//引擎管理类释放
    [MenuCandidateBar destroy];//候选词菜单销毁
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self refreshView];
}

- (void)refreshView {
    //必须在此处设置view的约束
    if (keyboardVC.view) {
        [keyboardVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo(MenuHeight);
        }];
    }
    
    if (menuVC.view) {
        [menuVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(MenuHeight);
        }];
    }
    
    if (externalVC.view && externalVC.view.superview) {
        [externalVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo(MenuHeight);
        }];
    }
    
    if (switchKeyBoard.view && switchKeyBoard.view.superview) {
        [switchKeyBoard.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo(MenuHeight);
        }];
    }
    
}

- (void)addMenuChildVC {
    menuVC =[[MenuViewController alloc]init];
    menuVC.itemArray = self.itemArray;
    [self addChildViewController:menuVC];
    [self.view addSubview:menuVC.view];
}

- (void)addKBChildVC:(KeyboardType)type{
    //消除按钮状态
    MenuItemView * titleView0 =  (MenuItemView*)self.itemArray[0];
    if (titleView0.selected == true) {
        titleView0.selected = false;
    }
    //消除按钮状态
    MenuItemView * titleView =  (MenuItemView*)self.itemArray[1];
    if (titleView.selected == true) {
        titleView.selected = false;
    }
    
    if (keyboardVC) {
        [keyboardVC removeFromParentViewController];
        [keyboardVC.view removeFromSuperview];
        keyboardVC = nil;
    }
    
    switch (type) {
        case 0:{ //中文全键
            [[RIEngineManager manger] zhKeyboardTypeExchange];
//            [[GetKeyboardStatus status] setLastKeyboardType:Keyboard_PinyinFull];
            keyboardVC =[[FullChineseKBViewController alloc]init];
            NSLog(@"--1--1-中文全键1-1-1--1-1");
        }
            break;
        case 1:{ //英文全键
            [[RIEngineManager manger] englishExchange];
//            [[RIEngineManager manger] zhKeyboardTypeExchange];
//            [[GetKeyboardStatus status] setLastKeyboardType:Keyboard_ENFull];
            keyboardVC =[[FullEnglishKBViewController alloc]init];
            NSLog(@"--1--1-英文全键1-1-1--1-1");
            
        }
            break;
        case 2:{ //中文九键
            
            [[RIEngineManager manger] zhKeyboardTypeExchange];
            
//            [[GetKeyboardStatus status] setLastKeyboardType:Keyboard_PinyinNine];
            keyboardVC =[[NineChineseKBViewController alloc]init];
            NSLog(@"--1--1-中文九键1-1-1--1-1");
        }
            break;
        case 3:{ //数字九键
            keyboardVC =[[NineNumKBViewController alloc]init];
//            [[GetKeyboardStatus status] setLastKeyboardType:Keyboard_PinyinNine];
        }
            break;
        case 4:{ //符号键盘
            keyboardVC =[[SymbolKBViewController alloc]init];
//            [[GetKeyboardStatus status] setLastKeyboardType:Keyboard_PinyinNine];
        }
            break;
        case 9:{ //候选词界面
            candidateVC =[[RICandidateWordViewController alloc]init];
            [self addChildViewController:candidateVC];
            [self.view addSubview:candidateVC.view];
            [candidateVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.mas_equalTo(MenuHeight);
            }];
        }
            break;
        default:{
            return;
        }
            break;
    }
    if (keyboardVC) {
        [self addChildViewController:keyboardVC];
        [self.view addSubview:keyboardVC.view];
    }
}

- (void)addViewInMenuBottom:(UIView *)view{
    //移除已添加的外部界面
    for (UIViewController * vc in self.childViewControllers) {
        if ([vc isKindOfClass:[ExternalViewController class]]) {
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
    }
    //添加新的外部界面
    externalVC =[[ExternalViewController alloc]init];
    [externalVC.view addSubview:view];
    [self addChildViewController:externalVC];
    [self.view addSubview:externalVC.view];
    [self.view bringSubviewToFront:externalVC.view];
}

- (void)removeMenuBottomView {
    if (externalVC) {
        if ([externalVC isKindOfClass:[ExternalViewController class]]) {
            [externalVC.view removeFromSuperview];
            [externalVC removeFromParentViewController];
            externalVC = nil;
        }
    //通知
    [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)[GetKeyboardStatus status].currentKeyboardType]];
    }
}
//转换键盘
- (void)addSwitchKeyboard {
    if ([externalVC isKindOfClass:[ExternalViewController class]]) {
        [externalVC.view removeFromSuperview];
        [externalVC removeFromParentViewController];
        externalVC = nil;
    }
    
    for (UIViewController * vc in self.childViewControllers) {
       if ([vc isKindOfClass:[SwitchKeyBoardViewController class]]) {
           [vc.view removeFromSuperview];
           [vc removeFromParentViewController];
       }
        
    }
    switchKeyBoard =[[SwitchKeyBoardViewController alloc]init];
    [self addChildViewController:switchKeyBoard];
    [self.view addSubview:switchKeyBoard.view];
    [self.view bringSubviewToFront:switchKeyBoard.view];
}
- (void)removeSwitchKeyboard {
    if (switchKeyBoard) {
        if ([switchKeyBoard isKindOfClass:[SwitchKeyBoardViewController class]]) {
            [switchKeyBoard.view removeFromSuperview];
            [switchKeyBoard removeFromParentViewController];
            switchKeyBoard = nil;
        }
    //通知
    [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)[GetKeyboardStatus status].currentKeyboardType]];
    }
}
- (void)addViewInMenuTop:(UIView *)view{

}

- (void)removeMenuTopView {

}

- (void)baseSetting {
    //此处可添加基础设置
    
    //1.设置完全访问权限 引导
//    [GetKeyboardStatus isFristLaunch];
    
}

- (void)switchKeyboard:(NSNotification *)notification {
    //移除除菜单栏外的其它vc
    for (UIViewController * vc in self.childViewControllers) {
        if (![vc isKindOfClass:[MenuViewController class]]) {
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
    }
    
    //lastKeyboardType只能是拼音九键/全键/英文全键
    KeyboardType lastType =[GetKeyboardStatus status].currentKeyboardType;
    if (lastType == Keyboard_PinyinFull || lastType == Keyboard_ENFull || lastType == Keyboard_PinyinNine) {
        [GetKeyboardStatus status].lastKeyboardType =[GetKeyboardStatus status].currentKeyboardType ;
        if (lastType == Keyboard_PinyinFull || lastType == Keyboard_PinyinNine) {
            [GetKeyboardStatus status].lastKeyCNboardType =[GetKeyboardStatus status].currentKeyboardType ;
        }
    }
    KeyboardType currentType =(KeyboardType)[notification.object intValue];
    [GetKeyboardStatus status].currentKeyboardType = currentType;
    
//
//    //判断切换键盘
    switch (currentType) {
        case Keyboard_ENFull:
            if ([GetKeyboardStatus status].numericKeypadLine) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_CHANGEHEIGHTKEYBOARD object:@"1"];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_CHANGEHEIGHTKEYBOARD object:@"0"];
            }
            break;
        case Keyboard_PinyinFull:
            if ([GetKeyboardStatus status].numericKeypadLine) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_CHANGEHEIGHTKEYBOARD object:@"1"];
            } else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_CHANGEHEIGHTKEYBOARD object:@"0"];
            }
            break;
        case Keyboard_PinyinNine:
           if ([GetKeyboardStatus status].numericKeypadLine) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_CHANGEHEIGHTKEYBOARD object:@"0"];
            }
        default:
            break;
    }
    //无数字键盘情况
    [self addKBChildVC:currentType];
}

@end

