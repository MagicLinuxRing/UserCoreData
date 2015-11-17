//
//  JZUserDescriptionViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/10/8.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZUserDescriptionViewController.h"

@interface JZUserDescriptionViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
    UILabel     *leaveNumberLabel;
    UIButton    *_rightButton;
}
@end

@implementation JZUserDescriptionViewController

- (void)viewDidLoad
 {
    [super viewDidLoad];
     self.title = @"个性签名";
     self.view.backgroundColor = [UIColor whiteColor];
     [self createSignatureView];
}

- (void)createSignatureView
{
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 60, 40)];
    _rightButton.backgroundColor = [UIColor clearColor];
    [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [_rightButton setTitleColor:BLUDEBGCOLOR forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_rightButton addTarget:self
                     action:@selector(saveSignature)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *_rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = _rightBarItem;
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENFRAME_SIZE_WIDTH, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:bgView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREENFRAME_SIZE_WIDTH-20, 80)];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.text = self.playerDescription;
    _textField.backgroundColor = [UIColor clearColor];
    [bgView addSubview:_textField];
    
    leaveNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENFRAME_SIZE_WIDTH-50, 55, 40, 20)];
    leaveNumberLabel.font = [UIFont fontWithName:@"Arial" size:14];
    leaveNumberLabel.textColor = [UIColor lightGrayColor];
    leaveNumberLabel.text = [NSString stringWithFormat:@"%lu",30-_textField.text.length];
    
    [_textField  addSubview:leaveNumberLabel];
}

#pragma mark textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString * currentString = [textField.text stringByReplacingCharactersInRange:range
                                                                    withString:string];
    
    if (currentString.length >30)
    {
        leaveNumberLabel.text = @"0";
        return NO;
    }
    leaveNumberLabel.text = [NSString stringWithFormat:@"%lu", 30-currentString.length];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveSignature];
    return YES;
}

- (void)saveSignature
{
    if ([self.delegate respondsToSelector:@selector(modifySignatureWithText:)])
    {
        [self.delegate modifySignatureWithText:_textField.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
