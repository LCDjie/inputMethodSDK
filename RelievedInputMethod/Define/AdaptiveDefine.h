//
//  AdaptiveDefine.h
//  RelievedInput
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
尺寸宏定义
*/

#ifndef AdaptiveDefine_h
#define AdaptiveDefine_h

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define kDefaultHeight          (SCREEN_WIDTH > SCREEN_HEIGHT ? (158+26+38) : (218+26+38))  //!<默认高度

#define MenuHeight 26+38
#define KeyBoardHeight (SCREEN_WIDTH > SCREEN_HEIGHT ? (158) : (218))

#define ScreespecOne [[UIScreen mainScreen] bounds].size.width / 375 //单位宽

//九宫格键盘
#define NineKB_Space_X  6 //按钮间列间距
#define NineKB_Space_Y  6 //按钮行间距
#define NineKB_Space_Bound_X  4 //左右边界
#define NineKB_Space_Bound_Y  6 //上下边界
#define NineKB_Center_Bt_Width(baseWidth)  (baseWidth - NineKB_Space_Bound_X * 2 - NineKB_Space_X * 4)/(3+2*0.65) //九宫格按钮宽度
#define NineKB_Bt_Height(baseHeight)  (baseHeight - NineKB_Space_Bound_Y*2 - NineKB_Space_Y*3)/4 //按钮高度
//#define NineKB_Side_Bt_Width(baseWidth)  baseWidth*0.65 //左右边视图的宽度
#define NineKB_Side_Bt_Width(baseWidth)  NineKB_Center_Bt_Width(baseWidth) *0.65 //左右边视图的宽度


//字母键盘按钮水平间距
#define kAXASCIIKeyboardBtnHorizontalSpace 6
//字母键盘按钮垂直间距
#define kAXASCIIKeyboardBtnVerticalSpace 8
//纯键盘高度
#define kAXCustomKeyboardHeight 220
//字母键盘高度
#define kAXASCIIKeyboardBtnHeight (kAXCustomKeyboardHeight- kAXASCIIKeyboardBtnVerticalSpace*5)/4
//全键盘最后一行小按钮宽度
#define kAXAllKLWidth 44*ScreespecOne
//英文全键盘每行数据
#define allKeyBoardFirstLineNumber 10
#define allKeyBoardSecondLineNumber 9
#define allKeyBoardThirdLineNumber 9
#define allKeyBoardFourthLineNumber 9




#endif /* AdaptiveDefine_h */
