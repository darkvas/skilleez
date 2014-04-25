//
//  ColorManager.m
//  skilleez
//
//  Created by Vasya on 4/22/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

+ (UIColor *)colorForSelectedPermission
{
    return [UIColor colorWithRed:0.96 green:0.77 blue:0.18 alpha:1.0];
}

+ (UIColor *)colorForUnselectedPermission
{
    return [UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1.0];
}

+ (UIColor *)colorForDarkBackground
{
    return [UIColor colorWithRed:0.94 green:0.72 blue:0.12 alpha:1.0];
}

+ (UIColor *)defaultTintColor
{
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

+ (UIColor *)colorForCellBackground
{
    return [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.f];
}

+ (UIColor *)colorForMessageCellHeader
{
    return [UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1.0];
}

+ (UIColor *)colorForFriendsCellHeader
{
    return [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.0];
}

+ (UIColor *)colorForBadgeBackground
{
   return [UIColor colorWithRed:0.96 green:0.47 blue:0.49 alpha:1.0];
}

@end
