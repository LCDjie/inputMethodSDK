//
//  FontDefine.h
//  RelievedInput
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
字符字号宏定义
*/

#ifndef FontDefine_h
#define FontDefine_h

//字号

//全键盘 主Label 大写字母
#define FontRegular21 [UIFont systemFontOfSize:21]

/*
 *全键盘 主Label 小写字母
 *拼音九键 主Label
 *横屏 全键盘 小写字母
 */
#define FontRegular17 [UIFont systemFontOfSize:17]

/*
 *键盘其他按钮字号
 *横屏 全键盘 大写字母
 */
#define FontRegular16 [UIFont systemFontOfSize:16]

//横屏 拼音九键 主Label字号
#define FontRegular14 [UIFont systemFontOfSize:14]

//键盘按钮 上Label字号
#define FontRegular10 [UIFont systemFontOfSize:10]

//字体
#define FontBold(x) [UIFont fontWithName:@"PingFang-SC-Bold" size:x]
#define FontRegular(x) [UIFont fontWithName:@"PingFang-SC-Regular" size:x]
#define FontMedium(x) [UIFont fontWithName:@"PingFang-SC-Medium" size:x]

#endif /* FontDefine_h */
