//
//  JZFindSecretView.h
//  JZIMSDK
//
//  Created by king jack on 15/9/24.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindSecretDelegate <NSObject>

- (void)backToshowNormalRegisterView:(BOOL)isShowRegisterBottomView;

@end

@interface JZFindSecretView : UIView

@property(nonatomic,weak)id<FindSecretDelegate>delegate;

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)titleName bgColor:(UIColor *)typeColor;

@end
