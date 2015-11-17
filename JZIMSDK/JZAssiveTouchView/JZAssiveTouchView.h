//
//  JZAssiveTouchView.h
//  JZIMSDK
//
//  Created by king jack on 15/9/21.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AssistiveTouchDelegate;

@interface JZAssiveTouchView : UIView<UIGestureRecognizerDelegate>
{
        UIImageView             *_imageView;
}

@property(nonatomic,assign)BOOL isShowMenu;

@property(nonatomic,weak)id<AssistiveTouchDelegate> delegate;

/**
 *  初始化放在appdelegate里面
 *
 *  @param frame
 *  @param name  按钮背景图片
 *
 *  @return AssistiveTouch *
 */
- (id)initWithFrame:(CGRect)frame imageName:(NSString*)name;

- (void)setWindowStatus;

@end

@protocol AssistiveTouchDelegate <NSObject>
@optional

//悬浮窗点击事件
-(void)assistiveTocuhs:(BOOL)isShowMenu;
@end
