//
//  JZSexChooseTableViewController.h
//  JZIMSDK
//
//  Created by king jack on 15/10/8.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifySexDelegate <NSObject>

- (void)modifySexWithIndex:(NSInteger)indexRow;

@end

@interface JZSexChooseTableViewController : UITableViewController

@property (nonatomic,copy)NSString *sex;

@property(nonatomic,assign)id<ModifySexDelegate>delegate;

@end
