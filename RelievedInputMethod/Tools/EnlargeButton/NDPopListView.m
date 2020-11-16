//
//  NDPopListView.m
//  NiudunInputMethod
//
//  Created by wei on 2019/1/2.
//  Copyright © 2019 芯盾. All rights reserved.
//

#import "NDPopListView.h"
#import "UIView+Common.h"
#import "FontDefine.h"
#import "UIImage+Common.h"
#import "AdaptiveDefine.h"
#import "ColorDefine.h"
#import "UIColor+Expanded.h"
@implementation NDPopListView

- (void)showFrameWithButton:(UIButton *)btn btnarr:(NSArray *)btnarray {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.butArray = btnarray;
    self.y = btn.y - 55;
    self.width = btnarray.count * 32 + 6;
    self.height = 48;
    CGFloat left =  btn.x + btn.width / 2 - self.width / 2;
    if (left < 0) {
        self.x = 5;
    }
    else if (left + self.width > SCREEN_WIDTH) {
        self.x = SCREEN_WIDTH - self.width - 5;
    }
    else {
        self.x = left;
    }
    
    CGFloat hPadding = 3.0;
    CGFloat buttonWidth = (self.width - 2*hPadding)/btnarray.count;
    
    
    for (int i = 0; i < btnarray.count; i ++) {
        UIButton *nextbut = [UIButton buttonWithType:UIButtonTypeCustom];
        nextbut.frame = CGRectMake( hPadding + i * buttonWidth, 4, buttonWidth, self.height - 8);
        nextbut.layer.cornerRadius = 3.0;   // 3.0是圆角的弧度，根据需求自己更改
        nextbut.layer.masksToBounds = YES;
        NSString *btnstr = btnarray[i];
        [nextbut setTitle:btnstr forState:UIControlStateNormal];
        nextbut.titleLabel.font = FontRegular(25.f);
        [nextbut setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [nextbut setTitleColor:kBtnTopTitleColor forState:UIControlStateNormal];
        [nextbut setBackgroundImage:[UIImage rl_imageWithColor:kGeneralSelectColor] forState:UIControlStateSelected];
        [nextbut setBackgroundImage:[UIImage rl_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self addSubview:nextbut];
        nextbut.tag = 50 + i;
//        
//        BOOL isInitialSelect = i == btnarray.count / 2;
//        nextbut.selected = isInitialSelect;

    }
}

- (void)selectButton:(CGFloat)locationX {

    UIButton *firstbtn = self.subviews.firstObject;
    UIButton *lastbtn = self.subviews.lastObject;
    
    for (int i = 0; i < self.subviews.count; i ++) {
        UIButton *btnview = self.subviews[i];
        if (![btnview isKindOfClass:[UIButton class]]) {
            continue;
        }
        
        CGRect startRect = [btnview convertRect:btnview.bounds toView:nil];
        CGRect firstRect = [firstbtn convertRect:firstbtn.bounds toView:nil];
        CGRect lastRect = [lastbtn convertRect:lastbtn.bounds toView:nil];
        
        if (startRect.origin.x < locationX && locationX < startRect.origin.x + btnview.width) {
            btnview.selected = YES;
        }
        else if (locationX <= firstRect.origin.x) {
            
            firstbtn.selected = YES;
        }
        else if (locationX >= lastRect.origin.x + btnview.width) {
            lastbtn.selected = YES;
        }
        else {
            btnview.selected = NO;
        }
    }
}

@end
