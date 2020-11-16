//
//  RIAppGroupManager.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "RIAppGroupManager.h"

@implementation RIAppGroupManager

#pragma mark - Private
+ (NSString *)jsonStrWithPathName:(NSString *)pathName {
    NSURL *groupUrl = [RIAppGroupManager groupUrl];
    NSURL *filePath = [groupUrl URLByAppendingPathComponent:pathName];
    NSError *error;
    if (filePath) {
        NSString *jsonStr = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:&error];
        return jsonStr;
    } else {
        return nil;
    }
}

+ (NSURL *)groupUrl {
    NSURL *groupUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kAppGroupIdentifier];
    return groupUrl;
}

+ (NSUserDefaults *)userDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:kAppGroupIdentifier];
}

#pragma mark - Public
+ (RIKBSettingModel *)getInputSettingModel {
    NSString *jsonStr = [RIAppGroupManager jsonStrWithPathName:@"inputSetting.json"];
    NSDictionary *userDic = [jsonStr mj_JSONObject];
    RIKBSettingModel *model = [RIKBSettingModel mj_objectWithKeyValues:userDic];
    return model;
}

+ (NSDictionary *)getKeyboardSetting {
    NSString *jsonStr = [RIAppGroupManager jsonStrWithPathName:@"keyboardSetting.json"];
    NSDictionary *userDic = [jsonStr mj_JSONObject];
    return userDic;
}

@end
