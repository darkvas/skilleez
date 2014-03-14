//
//  LoginResponce.m
//  skilleez
//
//  Created by Vasya on 3/13/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoginResponce.h"

@implementation LoginResponce

@synthesize username;
@synthesize password;

+(RKObjectMapping*)defineLoginResponseMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[LoginResponce class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"username":   @"username",
                                                  @"password":   @"password",
                                                  }];
    return mapping;
}

@end