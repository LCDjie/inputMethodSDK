//
//  RIEngineManager.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "RIEngineManager.h"
#import "CSIRelieve.h"
static RIEngineManager * rIEngineManager ;
static dispatch_once_t rIEngineManagerOnceToken ;

@interface RIEngineManager ()<CSIRelieveDelegate>
@property (nonatomic, strong) CSIRelieve *relieveManager;
@property (nonatomic, strong) NSMutableArray *delegateArray;
@property (nonatomic, strong) NSMutableDictionary *delegateDic;

@end

@implementation RIEngineManager

+ (instancetype)manger {

    dispatch_once(& rIEngineManagerOnceToken, ^{
        rIEngineManager =[[RIEngineManager alloc]init];
    });
    return rIEngineManager;
}

- (instancetype) init {
    self =[super init];
    if (self) {
        self.delegateArray =[[NSMutableArray alloc]init];
        self.delegateDic =[[NSMutableDictionary alloc]init];
        [self configEngine];
    }
    return self;;
}

+ (void)destroy
{
    rIEngineManagerOnceToken = 0;
    rIEngineManager = nil;
}

- (void)addDelegate:(id<RIEngineManagerDelegate>)delegate {
    NSString * key =[[delegate class] description];
    if ([[self.delegateDic allKeys] containsObject:key]) {
        return;
    }
    [self.delegateDic setValue:key forKey:key];
    
    if ([delegate isKindOfClass:[BaseModuleView class]] || [delegate isKindOfClass:[UIViewController class]]) {
        [self.delegateArray addObject:delegate];
    }
}

- (void)removeDelegate:(id)delegate{
    NSString * key =[[delegate class] description];
    [self.delegateDic removeObjectForKey:key];
    [self.delegateArray removeObject:delegate];
}

#pragma mark - 引擎配置
- (void)configEngine {
    RIKBSettingModel *setModel = [RIAppGroupManager getInputSettingModel];
    int setData[NIUDUN_MAX_OPTION_COUNT] = {
        !setModel.showUnCommonWords,
        0,
        !setModel.longWordsPredict,
        !setModel.showEmoji,
        0,
        setModel.fuzzy,
        setModel.jianFanChange,
        0,
        0
    };
    int fuzzyOption[ND_IME_MAX_FUZZY_SETTING] = {
        setModel.fuzzySet.zh,
        setModel.fuzzySet.ch,
        setModel.fuzzySet.sh,
        setModel.fuzzySet.ln,
        setModel.fuzzySet.f,
        setModel.fuzzySet.lr,
        setModel.fuzzySet.g,
        setModel.fuzzySet.ang,
        setModel.fuzzySet.eng,
        setModel.fuzzySet.ing,
        setModel.fuzzySet.iang,
        setModel.fuzzySet.uang
    };
    [self.relieveManager initialWithSetOption:setData aFuzzyOption:fuzzyOption];
}

- (CSIRelieve *)relieveManager {
    if (_relieveManager == nil) {
        _relieveManager = [[CSIRelieve alloc] init];
        _relieveManager.delegate = self;
    }
    return _relieveManager;
}

- (void)shiftKeyStatus:(int)staus{
    [self.relieveManager shiftKey:staus];
}

- (void)separateWord{
    [self.relieveManager separateWord];
}

- (void)keyboardItemClicked:(NSString *)oneKey{
    unsigned short value = [oneKey integerValue];
    [self.relieveManager keyboardItemClicked:value];

}

- (void)symbolItemClicked:(NSString *)oneKey{
    unsigned short value = [oneKey integerValue];
    [self.relieveManager symbolItemClicked:value];
}

- (void)clickCandidateAt:(int)index{
    [self.relieveManager clickCandidateAt:index];
}

- (void)clickCandidateBy: (NSString *)text{
    [self.relieveManager clickCandidateBy:text];
}

- (void)clickSpellLetter:(NSString *)letter{
    [self.relieveManager clickSpellLetter:letter];
}

- (void)numberExchange {
    [self.relieveManager numberExchange];
}

- (void)englishExchange {
    [self.relieveManager englishExchange];
}

- (void)zhKeyboardTypeExchange {
    [self.relieveManager zhKeyboardTypeExchange];
}

- (void)backDelete {
    [self.relieveManager backDelete];
}

- (void)reset {
    [self.relieveManager reset];
}

- (void)keyboardDismiss {
    [self.relieveManager keyboardDismiss];
}

- (void)didFetchInputData:(NSArray<NSString *> *)candidateWords pinyin:(NSArray<NSString *> *)aPinyinWords confirmingPinyin:(NSString *)aConfirmingPinyin onScreenText:(NSString *)aOnScreenText preWordAndCurPinyin:( NSString *)preWordAndCurPinyin{

    for (id<RIEngineManagerDelegate> delegate in self.delegateArray) {
        if ([delegate respondsToSelector:@selector(getFetchInputData:pinyin:confirmingPinyin:onScreenText:preWordAndCurPinyin:)]) {
            [delegate getFetchInputData:candidateWords pinyin:aPinyinWords confirmingPinyin:aConfirmingPinyin onScreenText:aOnScreenText preWordAndCurPinyin:preWordAndCurPinyin];
        }
    }
}

@end
