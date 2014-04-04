//
//  FamilyMemberModel.m
//  skilleez
//
//  Created by Vasya on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "FamilyMemberModel.h"

@implementation FamilyMemberModel

+(RKObjectMapping*) defineObjectMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[FamilyMemberModel class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"Id": @"Id",
                                                   @"IsAdult": @"IsAdult",
                                                   @"FullName": @"FullName",
                                                   @"AvatarUrl": @"AvatarUrl"}];
    return mapping;
}

- (id)initWithId:(NSString *)Id isAdult:(BOOL)isAdult fullName:(NSString *)fullName avatarUrl:(NSURL *)avatarUrl
{
    if (self = [super init]) {
        self.FullName = fullName;
        self.Id = Id;
        self.AvatarUrl = avatarUrl;
        self.IsAdult = isAdult;
    }
    return self;
}

@end
