//
//  CharacterManger.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/20.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
所有键盘 按钮标题 数据源
*/

#import <Foundation/Foundation.h>
#import "CharacterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CharacterManger : NSObject

+ (NineChineseModel *)getNineChineseKeyboardSymbool ; //拼音九键数据源
+ (NineNumberModel *)getNineNumberKeyboardSymbool ; //数字键盘数据源
+ (NSArray *)getSpecificSymbool ; //符号键盘数据源
+ (NSMutableArray *)getAllEnglishKeyboardSymbool; //获取所有全键盘英文
+ (NSMutableArray *)getAllChineseKeyboardSymbool;  //获取所有的全键盘中文
@end

NS_ASSUME_NONNULL_END
