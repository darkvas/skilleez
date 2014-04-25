//
//  ColorManager.h
//  skilleez
//
//  Created by Vasya on 4/22/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorManager : NSObject

+ (UIColor *)colorForSelectedPermission;
+ (UIColor *)colorForUnselectedPermission;
+ (UIColor *)colorForDarkBackground;
+ (UIColor *)defaultTintColor;
+ (UIColor *)colorForCellBackground;
+ (UIColor *)colorForMessageCellHeader;
+ (UIColor *)colorForFriendsCellHeader;
+ (UIColor *)colorForBadgeBackground;

@end
