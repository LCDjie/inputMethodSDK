//
//  CharacterModel.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/20.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "CharacterModel.h"

@implementation CharacterModel

@end

#pragma mark - MainButtonModel
@implementation MainButtonModel

- (NSArray <NSString *>*)charsArray {
    
    if ([self.codeType isEqualToString:@"dot"] && self.kbType.integerValue == 2) {
        return [self.chars componentsSeparatedByString:@"a"];
    } else {
        return [self.chars componentsSeparatedByString:@","];
    }
}

- (NSArray<NSString *> *)codeArray {
    if ([self.codeType isEqualToString:@"dot"] && self.kbType.integerValue == 2) {
        return [self.codeChars componentsSeparatedByString:@"a"];
    } else {
        return [self.codeChars componentsSeparatedByString:@","];
    }
}
@end

@implementation SideButtonModel

@end

#pragma mark - NineChineseModel
@implementation NineChineseModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"inputs": [MainButtonModel class],
             @"punctuations": [NSString class],
             @"rightKeys": [SideButtonModel class],
             @"bottomKeys": [SideButtonModel class]
             };
}

@end

#pragma mark - NineNumberModel
@implementation NineNumberModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
        @"inputs": [NSString class],
        @"punctuations": [NSString class]
    };
}

@end

#pragma mark - SpecificSymbolTypeModel
@implementation SpecificSymbolTypeModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"symboolArrays": [NSString class]
             };
}

- (NSArray <NSString *>*)symboolArrays {
    NSArray *symbools = [self.symbools componentsSeparatedByString:@"a"];
    return symbools;
}

@end
