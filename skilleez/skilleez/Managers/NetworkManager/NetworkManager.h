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
#import "FamilyMemberModel.h"

@interface NetworkManager : NSObject

+(instancetype)sharedInstance;

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBeck: (void(^)(BOOL loginResult, NSError* error)) loginCallBack;
-(void) getUserInfo:(void (^)(UserInfo *userInfo))successUserInfo failure:(void (^)(NSError *error))failure;
-(void) getSkilleeList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getSkilleeListForUser:(int) userId count: (int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getWaitingForApproval:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getFavoriteList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postRemoveSkillee:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postAddToFavorites:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postRemoveFromFavorites:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postMarkAsTatle:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postApproveOrDenySkillee:(NSString*) skilleeId isApproved:(BOOL)approved success: (void (^)(void))success failure:(void (^)(NSError *error))failure;

-(void) getFriendsAnsFamily: (NSString*) userId success: (void (^)(NSArray *friends))success failure:(void (^)(NSError *error))failure;

@end