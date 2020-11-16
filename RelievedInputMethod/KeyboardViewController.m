//
//  KeyboardViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeyboardEnterViewController.h"
#import "MenuItemView.h"
#import "SettingKeyBoardView.h"
#import "Monitor.h"
@interface KeyboardViewController (){
    KeyboardEnterViewController * enterVC;
}
@property (nonatomic, assign) CGFloat portraitHeight;//键盘默认高度
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) UIView *KbMainView; //需要添加有约束的view，否则高度设置无效
@property (nonatomic, strong) SettingKeyBoardView *settingBoardView;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
        NSLog(@"启动键盘");
        
        // 开始卡顿监听
        [[Monitor shareInstance] startMonitor];
        
        //键盘整体高度设置
        self.portraitHeight = kDefaultHeight;
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:self.portraitHeight];
        self.heightConstraint.priority = UILayoutPriorityRequired - 1; // 修改键盘默认高度
        [self.view addConstraint: self.heightConstraint];
        
        //需要添加有约束的view，否则高度设置无效
        self.KbMainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH ,kDefaultHeight)];
        [self.view addSubview:self.KbMainView];
        [self.KbMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(kDefaultHeight+ kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace);
        }];
        self.portraitHeight = kDefaultHeight;
        self.heightConstraint.constant = self.portraitHeight;
        self.view.backgroundColor =[UIColor whiteColor];

    //    //入口设置
        enterVC =[[KeyboardEnterViewController alloc]init];
        enterVC.itemArray =[self settingMenuItem] ;//自定义菜单栏

        [self.KbMainView addSubview:enterVC.view];
        [self addChildViewController:enterVC];
        [enterVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.KbMainView);
            make.height.mas_equalTo(kDefaultHeight+ kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace);
        }];
        
        //上屏工具
        [GetKeyboardStatus status].textDocumentProxy = self.textDocumentProxy;
        
        //切换键盘的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchKeyboard:) name:KEYBOARD_SWITCHSYSTEMBOARD object:nil];
        
        //    //更改键盘高度的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:KEYBOARD_CHANGEHEIGHTKEYBOARD object:nil];
        
        if (@available(iOS 11.0, *)) {
            [GetKeyboardStatus status].hasFullAccess = self.hasFullAccess;
            //判断手机类型
            if (SCREEN_HEIGHT >= 812) {
                [GetKeyboardStatus status].shouldAddChangeKeyboardButton = false;
            } else {
                [GetKeyboardStatus status].shouldAddChangeKeyboardButton = true;
            }

        } else {
            //切换键盘按钮自带
            [GetKeyboardStatus status].shouldAddChangeKeyboardButton = true;
        }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    //隐藏键盘的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dropKeyboard) name:KEYBOARD_DISMISS object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KEYBOARD_DISMISS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KEYBOARD_SWITCHSYSTEMBOARD object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self && self.KbMainView) {
        [self.KbMainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(kDefaultHeight + kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace);
        }];
    }
}
- (void)setMessage {

}

-(void)changeKeyBoard:(NSNotification *)notification{
    int heightType = [notification.object intValue];
    if (heightType == 0) {
        //键盘整体高度设置
        self.portraitHeight = kDefaultHeight;
        self.heightConstraint.constant = self.portraitHeight;
        if (self && self.KbMainView) {
            [self.KbMainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.height.mas_equalTo(kDefaultHeight);
            }];
            [enterVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.KbMainView);
                make.height.mas_equalTo(kDefaultHeight);
            }];
        }
    } else {
        //键盘整体高度设置
        self.portraitHeight = kDefaultHeight + kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace;
        self.heightConstraint.constant = self.portraitHeight;
        if (self && self.KbMainView) {
            self.KbMainView.frame = CGRectMake(0, 0, SCREEN_WIDTH ,kDefaultHeight + kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace);
            [self.KbMainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.top.equalTo(self.view);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.height.mas_equalTo(kDefaultHeight+ kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace);
            }];
            [enterVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.KbMainView);
                make.height.mas_equalTo(kDefaultHeight+ kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace);
            }];
//            [enterVC refreshView];
        }

    }

}

//旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    self.portraitHeight = kDefaultHeight;
    self.heightConstraint.constant = self.portraitHeight;
}

#pragma mark - UITextInputDelegate
- (void)textWillChange:(id<UITextInput>)textInput {
    
}

- (void)textDidChange:(id<UITextInput>)textInput {
    [GetKeyboardStatus status].textDocumentProxy =self.textDocumentProxy;
    //return按钮状态改变
    [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_RETURNTYPECHANGE object:[NSString stringWithFormat:@"%ld",(long)self.textDocumentProxy.returnKeyType]];
}

- (NSArray *)settingMenuItem {
    //自定义菜单栏，代码可以放在自封装的view中
    NSArray * iconArray = @[@"bar_anxingrey",@"bar_keyboard"];
    NSArray * selectIconArray = @[@"bar_anxinbule_select",@"bar_keyboard_select"];
    NSMutableArray *mArray =[[NSMutableArray alloc]init];
    for (int i =0; i<iconArray.count; i++) {
        NSString * selctedStr =selectIconArray[i];
        MenuItemView *menuView =[[MenuItemView alloc]initWithImage:iconArray[i] selectImage:selctedStr];
        menuView.tag = i;
        [menuView addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [mArray addObject:menuView];
    }
//    MenuItemView * titleView =[[MenuItemView alloc]initWithTitle:@"你好"];
//    titleView.tag =4;
//    [titleView addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
//    [mArray addObject:titleView];
    return mArray;
}

- (void)menuAction:(MenuItemView *)bt {
    //菜单栏点击事件，代码可以放在自封装的view中
    [bt updateSelectStatus];
    for (int i = 0; i<enterVC.itemArray.count; i++) {
        if (i == bt.tag) {
        } else {
            MenuItemView * titleView =  (MenuItemView*)enterVC.itemArray[i];
            titleView.selected = false;
        }
    }
    
    switch (bt.tag) {
        case 0:{
            if (bt.selected) {
                UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,KeyBoardHeight)];
                
                addView.backgroundColor =[UIColor orangeColor];
                
                self.settingBoardView = [[SettingKeyBoardView alloc]initWithFrame:addView.frame];
                
                [addView addSubview:self.settingBoardView];
                
                [enterVC addViewInMenuBottom:addView];
                
            }else{
//                [addView removeFromSuperview];
                [enterVC removeMenuBottomView];
            }
        }
            break;
            
        case 1 :{
            if(bt.selected) {
                [enterVC addSwitchKeyboard];
            } else {
                [enterVC removeSwitchKeyboard];
            }
        }
            break;
            
        case 2 :{
//            [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)Keyboard_ENFull]];
        }
            break;
            
        default:
            break;
    }
}

#pragma -mark NSNotification
-(void)dropKeyboard {
    [self dismissKeyboard];  
}
//切换键盘
-(void)switchKeyboard:(NSNotification *)notification{
//    [self advanceToNextInputMode];
    NSArray *msg = notification.object;
    [self handleInputModeListFromView:msg[0] withEvent:msg[1]];
}
@end
