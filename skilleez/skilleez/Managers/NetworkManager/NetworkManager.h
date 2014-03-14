//
//  SkilleezService.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "UserInfo.h"

@interface NetworkManager : NSObject

+(instancetype)sharedInstance;

-(void) LoginWithUserName:(NSString *)username password:(NSString*)password;
-(void) getUserInfo:(void (^)(UserInfo *userInfo))successUserInfo failure:(void (^)(NSError *error))failure;

@end