//
//  RIAppGroupManager.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
与主APP交互公共区域信息获取类
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RIAppGroupManager : NSObject

+ (RIKBSettingModel *)getInputSettingModel ;
+ (NSDictionary *)getKeyboardSetting ;

@end

NS_ASSUME_NONNULL_END
