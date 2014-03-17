//
//  SkilleeModel.m
//  skilleez
//
//  Created by Vasya on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SkilleeModel.h"

@implementation SkilleeModel

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
