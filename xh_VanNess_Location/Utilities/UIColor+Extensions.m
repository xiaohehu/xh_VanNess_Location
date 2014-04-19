//
//  UIColor+Extensions.m
//  650mad
//
//  Created by Evan Buxton on 9/27/12.
//
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

#pragma mark
#pragma mark description

+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    return [UIColor colorWithHue:(hue/360) saturation:saturation brightness:brightness alpha:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor *)ebTealColor {
    return [UIColor colorWithHueDegrees:197 saturation:1.00 brightness:0.66];
}

+ (UIColor *)ebOrangeColor {
    return [UIColor colorWithHueDegrees:46 saturation:0.87 brightness:0.89];
}

+ (UIColor *)ebGreenColor {
    return [UIColor colorWithHueDegrees:137 saturation:0.69 brightness:0.60];
}

+ (UIColor *)ebBlueColor {
    return [UIColor colorWithHueDegrees:232 saturation:0.57 brightness:0.78];
}

+ (UIColor *)ebDkBlueColor {
    return [UIColor colorWithHueDegrees:202 saturation:1.0 brightness:0.42];
}

+ (UIColor *)ebLtBlueColor {
    return [UIColor colorWithHueDegrees:79 saturation:0.62 brightness:0.71];
}

+ (UIColor *)ebPurpleColor {
    return [UIColor colorWithHueDegrees:262 saturation:0.56 brightness:0.70];
}

+ (UIColor *)randomColor {
    return [self colorWithRed:((float)rand() / RAND_MAX)
                        green:((float)rand() / RAND_MAX)
                         blue:((float)rand() / RAND_MAX)
                        alpha:1.0f];
}

// use self.view.backgroundColor = highlight? [UIColor paleYellowColor] : [UIColor whitecolor];

@end
