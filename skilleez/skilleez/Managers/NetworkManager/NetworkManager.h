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

typedef void (^errorFunc)(NSError*);
typedef void (^voidFunc)(void);

+(instancetype)sharedInstance;

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBeck: (void(^)(BOOL loginResult, NSError* error)) loginCallBack;
-(void) getUserInfo:(void (^)(UserInfo *userInfo))successUserInfo failure:(errorFunc)failure;
-(void) getSkilleeList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(errorFunc)failure;
-(void) getSkilleeListForUser:(NSString*) userId count: (int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(errorFunc)failure;
-(void) getWaitingForApproval:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(errorFunc)failure;
-(void) getWaitingForApprovalCountSuccess: (void (^)(int approvalCount))success failure:(errorFunc)failure;
-(void) getFavoriteList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(errorFunc)failure;

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest success: (voidFunc)success failure:(errorFunc)failure;
-(void) postRemoveSkillee:(NSString*) skilleeId success: (voidFunc)success failure:(errorFunc)failure;
-(void) postAddToFavorites:(NSString*) skilleeId success: (voidFunc)success failure:(errorFunc)failure;
-(void) postRemoveFromFavorites:(NSString*) skilleeId success: (voidFunc)success failure:(errorFunc)failure;
-(void) postMarkAsTatle:(NSString*) skilleeId success: (voidFunc)success failure:(errorFunc)failure;
-(void) postApproveOrDenySkillee:(NSString*) skilleeId isApproved:(BOOL)approved success: (void (^)(void))success failure:(errorFunc)failure;
-(void) getCanApprove: (NSString*) skilleeId success: (void (^)(bool canApprove))success failure:(errorFunc)failure;

-(void) getFriendsAnsFamily: (NSString*) userId success: (void (^)(NSArray *friends))success failure:(errorFunc)failure;
-(void) postAddChildToFamily:(NSString*) childName withPass:(NSString*) childPassword success: (void (^)(void))success failure:(errorFunc)failure;
-(void) postInviteAdultToFamily:(NSString*) email success: (voidFunc)success failure:(errorFunc)failure;
-(void) getAdultPermissions: (NSString*) userId forAdultId: (NSString*) adultId success: (void (^)(NSArray *permissions))success failure:(errorFunc)failure;

-(void) getProfileInfo:(NSString*) userId success: (void (^)(ProfileInfo *profileInfo))success failure:(errorFunc)failure;
-(void) postProfileImage: (NSData*) imageData success: (voidFunc)success failure:(errorFunc)failure;
-(void) postProfileInfo: (ProfileInfo*) profileInfo success: (voidFunc)success failure:(errorFunc)failure;

-(void) postFollowUser: (NSString*) userId success: (voidFunc)success failure:(errorFunc)failure;
-(void) postUnfollowUser: (NSString*) userId success: (voidFunc)success failure:(errorFunc)failure;

@end