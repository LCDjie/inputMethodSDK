//
//  CharacterManger.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/20.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "CharacterManger.h"

@implementation CharacterManger

+ (NineChineseModel *)getNineChineseKeyboardSymbool {
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NineChinese" ofType:@"plist"]];
    NineChineseModel *model = [NineChineseModel mj_objectWithKeyValues:dataDict];
    return model;
}

+ (NineNumberModel *)getNineNumberKeyboardSymbool {
    
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NineNumber" ofType:@"plist"]];
    NineNumberModel *model = [NineNumberModel mj_objectWithKeyValues:dataDict];
    return model;
}

+ (NSArray *)getSpecificSymbool {
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SpecificSymbol" ofType:@"plist"]];
    NSArray *  allArray = [SpecificSymbolTypeModel  mj_objectArrayWithKeyValuesArray:dataDict[@"data"]];
    return allArray;
}

+ (NSMutableArray *)getAllEnglishKeyboardSymbool {
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FullEnglishBase" ofType:@"plist"]];
    NSMutableArray *chinsesArray = [[NSMutableArray alloc]init];
    NSArray *symbools = dataDict[@"data"][@"symbools"];
    for (int i=0; i<symbools.count; i++) {
        MainButtonModel *model = [MainButtonModel mj_objectWithKeyValues:symbools[i]];
        [chinsesArray addObject:model];
    }
    return chinsesArray;
}

+ (NSMutableArray *)getAllChineseKeyboardSymbool {
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FullChineseBase" ofType:@"plist"]];
    NSMutableArray *chinsesArray = [[NSMutableArray alloc]init];
    NSArray *symbools = dataDict[@"data"][@"symbools"];
    for (int i=0; i<symbools.count; i++) {
        MainButtonModel *model = [MainButtonModel mj_objectWithKeyValues:symbools[i]];
        [chinsesArray addObject:model];
    }
    return chinsesArray;
}

@end
