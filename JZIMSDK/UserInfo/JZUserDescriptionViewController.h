//
//  JZUserDescriptionViewController.h
//  JZIMSDK
//
//  Created by king jack on 15/10/8.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifySignatureDelegate <NSObject>

- (void)modifySignatureWithText:(NSString *)signature;

@end

@interface JZUserDescriptionViewController : UIViewController

@property(nonatomic,copy)NSString *playerDescription;

@property(nonatomic,assign)id<ModifySignatureDelegate>delegate;

@end
