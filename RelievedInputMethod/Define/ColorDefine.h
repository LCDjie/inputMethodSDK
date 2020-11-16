//
//  ColorDefine.h
//  RelievedInput
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
颜色宏定义
*/

#ifndef ColorDefine_h
#define ColorDefine_h


#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//键盘按钮主Label文字颜色
#define Btn_Main_Title_Color [UIColor ly_colorWithHexString:@"#000000"]

//键盘按钮 上Label文字颜色
#define Btn_Top_Title_Color [UIColor ly_colorWithHexString:@"#C8C8C8"]

//选中字体颜色
#define ToolsBar_Text_Selected_Color [UIColor ly_colorWithHexString:@"#419ED8"]

//字体颜色
#define ToolsBar_Text_Color [UIColor ly_colorWithHexString:@"#7F7F7F"]

//菜单栏边框颜色  
#define Menu_Border_Color [UIColor lightGrayColor].CGColor

// 键盘其他按钮背景色
#define Bt_Other_Background_Color [UIColor ly_colorWithHexString:@"#B6B6B6"]

//键盘底色
//#define Keyboard_Background_Color [UIColor ly_colorWithHexString:@"#DFE3E6"]

#define Keyboard_Background_Color [UIColor ly_colorWithHexString:@"#D6D8DD"]


//按钮选中
#define Keyboard_Select_Color [UIColor ly_colorWithHexString:@"#D9DDE3"]

// 主题颜色
#define Main_Color [UIColor whiteColor]

// 分隔线颜色
#define Line_Color [UIColor ly_colorWithHexString:@"#E3E3E3"]
//按键小字体颜色
#define kAXKeyboardBtnTopTitleColor [UIColor ly_colorWithHexString:@"575757"]

//浅色字体
#define kAXKeyboardBtnLightTitleColor [UIColor ly_colorWithHexString:@"3d3d3d"]

//有背景的按钮颜色
#define kAXKeyboardBtnDefaultColor [UIColor ly_colorWithHexString:@"BABFC7"]
//数字键盘边框颜色
#define kAXKeyboardBtnLayerColor [UIColor ly_colorWithHexString:@"dadada"]
//top字体颜色
#define kBtnTopTitleColor [UIColor ly_colorWithHexString:@"#333333"]
//通用的选中的黄色
#define kGeneralSelectColor [UIColor ly_colorWithHexString:@"#419ED8"]
//选择键盘背景颜色
#define kSwitchBoardColor [UIColor ly_colorWithHexString:@"#D6D8DD"]
#define kSwitchBoardTextColor [UIColor ly_colorWithHexString:@"#848485"]


#endif /* ColorDefine_h */
