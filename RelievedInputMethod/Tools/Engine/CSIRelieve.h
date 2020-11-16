//
//  CSIRelieve.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
封装C++引擎
*/

#import <Foundation/Foundation.h>
#include "niudun_ime_interface.h"

NS_ASSUME_NONNULL_BEGIN

//中英文状态切换
typedef NS_ENUM(NSInteger, CSIRelieveInputMode) {
    CSIRelieveInputModeSeamless = 0, //中英文状态
    CSIRelieveInputModeNumber = 1, //数字状态
};

@protocol CSIRelieveDelegate <NSObject>

/**
 引擎代理

 @param candidateWords 候选词
 @param aPinyinWords 候选拼音数组
 @param aConfirmingPinyin 待确定的拼音
 @param aOnScreenText 上屏词，可能为空
 @param preWordAndCurPinyin 前置词和拼音，可能为空
 */
- (void)didFetchInputData: (NSArray<NSString *> *)candidateWords
                   pinyin: (NSArray<NSString *> *)aPinyinWords
         confirmingPinyin: (NSString *)aConfirmingPinyin
             onScreenText: (NSString *)aOnScreenText
      preWordAndCurPinyin: (NSString *)preWordAndCurPinyin;
@end

@interface CSIRelieve : NSObject
@property(nonatomic, weak) id<CSIRelieveDelegate> delegate;
- (void)initialWithSetOption: (int[_Nonnull NIUDUN_MAX_OPTION_COUNT])set
                aFuzzyOption: (int[_Nonnull ND_IME_MAX_FUZZY_SETTING])fuzzy;

//分词
- (void)separateWord;

//键盘敲击
- (void)keyboardItemClicked: (unsigned short)oneKey;

//符号敲击
- (void)symbolItemClicked: (unsigned short)oneKey;

//点击候选词索引
- (void)clickCandidateAt: (int)index;

//点击候选词文字
- (void)clickCandidateBy: (NSString *)text;

//点击拼音
- (void)clickSpellLetter: (NSString *)letter;

//123切换
- (void)numberExchange;

//中英文切换
- (void)englishExchange;

- (void)zhKeyboardTypeExchange ;

//删除退格
- (void)backDelete;

//重输
- (void)reset;

//键盘消失
- (void)keyboardDismiss;

//英文状态下大小写切换   0:小写， 1:首字母大写， 2:全大写  (目前不支持首字母大写)
- (void)shiftKey:(int)status;
@end

NS_ASSUME_NONNULL_END
