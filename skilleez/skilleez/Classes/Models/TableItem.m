//
//  TableItem.m
//  skilleez
//
//  Created by Roma on 3/27/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "TableItem.h"

@implementation TableItem

- (id)initWithName:(NSString *)name image:(UIImage *)image method:(NSString *)method
{
    if (self = [super init]) {
        self.name = name;
        self.image = image;
        self.method = method;
    }
    return self;
}

@end
