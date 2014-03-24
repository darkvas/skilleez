//
//  SkilleeModel.m
//  skilleez
//
//  Created by Vasya on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SkilleeModel.h"

@implementation SkilleeModel

-(UIColor*) getColor
{
    int rgbValue = [self.UserColor intValue];
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                                                       green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                                                        blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+(RKObjectMapping*) defineObjectMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SkilleeModel class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"Id": @"Id",
                                                   @"UserId": @"UserId",
                                                   @"UserName": @"UserName",
                                                   @"UserAvatarUrl": @"UserAvatarUrl",
                                                   @"UserColor": @"UserColor",
                                                   @"PostedDate": @"PostedDate",
                                                   @"MediaUrl": @"MediaUrl",
                                                   @"MediaThumbnailUrl": @"MediaThumbnailUrl",
                                                   @"Title": @"Title",
                                                   @"Comment": @"Comment"}];
    return mapping;
}

@end
