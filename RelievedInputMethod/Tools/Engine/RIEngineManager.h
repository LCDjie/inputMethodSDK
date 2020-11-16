//
//  RIEngineManager.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
提供外部调用引擎的方法
*/

#import <Foundation/Foundation.h>

@class CSIRelieve ;
NS_ASSUME_NONNULL_BEGIN

@protocol RIEngineManagerDelegate <NSObject>

/**
 引擎代理
 
 @param candidateWords 候选词
 @param aPinyinWords 候选拼音数组
 @param aConfirmingPinyin 待确定的拼音
 @param aOnScreenText 上屏词，可能为空
 @param preWordAndCurPinyin 前置词和拼音，可能为空
 */
- (void)getFetchInputData: (NSArray<NSString *> *)candidateWords
                   pinyin: (NSArray<NSString *> *)aPinyinWords
         confirmingPinyin: (NSString *)aConfirmingPinyin
             onScreenText: (NSString *)aOnScreenText
      preWordAndCurPinyin: (NSString *)preWordAndCurPinyin;

@end

@interface RIEngineManager : NSObject
@property (nonatomic, weak)id <RIEngineManagerDelegate >delegate;

+ (instancetype)manger ;

+ (void)destroy ;

/**
 分词
 */
- (void)separateWord;


/**
 键盘敲击
 */
- (void)keyboardItemClicked: (NSString *)oneKey;


/**
 符号敲击
 */
- (void)symbolItemClicked: (NSString *)oneKey;


/**
 点击候选词索引
 */
- (void)clickCandidateAt:(int)index;

/**
点击候选词文字
*/
- (void)clickCandidateBy: (NSString *)text;

/**
 点击拼音
 */
- (void)clickSpellLetter: (NSString *)letter;


/**
 123切换
 */
- (void)numberExchange;


/**
 中英文切换
 */
- (void)englishExchange;

/**
 拼音九键和全键盘切换
 */
- (void)zhKeyboardTypeExchange;

/**
 删除退格
 */
- (void)backDelete;


/**
 重输
 */
- (void)reset;


/**
 英文状态下大小写切换   0:小写， 1:首字母大写， 2:全大写  (目前不支持首字母大写)
 */
- (void)shiftKeyStatus:(int)staus;


/**
 键盘消失
 */
- (void)keyboardDismiss;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
