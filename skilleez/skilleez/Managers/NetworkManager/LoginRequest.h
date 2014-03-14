//
//  LoginRequest.h
//  skilleez
//
//  Created by Vasya on 3/13/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"

@interface LoginRequest : NSObject

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;

+(RKObjectMapping*)defineLoginRequestMapping;

@end
