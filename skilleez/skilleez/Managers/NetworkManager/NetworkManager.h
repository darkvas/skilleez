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
#import "SkilleeModel.h"
#import "SkilleeRequest.h"

@interface NetworkManager : NSObject

+(instancetype)sharedInstance;

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBeck: (void(^)(BOOL loginResult)) loginCallBack;
-(void) getUserInfo:(void (^)(UserInfo *userInfo))successUserInfo failure:(void (^)(NSError *error))failure;
-(void) getSkilleeList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getSkilleeListForUser:(int) userId count: (int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getWaitingForApproval:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getFavoriteList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postRemoveSkillee:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postAddToFavorites:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postRemoveFromFavorites:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;

@end