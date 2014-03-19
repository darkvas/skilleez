//
//  PostResponse.h
//  skilleez
//
//  Created by Vasya on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostResponse : NSObject

@property (nonatomic, strong) NSString* ResultCode;
@property (nonatomic, strong) NSString* ResultCodeName;
@property (nonatomic, strong) NSString* ErrorMessage;
@property (nonatomic, strong) NSString* ReturnValue;

+(RKObjectMapping*) defineObjectMapping;

@end
