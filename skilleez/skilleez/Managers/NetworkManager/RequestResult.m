//
//  RequestReturnValue.m
//  skilleez
//
//  Created by Vasya on 4/15/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "RequestResult.h"

@implementation RequestResult

-(id) initWithValue: (NSObject*) theValue
{
    if (self = [super init]) {
        _returnArray = [[NSArray alloc] initWithObjects:theValue, nil];
        _isSuccess = YES;
    }
    return self;
}

-(id) initWithValueArray: (NSArray*) theArray
{
    if (self = [super init]) {
        _returnArray = [[NSArray alloc] initWithArray:theArray];
        _isSuccess = YES;
    }
    return self;
}

-(id) initWithError: (NSError*) theError
{
    if (self = [super init]) {
        _error = theError;
        _isSuccess = NO;
    }
    return self;
}

-(NSObject*) getFirstObject
{
    if (self.returnArray && self.returnArray.count > 0)
        return [self.returnArray firstObject];
    return nil;
}

@end