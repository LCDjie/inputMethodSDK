//
//  CharacterModel.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/20.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
各键盘按钮标题数据源model
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CharacterModel : NSObject

@property (nonatomic, strong) NSArray <CharacterModel *>* symbools;

@end

//普通输入按钮
@interface MainButtonModel : CharacterModel

@property (nonatomic, copy) NSString *symbool;//!<默认输入法按钮的值（默认是大写）
@property (nonatomic, copy) NSString *subSymbool;//!<默认值上边的副值，一般都是符号或者数字，只存在输入按钮上，功能按钮上是没有的
@property (nonatomic, copy) NSString *samllSymbool;//!<小写
@property (nonatomic, copy) NSString *code;//!<引擎键值

@property (nonatomic, copy) NSString *codeType;//!<引擎键值类型

@property (nonatomic, copy) NSString *kbType;//!< 键盘类型 0是九宫格中文   1是全键盘中文   2是全键盘英文
@property (nonatomic, copy) NSString *chars;//!<长按时显示的字符
@property (nonatomic, copy) NSString *codeChars;//!<长按时显示的字符code
@property (nonatomic, strong) NSArray <NSString *>*charsArray;//!<长按时显示的字符数组，只需要传入这个数组就行了，chars只是方便了转模型用
@property (nonatomic, strong) NSArray <NSString *>*codeArray;//!<长按时显示的字符数组code
@end

//功能按钮
@interface SideButtonModel : CharacterModel

@property (nonatomic, copy) NSString *symbool;//!<默认输入法按钮的值（默认是大写）
@property (nonatomic, copy) NSString *imageName;//!<图片名字

@end

//九宫格中文实体类
@interface NineChineseModel : NSObject
@property (nonatomic, strong) NSArray <NSString *>*punctuations;//!<标点符号
@property (nonatomic, strong) NSArray <MainButtonModel *>* inputs;//!<输入按钮数组
@property (nonatomic, strong) NSArray <SideButtonModel *>* rightKeys;//!<右边数组
@property (nonatomic, strong) NSArray <SideButtonModel *>* bottomKeys;//!<下边数组
@end

//数字键盘按钮
@interface NineNumberModel : NSObject
@property (nonatomic, strong) NSArray <NSString *>*punctuations;//!<标点符号
@property (nonatomic, strong) NSArray <NSString *>* inputs;//!<输入按钮数组
@end

//符号键盘按钮
@interface SpecificSymbolTypeModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *kbType;
@property (nonatomic, copy) NSString *symbools;
@property (nonatomic, strong) NSArray <NSString *> *symboolArrays;
@end

NS_ASSUME_NONNULL_END
