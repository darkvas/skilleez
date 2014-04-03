//
//  FamilyMemberModel.h
//  skilleez
//
//  Created by Vasya on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyMemberModel : NSObject

@property (nonatomic, strong) NSString* Id;
@property (nonatomic) BOOL IsAdult;
@property (nonatomic, strong) NSString* FullName;
@property (nonatomic, strong) NSString* AvatarUrl;

+(RKObjectMapping*) defineObjectMapping;

- (id)initWithId:(NSString *)Id isAdult:(BOOL)isAdult fullName:(NSString *)fullName avatarUrl:(NSString *)avatarUrl;

@end
