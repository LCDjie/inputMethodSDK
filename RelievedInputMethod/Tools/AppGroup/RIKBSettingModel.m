//
//  RIKBSettingModel.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "RIKBSettingModel.h"

@implementation RIKBSettingModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"fuzzy":@"fluzzy",
             @"fuzzySet":@"fluzzySet"
             };
}

@end

@implementation RIKBFuzzySettingModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
     return @{
              @"iang": @"iang=ian",
              @"ln": @"l=n",
              @"g": @"g=k",
              @"uang": @"uang=uan",
              @"sh": @"sh=s",
              @"f": @"f=h",
              @"ch": @"ch=c",
              @"zh": @"zh=z",
              @"ang": @"ang=an",
              @"eng": @"eng=en",
              @"ing": @"ing=in",
              @"lr": @"l=r"
              };
}

@end
