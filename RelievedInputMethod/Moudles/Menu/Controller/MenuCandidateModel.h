//
//  MenuCandidateModel.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/31.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
全部候选词model
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuCandidateModel : NSObject

@property(nonatomic, strong)NSString * title; //cell标题
@property(nonatomic, assign)CGFloat width; //按钮宽度

@end

NS_ASSUME_NONNULL_END
