//
//  TableItem.h
//  skilleez
//
//  Created by Roma on 3/27/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableItem : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *method;

- (id)initWithName:(NSString *)name image:(UIImage *)image method:(NSString *)method;

@end
