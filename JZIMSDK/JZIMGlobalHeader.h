//
//  JZIMGlobalHeader.h
//  JZIMSDK
//
//  Created by king jack on 15/9/14.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#ifndef JZIMSDK_JZIMGlobalHeader_h
#define JZIMSDK_JZIMGlobalHeader_h
#import <UIKit/UIKit.h>
#import "UIColor+Custom.h"


#define SCREENFRAME_SIZE ([[UIScreen mainScreen] bounds].size)
#define SCREENFRAME_SIZE_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREENFRAME_SIZE_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREENFRAME [[UIScreen mainScreen] bounds]

#define SPACENULL @""
#define ENTERWORD @"\n"

#define SOCKET_TIMEOUT 15

#ifndef BGCOLOR
#define BGCOLOR [UIColor colorWithHexString:@"0xFBA73C"]
#endif

#ifndef REDBGCOLOR
#define REDBGCOLOR [UIColor colorWithHexString:@"0xFB6926"]
#endif

#ifndef BLUDEBGCOLOR 
#define BLUDEBGCOLOR [UIColor colorWithHexString:@"0x45B6F6"]
#endif

#endif
