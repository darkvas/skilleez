//
//  UserSetingsManager.m
//  skilleez
//
//  Created by Vasya on 3/17/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "UserSettingsManager.h"

#define USER_SETTINGS @"UserSettings"

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

- (void) loadSettings
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

@end
