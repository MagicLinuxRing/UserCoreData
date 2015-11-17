//
//  FloatView.h
//  FloatMenu
//
//  Created by Johnny on 14/9/6.
//  Copyright (c) 2014年 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FloatingButtonDelegate <NSObject>

- (void)floatButtonClick:(UIButton *)button;

@end

@interface FloatView : NSObject

@property(nonatomic,weak)id<FloatingButtonDelegate>delegate;

- (id)initWithButtonImageNameArray:(NSArray*)imgNameArray titleArray:(NSArray *)titleArray;

+ (FloatView *)defaultFloatViewWithButtonImageNameArray:(NSArray*)imgNameArray titleArray:(NSArray *)titleArray;

- (void)removeWindow;

- (void)transformWindowSubView;

@end
