//
//  RequestReturnValue.h
//  skilleez
//
//  Created by Vasya on 4/15/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestResult : NSObject

@property (nonatomic, readonly) BOOL isSuccess;
@property (nonatomic, strong, readonly) NSArray* returnArray;
@property (nonatomic, strong, readonly, getter = getFirstObject) NSObject* firstObject;
@property (nonatomic, strong, readonly) NSError* error;

-(id) initWithValue: (NSObject*) theValue;
-(id) initWithValueArray: (NSArray*) theArray;
-(id) initWithError: (NSError*) theError;

@end
