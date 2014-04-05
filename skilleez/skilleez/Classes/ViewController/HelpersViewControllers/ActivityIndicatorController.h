//
//  ActivityIndicatorController.h
//  skilleez
//
//  Created by Vasya on 4/4/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityIndicatorController : NSObject

+(instancetype)sharedInstance;

- (void)startActivityIndicator: (UIViewController*) viewController;
- (void)stopActivityIndicator;

@end
