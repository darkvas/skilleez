//
//  UserSetingsManager.m
//  skilleez
//
//  Created by Vasya on 3/17/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "UserSettingsManager.h"

#define USER_SETTINGS @"UserSettings"

@interface UserSettingsManager()
{
    NSMutableSet *observerCollection;
}

@end

@implementation UserSettingsManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        observerCollection = [NSMutableSet new];
    }
    return self;
}

- (void)loadSettings
{
    NSDictionary* dictSets = [[NSUserDefaults standardUserDefaults] objectForKey:USER_SETTINGS];
    self.username = dictSets[@"username"];
    self.password = dictSets[@"password"];
    self.remember = [dictSets[@"remember"] boolValue];
}

- (void)saveSettings
{
    NSDictionary* dictSets = @{@"username": self.username, @"password": self.password, @"remember": @(self.remember)};
    [[NSUserDefaults standardUserDefaults] setObject:dictSets forKey:USER_SETTINGS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteSettings
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_SETTINGS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UserSettingsManager sharedInstance].userInfo = Nil;
    [UserSettingsManager sharedInstance].username = nil;
    [UserSettingsManager sharedInstance].password = nil;
    [UserSettingsManager sharedInstance].IsAdmin = nil;
    [UserSettingsManager sharedInstance].IsAdult = nil;
    [UserSettingsManager sharedInstance].remember = nil;
}

- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    [self notifyUserInfoObservers];
}

#pragma mark - Notify Observers

- (void)addDelegateObserver:(method)observerMethod
{
    [observerCollection addObject:observerMethod];
}

- (void)removeDelegateObserver:(method)observer
{
    [observerCollection removeObject:observer];
}

- (void)notifyUserInfoObservers
{
    for (method observer in observerCollection) {
        dispatch_async(dispatch_get_main_queue(), observer);
    }
}

@end
