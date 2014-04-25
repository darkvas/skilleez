//
//  InviteeModel.m
//  skilleez
//
//  Created by Hedgehog on 22.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "InviteeModel.h"

@implementation InviteeModel

- (UIColor *)getColor
{
    uint rgbValue;
    [[NSScanner scannerWithString: self.FavoriteColor] scanHexInt: &rgbValue];
    NSLog(@" --- Profile color: %i", rgbValue);
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (RKObjectMapping *)defineObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[InviteeModel class]];
    
    [mapping addAttributeMappingsFromArray:@[      @"UserId",
                                                   @"CurrentUserIsApprover",
                                                   @"Login",
                                                   @"ScreenName",
                                                   @"FavoriteColor",
                                                   @"FavoriteSport",
                                                   @"FavoriteSchoolSubject",
                                                   @"FavoriteTypeOfMusic",
                                                   @"FavoriteFood",
                                                   @"AvatarUrl",
                                                   @"AboutMe"]];
    return mapping;
}


@end
