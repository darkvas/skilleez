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
#import "ProfileInfo.h"
#import "AdultPermission.h"

@interface NetworkManager : NSObject

+(instancetype)sharedInstance;

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBeck: (void(^)(BOOL loginResult, NSError* error)) loginCallBack;
-(void) getUserInfo:(void (^)(UserInfo *userInfo))successUserInfo failure:(void (^)(NSError *error))failure;
-(void) getSkilleeList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getSkilleeListForUser:(int) userId count: (int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getWaitingForApproval:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;
-(void) getWaitingForApprovalCountSuccess: (void (^)(int approvalCount))success failure:(void (^)(NSError *error))failure;
-(void) getFavoriteList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure;

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postRemoveSkillee:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postAddToFavorites:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postRemoveFromFavorites:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postMarkAsTatle:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postApproveOrDenySkillee:(NSString*) skilleeId isApproved:(BOOL)approved success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) getCanApprove: (NSString*) skilleeId success: (void (^)(bool canApprove))success failure:(void (^)(NSError *error))failure;

-(void) getFriendsAnsFamily: (NSString*) userId success: (void (^)(NSArray *friends))success failure:(void (^)(NSError *error))failure;
-(void) postAddChildToFamily:(NSString*) childId withPass:(NSString*) childPassword success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) postInviteAdultToFamily:(NSString*) email success: (void (^)(void))success failure:(void (^)(NSError *error))failure;
-(void) getAdultPermissions: (NSString*) userId forAdultId: (NSString*) adultId success: (void (^)(NSArray *permissions))success failure:(void (^)(NSError *error))failure;

-(void) getProfileInfo:(NSString*) userId success: (void (^)(ProfileInfo *profileInfo))success failure:(void (^)(NSError *error))failure;
-(void) postProfileImage: (NSData*) imageData success: (void (^) (void))success failure:(void (^)(NSError *error))failure;
-(void) postProfileInfo: (ProfileInfo*) profileInfo success: (void (^) (void))success failure:(void (^)(NSError *error))failure;

@end