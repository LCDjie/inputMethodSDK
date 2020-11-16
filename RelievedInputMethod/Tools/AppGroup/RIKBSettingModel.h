//
//  RIKBSettingModel.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RIKBFuzzySettingModel;
NS_ASSUME_NONNULL_BEGIN

@interface RIKBSettingModel : NSObject

@property (nonatomic, assign) BOOL chineseThink;//!<中文联想
@property (nonatomic, assign) BOOL showEmoji;//!<显示表情
@property (nonatomic, assign) BOOL longWordsPredict;//!<长词预测
@property (nonatomic, assign) BOOL fuzzy;//!<模糊音开启
@property (nonatomic, assign) BOOL jianFanChange;//!<繁体
@property (nonatomic, assign) BOOL spaceChooseFirstCandidate;//!<空格选候选词
@property (nonatomic, assign) BOOL showUnCommonWords;//!<显示生僻字
@property (nonatomic, strong) RIKBFuzzySettingModel *fuzzySet;//!<模糊音集合

@end

@interface RIKBFuzzySettingModel : NSObject

@property (nonatomic, assign) BOOL iang;
@property (nonatomic, assign) BOOL ln;
@property (nonatomic, assign) BOOL g;
@property (nonatomic, assign) BOOL uang;
@property (nonatomic, assign) BOOL sh;
@property (nonatomic, assign) BOOL f;
@property (nonatomic, assign) BOOL ch;
@property (nonatomic, assign) BOOL zh;
@property (nonatomic, assign) BOOL ang;
@property (nonatomic, assign) BOOL eng;
@property (nonatomic, assign) BOOL ing;
@property (nonatomic, assign) BOOL lr;

@end

NS_ASSUME_NONNULL_END
