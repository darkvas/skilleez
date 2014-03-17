//
//  Skilleez.h
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Skilleez : NSObject
@property (nonatomic) NSString *userName;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *userAvatar;
@property (nonatomic) NSString *attachment;
@property (nonatomic) NSString *skilleezTitle;
@property (nonatomic) NSString *skilleezComment;

- (id)initWithUsername:(NSString *)name andDate:(NSDate *)date andUserAvatar:(NSString *)avatar andAttachment:(NSString *)attachment andSkilleezTitle:(NSString *)title andSkilleezComment:(NSString *)comment;
@end
