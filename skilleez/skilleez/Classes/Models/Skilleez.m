//
//  Skilleez.m
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "Skilleez.h"

@implementation Skilleez

- (id)initWithUsername:(NSString *)name andDate:(NSDate *)date andUserAvatar:(NSData *)avatar andAttachment:(NSData *)attachment andSkilleezTitle:(NSString *)title andSkilleezComment:(NSString *)comment
{
    if (self = [super init]) {
        self.userName = name;
        self.date = date;
        self.userAvatar = avatar;
        self.attachment = attachment;
        self.skilleezTitle = title;
        self.skilleezComment = comment;
    }
    return self;
}
@end
