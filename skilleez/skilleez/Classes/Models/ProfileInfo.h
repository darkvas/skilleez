//
//  ProfileInfo.h
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileInfo : NSObject

@property (nonatomic, strong) NSString* UserId;
@property (nonatomic, strong) NSString* Login;
@property (nonatomic, strong) NSString* Password;
@property (nonatomic, strong) NSString* ScreenName;
@property (nonatomic, strong) NSString* FavoriteColor;
@property (nonatomic, strong) NSString* FavoriteSport;
@property (nonatomic, strong) NSString* FavoriteSchoolSubject;
@property (nonatomic, strong) NSString* FavoriteTypeOfMusic;
@property (nonatomic, strong) NSString* FavoriteFood;
@property (nonatomic, strong) NSString* AboutMe;
@property (nonatomic, strong) NSURL* AvatarUrl;
@property (nonatomic, strong, getter = getColor) UIColor* Color;

+(RKObjectMapping*) defineObjectMapping;

@end
