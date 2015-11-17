//
//  JZLoginBaseView.h
//  JZIMSDK
//
//  Created by king jack on 15/9/24.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZLoginBaseView : UIView

- (id)initWithMenuHeight:(CGFloat)menuHeight titleName:(NSString *)titleName bgColor:(UIColor *)typeColor;

@property(nonatomic,retain)UIView *menuView;

@property(nonatomic,retain)NSString *title;

@property(nonatomic,retain)UIColor *typeColor;

@end
