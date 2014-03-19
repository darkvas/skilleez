//
//  SkilleeRequest.m
//  skilleez
//
//  Created by Vasya on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SkilleeRequest.h"

@implementation SkilleeRequest

+(RKObjectMapping*) defineObjectMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SkilleeRequest class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"BehalfUserId": @"BehalfUserId",
                                                   @"Title": @"Title",
                                                   @"Comment": @"Comment",
                                                   @"Media": @"Media"}];
    return mapping;
}

@end
