//
//  SkilleeModel.h
//  skilleez
//
//  Created by Vasya on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkilleeModel : NSObject

@property (nonatomic, strong) NSString* Id;
@property (nonatomic, strong) NSString* UserId;
@property (nonatomic, strong) NSString* UserName;
@property (nonatomic, strong) NSString* UserAvatarUrl;
@property (nonatomic, strong) NSString* UserColor;
@property (nonatomic, strong) NSString* PostedDate;
@property (nonatomic, strong) NSString* MediaUrl;
@property (nonatomic, strong) NSString* MediaThumbnailUrl;
@property (nonatomic, strong) NSString* Title;
@property (nonatomic, strong) NSString* Comment;

+(RKObjectMapping*) defineObjectMapping;

@end
