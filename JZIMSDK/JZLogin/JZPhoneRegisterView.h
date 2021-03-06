//
//  JZPhoneRegisterView.h
//  JZIMSDK
//
//  Created by king jack on 15/9/24.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZLoginBaseView.h"

@protocol NormalRegisterDelegate <NSObject>

- (void)backToshowNormalRegisterView:(BOOL)isShowRegisterBottomView;

@end

@interface JZPhoneRegisterView : UIView

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)titleName bgColor:(UIColor *)typeColor;

@property(nonatomic,weak)id<NormalRegisterDelegate>delegate;

@end
