//
//  GetKeyboardStatus.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
项目公共信息管理类
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetKeyboardStatus : NSObject

+ (instancetype)status ;
+ (BOOL)isFristLaunch ; //判断首次启动
@property (nonatomic, assign) BOOL hasFullAccess; //判断开启访问权限
@property (nonatomic, assign) BOOL shouldAddChangeKeyboardButton; //判断是否需要添加键盘切换按钮

@property (nonatomic, assign) BOOL numericKeypadLine; //是否开启数字键盘行

@property (nonatomic, assign) KeyboardType currentKeyboardType; //当前键盘类型
@property (nonatomic, assign) KeyboardType lastKeyboardType; //上一个键盘类型
@property (nonatomic, assign) KeyboardType lastKeyCNboardType; //上一个中文键盘类型

@property (nonatomic, strong) id <UITextDocumentProxy> textDocumentProxy;

@end

NS_ASSUME_NONNULL_END
