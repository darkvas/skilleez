//
//  ProfileInfo.m
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ProfileInfo.h"

@implementation ProfileInfo

-(UIColor*) getColor
{
    uint rgbValue;
    [[NSScanner scannerWithString: self.FavoriteColor] scanHexInt: &rgbValue];
    NSLog(@" --- Profile color: %i", rgbValue);
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+(RKObjectMapping*) defineObjectMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ProfileInfo class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"UserId": @"UserId",
                                                   @"Login": @"Login",
                                                   @"ScreenName": @"ScreenName",
                                                   @"FavoriteColor": @"FavoriteColor",
                                                   @"FavoriteSport": @"FavoriteSport",
                                                   @"FavoriteSchoolSubject": @"FavoriteSchoolSubject",
                                                   @"FavoriteTypeOfMusic": @"FavoriteTypeOfMusic",
                                                   @"FavoriteFood": @"FavoriteFood",
                                                   @"AboutMe": @"AboutMe",
                                                   @"AvatarUrl": @"AvatarUrl"}];
    return mapping;
}

@end
