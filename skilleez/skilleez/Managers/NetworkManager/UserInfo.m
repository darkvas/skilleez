//
//  UserInfo.m
//  skilleez
//
//  Created by Vasya on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize UserID, Login, Email, FirstName, LastName, FullName, AvatarUrl, Roles, IsAdmin, IsAdult, IsVerified;

+(RKObjectMapping*) defineObjectMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[UserInfo class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"UserID": @"UserID",
                                                   @"Login": @"Login",
                                                   @"Email": @"Email",
                                                   @"FirstName": @"FirstName",
                                                   @"LastName": @"LastName",
                                                   @"FullName": @"FullName",
                                                   @"AvatarUrl": @"AvatarUrl",
                                                   @"Roles": @"Roles",
                                                   @"IsAdmin": @"IsAdmin",
                                                   @"IsVerified": @"IsVerified",
                                                   @"IsAdult": @"IsAdult"}];
    return mapping;
}

@end
