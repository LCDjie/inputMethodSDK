//
//  MenuResultCollectionViewCell.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/24.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
菜单候选词栏cell
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuResultCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *resultLabel; //候选词label
- (void)configUI:( NSIndexPath*)index; //界面适配

@end

NS_ASSUME_NONNULL_END
