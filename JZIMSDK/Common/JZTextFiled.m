//
//  JZTextFiled.m
//  JZIMSDK
//
//  Created by king jack on 15/9/23.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZTextFiled.h"
#import "UIView+MJExtension.h"

@interface JZTextFiled()<UITextFieldDelegate>
{
//    UIView *_leftInnerView;
//    UIView *_rightInnerView;
}

@end

@implementation JZTextFiled

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)titleName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        self.keyboardType = UIKeyboardTypeDefault;
        [self createInnerView:titleName];
    }
    return self;
}

- (void)createInnerView:(NSString *)titleName
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:16];
    titleLabel.text = titleName;
    titleLabel.textColor = [UIColor grayColor];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = titleLabel;
}

#pragma mark delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

@end
