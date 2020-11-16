//
//  BaseModuleView.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/23.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "BaseModuleView.h"

@interface BaseModuleView ()
@end

@implementation BaseModuleView

- (instancetype)init {
    self =[super init];
    if (self) {
        self.backgroundColor = Keyboard_Background_Color;
    }
    return self;
}

- (void)layoutWithWidth:(float)width height:(float)height{

}

- (void)manageActionWithCommonButton:(AXKeyBoardSaseButton *)bt{

    //按钮按下
    [bt addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    //
    [bt addTarget:self action:@selector(btnTouchClick:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    //按钮取消
    [bt addTarget:self action:@selector(btnTouchCancel:) forControlEvents:UIControlEventTouchCancel];
}

- (void)btnTouchDown:(AXKeyBoardSaseButton*)bt {
    
}

- (void)btnTouchClick:(AXKeyBoardSaseButton*)bt {
    
}

- (void)btnTouchCancel:(AXKeyBoardSaseButton*)bt {
    
}

- (RIEngineManager *)engineManager{
    if (!_engineManager) {
        _engineManager = [RIEngineManager manger];
    }
    return _engineManager;
}

@end
