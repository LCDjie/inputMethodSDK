//
//  KeyboardDefine.h
//  RelievedInput
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
键盘类型等的枚举
*/

#ifndef KeyboardDefine_h
#define KeyboardDefine_h

// 键盘类型
typedef NS_OPTIONS(NSUInteger, KeyboardType) {
    Keyboard_PinyinFull         = 0,   // 中文全键
    Keyboard_ENFull             = 1,   // 英文全键
    Keyboard_PinyinNine         = 2,   // 拼音九键
    Keyboard_NumNine            = 3,   // 数字九键
    Keyboard_SymbolCollection   = 4,   // 符号方键
    Keyboard_SymbolFull         = 5,   // 符号26键
    keyboard_WuBiFull           = 6,   // 全键盘五笔
    keyboard_BiHuaNine          = 7,   // 笔画九键
    Keyboard_HandleWrite        = 8,   // 手写键盘
    Keyboard_Candidate          = 9,   // 候选词界面
};

// 换行键类型
typedef NS_ENUM(NSInteger, ReturnKeyType) {
    ReturnKeyDefault,
    ReturnKeyGo,
    ReturnKeyJoin,
    ReturnKeyNext,
    ReturnKeyRoute,         // 换行
    ReturnKeySearch,
    ReturnKeySend,          // 发送
    ReturnKeyDone,
    ReturnKeyOkay,
    ReturnKeySure,          // 确定
};

// 键盘的输入状态
typedef NS_ENUM(NSInteger, KeyboardInputStatus) {
    InputStatus_Not,        // 还没有输入
    InputStatus_Inputting,  // 输入中
    InputStatus_Done,       // 输入完成
    InputStatus_Encryptting,// 正在加密
    InputStatus_Searching,  // 正在搜索
};

typedef NS_OPTIONS(NSUInteger, InputType) {
    InputType_chinese = 0, //!<中文状态
    InputType_english = 1, //!<英文状态
};

//predictive(双行/单行)
typedef NS_OPTIONS(NSUInteger, PredictiveMode) {
    Predictive_DoubleLine = 0,  // 双行模式
    Predictive_SingleLine = 1,  // 单行模式
};

//按钮类型
typedef NS_ENUM(NSInteger, AXKeyboardButtonType) {
    AXKeyboardButtonTypeNone = 10000,   //空白
    AXKeyboardButtonTypeNumber,         //数字
    AXKeyboardButtonTypeLetter,         //字母
    AXKeyboardButtonTypeNineLetter,         //九键字母
    AXKeyboardButtonTypeFullBoardNumber,//全键盘对应的数字按钮
    AXKeyboardButtonTypeDirectInput,    //直输
    AXKeyboardButtonTypeEnToCh,         //英文切中文
    AXKeyboardButtonTypeChToEn,         //中文切英文
    AXKeyboardButtonTypeSymbol,         //符号键盘按钮
    AXKeyboardButtonTypeDelete,         //删除按钮
    AXKeyboardButtonTypeResign,         //数字键盘收起
    AXKeyboardButtonTypeDecimal,        //数字键盘小数点
    AXKeyboardButtonTypeEndCH,          //句号。中文
    AXKeyboardButtonTypeZero,           //数字键盘0
    AXKeyboardButtonTypeABC,            //切换英文键盘
    AXKeyboardButtonTypeComplete,       //完成
    AXKeyboardButtonTypeComma,          //逗号,英文
    AXKeyboardButtonTypeCommaCN,        //逗号,中文
    AXKeyboardButtonTypeToggleCase,     //大小写
    AXKeyboardButtonTypeParticiples,    //分词
    AXKeyboardButtonTypeASCIIDelete,    //字母键盘的删除按钮
    AXKeyboardButtonTypeToNumber,       //切换数字键盘按钮
    AXKeyboardButtonTypeASCIINewline,   //键盘换行
    AXKeyboardButtonTypeASCIIDecimal,   //英文字母键盘小数点
    AXKeyboardButtonTypeASCIIEnterAgain,//重输
    AXKeyboardButtonTypeAite,           //@符
    AXKeyboardButtonTypeLineFeed,       //换行
    AXKeyboardButtonTypeSpace,          //空格
    AXKeyboardButtonTypeToBack,         //返回
    AXKeyboardButtonTypeSwitchKeyBoard, //切换键盘
};

#endif /* KeyboardDefine_h */
