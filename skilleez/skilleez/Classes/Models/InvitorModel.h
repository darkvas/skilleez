//
//  InvitorModel.h
//  skilleez
//
//  Created by Hedgehog on 22.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitorModel : NSObject

@property (nonatomic, strong) NSString *UserId;
@property (nonatomic) BOOL CurrentUserIsApprover;
@property (nonatomic, strong) NSString *Login;
@property (nonatomic, strong) NSString *ScreenName;
@property (nonatomic, strong) NSString *FavoriteColor;
@property (nonatomic, strong) NSURL *AvatarUrl;
@property (nonatomic, strong) NSString *AboutMe;

+ (RKObjectMapping *)defineObjectMapping;

@end
