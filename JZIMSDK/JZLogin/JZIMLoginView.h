//
//  JZIMLoginView.h
//  JZIMSDK
//
//  Created by king jack on 15/9/14.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZIMLoginDelegate <NSObject>

@required
    - (void)loginWithUserInfo:(NSDictionary *)userInfo;

    - (void)registerLoginWithUserInfo:(NSDictionary *)userInfo;
@optional

- (void)visitorLoginWithUserInfo;

- (void)popupPhoneRegisterView;

- (void)popupFindSecretView;

@end

@interface JZIMLoginView : UIView

/**
 *  init login View
 *
 *  @param frame     loginview frame
 *  @param backgroud \uiimage or uicolor
 *
 *  @return JZIMLoginView
 */
- (instancetype)initWithFrame:(CGRect)frame bgColor:(id)backgroud;

- (instancetype)initWithFrame:(CGRect)frame
                      bgColor:(id)backgroud
       isShowRegistBottomView:(BOOL)isShowRegistBottomView;

@property(nonatomic,weak)id<JZIMLoginDelegate>delegate;

/**
 *  UI Style
 */
@property(nonatomic,strong)UIColor *typeColor;

@end
