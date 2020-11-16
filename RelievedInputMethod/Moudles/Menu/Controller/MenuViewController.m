//
//  MenuViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCandidateBar.h"

@interface MenuViewController ()<RIEngineManagerDelegate>

@property(nonatomic, strong) MenuToolsBar * toolsBar; //工具栏
@property(nonatomic, strong)MenuCandidateBar *candidateBar; //候选词栏
@property(nonatomic, strong)RIEngineManager *engine; //引擎

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Main_Color;
    //工具栏设置
    [self.toolsBar configWithItems:self.itemArray];
    
    //引擎初始化
    self.engine =[RIEngineManager manger];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加引擎代理
    [self.engine addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除引擎代理
    [self.engine removeDelegate:self];
}

- (MenuToolsBar *)toolsBar {
    if (!_toolsBar) {
        self.toolsBar =[[MenuToolsBar alloc]initWithFrame:CGRectZero];
        [self.view addSubview:self.toolsBar];
        [self.toolsBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _toolsBar;
}

- (MenuCandidateBar *)candidateBar {
    if (!_candidateBar) {
        self.candidateBar =[MenuCandidateBar shareInstance];
    
        [self.view addSubview:self.candidateBar];
        [self.candidateBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _candidateBar;
}

#pragma -mark RIEngineManagerDelegate 引擎代理方法
- (void)getFetchInputData:(NSArray<NSString *> *)candidateWords pinyin:(NSArray<NSString *> *)aPinyinWords confirmingPinyin:(NSString *)aConfirmingPinyin onScreenText:(NSString *)aOnScreenText preWordAndCurPinyin:(NSString *)preWordAndCurPinyin {
    
    //刷新候选词view
    self.candidateBar.dataArray =[NSMutableArray arrayWithArray:candidateWords];
    self.candidateBar.spellArray = aPinyinWords;
    self.candidateBar.spellStr = aConfirmingPinyin;
    [self.candidateBar reloadCollectionData];
    
    //有上屏词时则展示
    if (aOnScreenText.length >0) {
        [RIFuntionBtClickManger showOnScreen:aOnScreenText];
    }
    
    //工具栏，候选词栏的展示逻辑
    if (candidateWords.count == 0) {
        self.toolsBar.hidden =NO;
        self.candidateBar.hidden =YES;
    }else{
        self.toolsBar.hidden =YES;
        self.candidateBar.hidden =NO;
    }
}

@end
