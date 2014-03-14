//
//  UserInfo.h
//  skilleez
//
//  Created by Vasya on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString* UserID;
@property (nonatomic, strong) NSString* Login;
@property (nonatomic, strong) NSString* Email;
@property (nonatomic, strong) NSString* FirstName;
@property (nonatomic, strong) NSString* LastName;
@property (nonatomic, strong) NSString* FullName;
@property (nonatomic, strong) NSString* AvatarUrl;
@property (nonatomic, strong) NSArray* Roles;
@property (nonatomic) BOOL IsAdmin;
@property (nonatomic) BOOL IsVerified;
@property (nonatomic) BOOL IsAdult;

+(RKObjectMapping*) defineObjectMapping;

@end
