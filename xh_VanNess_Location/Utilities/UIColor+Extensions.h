//
//  UIColor+Extensions.h
//  650mad
//
//  Created by Evan Buxton on 9/27/12.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness;
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;
+ (UIColor *)ebOrangeColor;
+ (UIColor *)ebTealColor;
+ (UIColor *)ebGreenColor;
+ (UIColor *)ebBlueColor;
+ (UIColor *)ebDkBlueColor;
+ (UIColor *)ebLtBlueColor;
+ (UIColor *)ebPurpleColor;

+ (UIColor *)randomColor;

@end
