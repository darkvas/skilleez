//
//  PostResponse.m
//  skilleez
//
//  Created by Vasya on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "PostResponse.h"

@implementation PostResponse

+(RKObjectMapping*) defineObjectMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[PostResponse class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"ResultCode": @"ResultCode",
                                                   @"ResultCodeName": @"ResultCodeName",
                                                   @"ErrorMessage": @"ErrorMessage",
                                                   @"ReturnValue": @"ReturnValue"}];
    return mapping;
}

@end
