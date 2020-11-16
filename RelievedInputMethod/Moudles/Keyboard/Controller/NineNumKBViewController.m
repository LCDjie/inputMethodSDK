//
//  NineNumKBViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "NineNumKBViewController.h"
#import "NumberSudokuView.h"
#import "NineLeftSide.h"
#import "NineRightSide.h"
#import "NineBottomView.h"

@interface NineNumKBViewController ()
@property (nonatomic, strong)NumberSudokuView *sudoKuView ; //九宫格
@property(nonatomic,strong)NineLeftSide *leftView; //左侧栏
@property(nonatomic,strong)NineRightSide *rightView; //右侧栏
@property(nonatomic,strong)NineBottomView *bottomView; //底栏
@end

@implementation NineNumKBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建九宫格
    self.sudoKuView = [[NumberSudokuView alloc] init];
    [self.view addSubview:self.sudoKuView];
    
    // 创建右侧栏
    NSMutableArray *rightArray =[[NSMutableArray alloc]init];
    NSMutableArray* typeArray = [[NSMutableArray alloc]init];
    [typeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeASCIIDelete]];
    [typeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeDecimal]];
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
    [bottomTypeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeToBack]];
    [bottomTypeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeZero]];
    [bottomTypeArray addObject:[NSString stringWithFormat:@"%ld",(long)AXKeyboardButtonTypeSpace]];
    for (int i =0; i<4; i++) {
        AXKeyBoardSaseButton *btn = [AXKeyBoardSaseButton buttonWithType:UIButtonTypeCustom];
        btn.KeyboardButtonType =(AXKeyboardButtonType)[bottomTypeArray[i] intValue];
        [self manageActionWithFunctionButton:btn];
        [bottomArray addObject:btn];
    }
    self.bottomView =[[NineBottomView alloc]initWithItems:bottomArray AndKeyboardType:Keyboard_NumNine];
    [self.view addSubview:self.bottomView];
    
    //创建左侧栏
    self.leftView =[[NineLeftSide alloc]initWithFrame:CGRectMake(NineKB_Space_Bound_X, NineKB_Space_Bound_Y, 20,50)];
    [self.view addSubview:self.leftView];
}

//约束布局必须在此方法内，否则布局无效
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    //九宫格布局
    [self.sudoKuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(NineKB_Space_Bound_X + NineKB_Side_Bt_Width(width)) ;
        make.right.mas_equalTo(-(NineKB_Space_Bound_X + NineKB_Side_Bt_Width(width)));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo( height -(NineKB_Space_Bound_Y + NineKB_Bt_Height(height)));
    }];
    [self.sudoKuView layoutWithWidth:width height:height];
    
    //右侧栏布局
    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sudoKuView.mas_right);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    [self.rightView layoutWithWidth:width height:height];
    
    //底栏布局
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.rightView.mas_left);
        make.top.mas_equalTo(self.sudoKuView.mas_bottom);
        make.bottom.mas_equalTo(self.rightView);
    }];
    [self.bottomView layoutWithWidth:width height:height];
    
    //左侧栏布局
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NineKB_Space_Bound_Y);
        make.bottom.mas_equalTo(self.sudoKuView.mas_bottom).offset(-NineKB_Space_Y);
        make.left.mas_equalTo(NineKB_Space_Bound_X);
        make.right.mas_equalTo(self.sudoKuView.mas_left);
    }];
    [self.leftView layoutWithWidth:width height:height];
}

@end
