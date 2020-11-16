//
//  MenuCandidateBar.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/24.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
菜单候选词栏
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuCandidateBar : UIView
@property (nonatomic, strong) NSMutableArray *dataArray ;//候选词数组
@property (nonatomic, strong) NSMutableArray *spellArray ;//候选拼音数组
@property (nonatomic, copy) NSString *spellStr ;//待确定的拼音
+ (instancetype)shareInstance ;
+ (void)destroy ; //销毁
- (void)reloadCollectionData ;//刷新候选词

@end

NS_ASSUME_NONNULL_END
