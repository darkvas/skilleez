//
//  SkilleezService.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "SkilleeModel.h"
#import "SkilleeRequest.h"
#import "FamilyMemberModel.h"
#import "ProfileInfo.h"
#import "AdultPermission.h"
#import "RequestResult.h"
#import "InvitorModel.h"
#import "LoopInvitationModel.h"
#import "InviteeModel.h"

@interface NetworkManager : NSObject

typedef void (^requestCallBack)(RequestResult* requestResult);

+(instancetype)sharedInstance;

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBack: (requestCallBack) loginCallBack;
-(void) getUserInfo:(requestCallBack) callBack;
-(void) getSkilleeList:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack;
-(void) getSkilleeListForUser:(NSString*) userId count: (int) count offset: (int) offset withCallBack: (requestCallBack) callBack;
-(void) getWaitingForApprovalSkilleez:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack;
- (void)getWaitingForApprovalList:(requestCallBack)callBack;
-(void) getWaitingForApprovalCount: (requestCallBack) callBack;
-(void) getFavoriteList:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack;
- (void) getPendingInvitations:(int)count offset:(int)offset withCallBack:(requestCallBack)callBack;

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest withCallBack: (requestCallBack) callBack;
-(void) postRemoveSkillee:(NSString*) skilleeId withCallBack: (requestCallBack) callBack;
-(void) postAddToFavorites:(NSString*) skilleeId withCallBack: (requestCallBack) callBack;
-(void) postRemoveFromFavorites:(NSString*) skilleeId withCallBack: (requestCallBack) callBack;
-(void) postMarkAsTatle:(NSString*) skilleeId withCallBack: (requestCallBack) callBack;
-(void) postApproveOrDenySkillee:(NSString*) skilleeId isApproved:(BOOL)approved withCallBack: (requestCallBack) callBack;
-(void) getCanApprove: (NSString*) skilleeId withCallBack: (requestCallBack) callBack;

-(void) getFriendsAnsFamily: (NSString*) userId withCallBack: (requestCallBack) callBack;
-(void) getFamilyMembers: (NSString*) userId withCallBack: (requestCallBack) callBack;
-(void) postAddChildToFamily:(NSString*) childName withPass:(NSString*) childPassword withCallBack: (requestCallBack) callBack;
-(void) postInviteAdultToFamily:(NSString*) email withCallBack: (requestCallBack) callBack;
-(void) getAdultPermissions: (NSString*) userId forAdultId: (NSString*) adultId withCallBack: (requestCallBack) callBack;
- (void) postSetAdultPermissions:(AdultPermission*) permission withCallBack:(requestCallBack)callBack;

-(void) getProfileInfoByLogin:(NSString*) login withCallBack:(requestCallBack)callBack;
-(void) getProfileInfoByUserId:(NSString*) userId withCallBack: (requestCallBack) callBack;
-(void) postProfileImage: (NSData*) imageData withCallBack: (requestCallBack) callBack;
-(void) postProfileInfo: (ProfileInfo*) profileInfo withCallBack: (requestCallBack) callBack;

-(void) postFollowUser: (NSString*) userId withCallBack: (requestCallBack) callBack;
-(void) postUnfollowUser: (NSString*) userId withCallBack: (requestCallBack) callBack;
- (void)getLoopById:(NSString *)userId count:(int)count offset:(int)offset withCallBack:(requestCallBack)callBack;

-(void) postInviteToLoopByUserId: (NSString*) userId withCallBack: (requestCallBack) callBack;
-(void) postInviteToLoopByEmail: (NSString*) email withCallBack: (requestCallBack) callBack;
- (void)postAcceptInvitationToLoop:(NSString *)invitationId withCallBack:(requestCallBack)callBack;
- (void)postDeclineInvitationToLoop:(NSString *)invitationId withCallBack:(requestCallBack)callBack;
- (void)postApproveInvitationToLoop:(NSString *)invitationId withCallBack:(requestCallBack)callBack;
- (void)postDisapproveInvitationToLoop:(NSString *)invitationId withCallBack:(requestCallBack)callBack;

@end