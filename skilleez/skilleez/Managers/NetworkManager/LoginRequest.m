//
//  LoginRequest.m
//  skilleez
//
//  Created by Vasya on 3/13/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoginRequest.h"
#import "RKObjectManager.h"

@implementation LoginRequest

@synthesize username;
@synthesize password;

+(RKObjectMapping*)defineLoginRequestMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[LoginRequest class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"username":   @"username",
                                                  @"password":   @"password",
                                                  }];
    
    return mapping;
}

@end