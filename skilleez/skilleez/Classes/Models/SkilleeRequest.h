//
//  SkilleeRequest.h
//  skilleez
//
//  Created by Vasya on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

enum mediaType
{
    mediaTypeNone,
    mediaTypeImage = 1,
    mediaTypeVideo = 2,
};

@interface SkilleeRequest : NSObject

@property (nonatomic, strong) NSString* BehalfUserId;
@property (nonatomic, strong) NSString* Title;
@property (nonatomic, strong) NSString* Comment;
@property (nonatomic, strong) NSData* Media;
@property (nonatomic) enum mediaType MediaType;

+(RKObjectMapping*) defineObjectMapping;

@end
