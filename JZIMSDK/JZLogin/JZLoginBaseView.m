//
//  JZLoginBaseView.m
//  JZIMSDK
//
//  Created by king jack on 15/9/24.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZLoginBaseView.h"

@interface JZLoginBaseView()
{
    UIImageView *_mainGrayBg;
    UILabel *_titleLabel;
}

@end

@implementation JZLoginBaseView
@synthesize menuView = _menuView;

- (id)initWithMenuHeight:(CGFloat)menuHeight titleName:(NSString *)titleName bgColor:(UIColor *)typeColor
{
    self = [super init];
    
    if (self)
    {
        [self createBaseView:menuHeight];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, _menuView.frame.size.width, 40);
}

- (void)createBaseView:(CGFloat)menuHeight
{
    _mainGrayBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENFRAME_SIZE_WIDTH,SCREENFRAME_SIZE_HEIGHT)];
    _mainGrayBg.backgroundColor = [UIColor lightGrayColor];
    _mainGrayBg.alpha = 0;
    [_mainGrayBg  setUserInteractionEnabled:YES];
    [self addSubview:_mainGrayBg];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnClick:)];
    tapGR.numberOfTapsRequired = 1;
    [_mainGrayBg  addGestureRecognizer:tapGR];
    
    _menuView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREENFRAME_SIZE_HEIGHT, SCREENFRAME_SIZE_WIDTH-40, menuHeight)];
    _menuView.layer.cornerRadius = 10;
    _menuView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.4 animations:^{
        _menuView.frame = CGRectMake(20, (SCREENFRAME_SIZE_HEIGHT - menuHeight)/2-20, SCREENFRAME_SIZE_WIDTH-40, menuHeight);
        _mainGrayBg.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
    [self addSubview:_menuView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _menuView.frame.size.width, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_menuView addSubview:_titleLabel];
}

- (UIView *)menuView
{
    return _menuView;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setTypeColor:(UIColor *)typeColor
{
    _titleLabel.textColor = typeColor;
}

- (void)cancelBtnClick:(UITapGestureRecognizer *)gesture
{
    _mainGrayBg.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.frame =CGRectMake(0, SCREENFRAME_SIZE.height, SCREENFRAME_SIZE.width-40, 260);
    }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}


@end
