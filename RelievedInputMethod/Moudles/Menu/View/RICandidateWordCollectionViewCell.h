//
//  RICandidateWordCollectionViewCell.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/31.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
全部候选词界面cell
*/

#import <UIKit/UIKit.h>
#import "MenuCandidateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RICandidateWordCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *leftline; //竖直分割线
@property (nonatomic, strong) UILabel *bottomline; //水平分割线
- (void)configUI:(MenuCandidateModel *)model; //标题设置

@end

NS_ASSUME_NONNULL_END
