//
//  AdultPermission.m
//  skilleez
//
//  Created by Vasya on 4/2/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "AdultPermission.h"

@implementation AdultPermission

/*
 "Id": 1,
 "AdultId": 2,
 "ChildId": 3,
 "ChildName": "sample string 4",
 "ChildAvatarUrl": "sample string 5",
 "ChangesApproval": true,
 "LoopApproval": true,
 "ProfileApproval": true,
 "MainFamilyUserId": 9
 */

+(RKObjectMapping*) defineObjectMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[AdultPermission class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"Id": @"Id",
                                                   @"AdultId": @"AdultId",
                                                   @"ChildId": @"ChildId",
                                                   @"ChildName": @"ChildName",
                                                   @"ChildAvatarUrl": @"ChildAvatarUrl",
                                                   @"ChangesApproval": @"ChangesApproval",
                                                   @"LoopApproval": @"LoopApproval",
                                                   @"ProfileApproval": @"ProfileApproval",
                                                   @"IsModerator": @"IsModerator"}];
    return mapping;
}

@end
