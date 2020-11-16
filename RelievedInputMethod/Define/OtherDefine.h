//
//  OtherDefine.h
//  RelievedInput
//
//  Created by 靳翠翠 on 2020/7/10.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
其它信息宏定义
*/

#ifndef OtherDefine_h
#define OtherDefine_h
#import <Foundation/Foundation.h>

static NSString *const DEFAULTS_FIRST_LAUNCH_KEY = @"first_launch";
static NSString *const kAppGroupIdentifier = @"group.com.ymtim.products";

//判空
#define kIsEmptyString(s) (s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0))

#define kIsEmptyNum(s) (s == nil || [s isKindOfClass:[NSNull class]] || ([s isEqualToNumber:@0]))

#endif /* OtherDefine_h */
