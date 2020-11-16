//
//  AXKeyBoardSaseButton.m
//  RelievedInputMethod
//
//  Created by liweijie on 2020/7/21.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "AXKeyBoardSaseButton.h"
#import "UIImage+Common.h"

@implementation AXKeyBoardSaseButton

//绘制键盘上下键
- (void)setTopText:(NSString *)upText text:(NSString *)maintext {
    //富文本
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",upText] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:kAXKeyboardBtnTopTitleColor}];
    NSAttributedString *mainText = [[NSAttributedString alloc] initWithString:maintext attributes:@{NSFontAttributeName:FontRegular17,NSForegroundColorAttributeName:[UIColor blackColor]}];
    [title appendAttributedString:mainText];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:0]; // 字体的行间距
    paraStyle.maximumLineHeight = 22;
    paraStyle.alignment = NSTextAlignmentCenter;
    [title addAttributes:@{NSParagraphStyleAttributeName:paraStyle}  range:NSMakeRange(0, title.length)];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self setAttributedTitle:title forState:UIControlStateNormal];
}

- (void)setKeyboardButtonType:(AXKeyboardButtonType)KeyboardButtonType {
    _KeyboardButtonType = KeyboardButtonType;
    self.titleLabel.font = FontRegular16;
    switch (KeyboardButtonType) {
                
       case AXKeyboardButtonTypeNumber:{
           [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
           [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
           [self setBackgroundImage:[UIImage rl_imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(80.0f, 45.0f) cornerRadius:5.0f] forState:UIControlStateHighlighted];
        }
            break;
            
        case AXKeyboardButtonTypeDelete:{
            [self setImage:[UIImage imageNamed:@"button_backspace_delete"] forState:UIControlStateNormal];
            [self setImage:[[UIImage imageNamed:@"button_backspace_delete"] rl_imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
        case AXKeyboardButtonTypeASCIIDelete:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setImage:[UIImage imageNamed:@"button_backspace_delete"] forState:UIControlStateNormal];
            [self setImage:[[UIImage imageNamed:@"button_backspace_delete"] rl_imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        }
            break;
        case AXKeyboardButtonTypeNineLetter: {
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setBackgroundImage:[UIImage rl_imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(80.0f, 45.0f) cornerRadius:5.0f] forState:UIControlStateHighlighted];
        }
           break;
        case AXKeyboardButtonTypeLetter:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
         }
             break;
        
        case AXKeyboardButtonTypeFullBoardNumber: {
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
        }
            break;
        case AXKeyboardButtonTypeABC:{
            [self setTitle:@"ABC" forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
            
        case AXKeyboardButtonTypeResign:{
            [self setImage:[UIImage imageNamed:@"button_keyboard_shouqi"] forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
            
        case AXKeyboardButtonTypeComplete:{
            [self setTitle:@"完成" forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:YES];
        }
            break;
        
        case AXKeyboardButtonTypeDecimal:{
            [self setTitle:@"." forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
        }
            break;
            
        case AXKeyboardButtonTypeEndCH: {
            [self setTitle:@" 。" forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
        }
            break;
        case AXKeyboardButtonTypeZero:{
            [self setTitle:@"0" forState:UIControlStateNormal];
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
        }
            break;
        case AXKeyboardButtonTypeToggleCase:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setImage:[UIImage imageNamed:@"CH_EN_icon_unsel"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"CH_EN_icon_sel"] forState:UIControlStateSelected];
        }
            break;
            
        case AXKeyboardButtonTypeComma:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"," forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeCommaCN:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@" ，" forState:UIControlStateNormal];
        }
            break;
        
        case AXKeyboardButtonTypeSymbol: {
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"符" forState:UIControlStateNormal];
        }
        break;
        case AXKeyboardButtonTypeDirectInput: {
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
//            [self setTitle:@"abc" forState:UIControlStateNormal];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"abc"];
            [attStr addAttribute:NSUnderlineStyleAttributeName
            value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
            range:NSMakeRange(0, 3)];
            [self setAttributedTitle:attStr forState:UIControlStateNormal];
        }
        break;
        case AXKeyboardButtonTypeSwitchKeyBoard: {
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setImage:[UIImage imageNamed:@"kb_next"] forState:UIControlStateNormal];
        }
        break;
        case AXKeyboardButtonTypeToNumber:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"123" forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeASCIINewline:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"换行" forState:UIControlStateNormal];
        }
            break;
        
        case AXKeyboardButtonTypeParticiples: {
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"分词" forState:UIControlStateNormal];
        }
            break;
        case AXKeyboardButtonTypeEnToCh: {
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"中" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:kAXKeyboardBtnTopTitleColor}];
            
            NSAttributedString *mainText = [[NSAttributedString alloc] initWithString:@"/英" attributes:@{NSFontAttributeName:FontRegular16,NSForegroundColorAttributeName:[UIColor blackColor]}];
            [title appendAttributedString:mainText];
            [self setAttributedTitle:title forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeChToEn: {
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"中/" attributes:@{NSFontAttributeName:FontRegular16,NSForegroundColorAttributeName:[UIColor blackColor]}];
            
            NSAttributedString *mainText = [[NSAttributedString alloc] initWithString:@"英" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:kAXKeyboardBtnTopTitleColor}];
            [title appendAttributedString:mainText];
            
            [self setAttributedTitle:title forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeASCIIDecimal:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:NO];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
//            [self setTitle:@"." forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeSpace:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"空格" forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeASCIIEnterAgain:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"重输" forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeAite:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"@" forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeLineFeed:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
             [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
             [self setTitle:@"换行" forState:UIControlStateNormal];
        }
            break;
            
        case AXKeyboardButtonTypeToBack:{
            [self configKeyboardButtonTypeWithIsFunctionKeyBoard:YES];
            [self configKeyboardButtonTypeWithisNumberKeyBoard:NO];
            [self setTitle:@"返回" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    
}

/**
 数字键盘和字母键盘按钮样式
 @param isNumberKeyBoard 是否是数字键盘
 */
- (void)configKeyboardButtonTypeWithisNumberKeyBoard:(BOOL)isNumberKeyBoard
{
    if (isNumberKeyBoard) {
        self.layer.cornerRadius = 5;
        self.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(0, 1);//阴影的大小，x往右和y往下是正
        self.layer.shadowRadius = 0;     //阴影的扩散范围，相当于blur radius，也是shadow的渐变距离，从外围开始，往里渐变shadowRadius距离
        self.layer.shadowOpacity = 0.9;
    }else{
        self.layer.cornerRadius = 5;
        self.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(0, 1);//阴影的大小，x往右和y往下是正
        self.layer.shadowRadius = 0;     //阴影的扩散范围，相当于blur radius，也是shadow的渐变距离，从外围开始，往里渐变shadowRadius距离
        self.layer.shadowOpacity = 0.9;
    }
}
/**
 功能按钮和可输入按钮样式
 @param isFunctionKeyBoard 是否是功能按钮
 */
- (void)configKeyboardButtonTypeWithIsFunctionKeyBoard:(BOOL)isFunctionKeyBoard {
    if (isFunctionKeyBoard) {
        [self setTitleColor:kAXKeyboardBtnLightTitleColor forState:UIControlStateNormal];
        self.backgroundColor = kAXKeyboardBtnDefaultColor;
    }else{
        [self setTitleColor:kAXKeyboardBtnLightTitleColor forState:UIControlStateNormal];
        self.backgroundColor = UIColor.whiteColor;
        
    }
}

@end
