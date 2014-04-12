//
//  UserSetingsManager.h
//  skilleez
//
//  Created by Vasya on 3/17/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

typedef void (^method) (void);

@protocol UserInfoObserver <NSObject>

- (void) userInfoLoaded: (NSObject*) sender;

@end

@interface UserSettingsManager : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic) BOOL remember;

@property (nonatomic) BOOL IsAdmin;
@property (nonatomic) BOOL IsVerified;
@property (nonatomic) BOOL IsAdult;

@property (nonatomic, strong, setter = setUserInfo:) UserInfo* userInfo;
@property (nonatomic, strong) NSArray* friendsAndFamily;

-(void) loadSettings;
-(void) saveSettings;

-(void) setUserInfo:(UserInfo *)userInfo;

- (void)addDelegateObserver:(method)observer;
- (void)removeDelegateObserver:(method)observer;

@end
