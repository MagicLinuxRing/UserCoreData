//
//  JZTextFiled.h
//  JZIMSDK
//
//  Created by king jack on 15/9/23.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NONE = 0,
    LEFT_VIEW,
    RIGHT_VIEW,
} INNERVIEW_POSTION;

@interface JZTextFiled : UITextField

//- (id)initWithFrame:(CGRect)frame position:(INNERVIEW_POSTION)position;

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)titleName;

//@property(nonatomic,retain)NSString *title;
//
//@property(nonatomic,retain)NSString *imageName;

@end
