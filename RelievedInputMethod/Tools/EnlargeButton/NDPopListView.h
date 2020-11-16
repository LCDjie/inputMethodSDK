//
//  NDPopListView.h
//  NiudunInputMethod
//
//  Created by wei on 2019/1/2.
//  Copyright © 2019 芯盾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NDPopListView : UIView

@property (nonatomic, strong) NSArray *butArray;

- (void)showFrameWithButton:(UIButton *)btn btnarr:(NSArray *)btnarray;
- (void)selectButton:(CGFloat)locationX;

@end

NS_ASSUME_NONNULL_END
