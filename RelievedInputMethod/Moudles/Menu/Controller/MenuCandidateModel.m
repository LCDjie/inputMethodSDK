//
//  MenuCandidateModel.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/31.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "MenuCandidateModel.h"

@implementation MenuCandidateModel

- (void)setTitle:(NSString *)title {
    _title =title;
    
    CGFloat maxWidth = SCREEN_WIDTH - (NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X);
    CGFloat itemWidth = floor(maxWidth/4);
    CGRect rect = [title boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                          NSFontAttributeName:FontRegular17
                                          } context:nil];
    int count = (rect.size.width + 22) / itemWidth;
    CGFloat width = (count + 1) *itemWidth;
    if (width < itemWidth) {
        width = itemWidth ;
    }
    self.width = floor(width);
    return;
}

@end
