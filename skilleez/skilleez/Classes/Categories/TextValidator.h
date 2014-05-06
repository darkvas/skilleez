//
//  TextValidator.h
//  skilleez
//
//  Created by Vasya on 5/5/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextValidator : NSObject

+ (BOOL)allowInputCharForAccount:(NSString *) string withRangeLength:(NSUInteger) rangeLength withOldLength:(NSUInteger) oldLength;
+ (BOOL)allowInputCharForPassword:(NSString *) string withRangeLength:(NSUInteger) rangeLength withOldLength:(NSUInteger) oldLength;
+ (BOOL)allowInputCharForText:(NSString *) string withRangeLength:(NSUInteger) rangeLength withOldLength:(NSUInteger) oldLength;
+ (BOOL)allowInputCharForEmail:(NSString *) string withRangeLength:(NSUInteger) rangeLength withOldLength:(NSUInteger) oldLength;

+ (BOOL)validateEmailWithString:(NSString *) email;

@end
