//
//  InvitorModel.m
//  skilleez
//
//  Created by Hedgehog on 22.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "InvitorModel.h"

@implementation InvitorModel

- (UIColor *)getColor
{
    uint rgbValue;
    [[NSScanner scannerWithString: self.FavoriteColor] scanHexInt: &rgbValue];
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (RKObjectMapping *)defineObjectMapping
{
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[InvitorModel class]];
    
    [mapping addAttributeMappingsFromArray:@[      @"UserId",
                                                   @"Login",
                                                   @"ScreenName",
                                                   @"FavoriteColor",
                                                   @"AvatarUrl",
                                                   @"AboutMe"]];
    return mapping;
}

@end
