//
//  UIColor+Custom.h
//  JZIMSDK
//
//  Created by king jack on 15/9/23.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Custom)

+ (UIImage*) createImageWithColor: (UIColor*) color;

+ (UIImage *)createImageWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (CAGradientLayer *)getGradientLayerWithRect:(CGRect)rect
                                   startPoint:(CGPoint)startPoint
                                     endPoint:(CGPoint)endPoint
                                       colors:(NSArray *)colorsArray
                                    locations:(NSArray *)locationsArray;

@end
