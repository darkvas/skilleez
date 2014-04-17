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

@interface NetworkManager : NSObject

typedef void (^requestCallBack)(RequestResult* requestResult);

+(instancetype)sharedInstance;

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBack: (requestCallBack) loginCallBack;
-(void) getUserInfo:(requestCallBack) callBack;
-(void) getSkilleeList:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack;
-(void) getSkilleeListForUser:(NSString*) userId count: (int) count offset: (int) offset withCallBack: (requestCallBack) callBack;
-(void) getWaitingForApprovalSkilleez:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack;
-(void) getWaitingForApprovalCount: (requestCallBack) callBack;
-(void) getFavoriteList:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack;

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest withCallBack: (requestCallBack) callBack;
-(void) postRemoveSkillee:(NSString*) skilleeId withCallBack: (requestCallBack) callBack;
-(void) postAddToFavorites:(NSString*) skilleeId withCallBack: (requestCallBack) callBack;
-(void) postRemoveFromFavorites:(NSString*) skilleeId withCallBack: (requestCallBack) callBack;
-(void) postMarkAsTatle:(NSString*) skilleeId withCallBack: (requestCallBack) callBack;
-(void) postApproveOrDenySkillee:(NSString*) skilleeId isApproved:(BOOL)approved withCallBack: (requestCallBack) callBack;
-(void) getCanApprove: (NSString*) skilleeId withCallBack: (requestCallBack) callBack;

-(void) getFriendsAnsFamily: (NSString*) userId withCallBack: (requestCallBack) callBack;
-(void) postAddChildToFamily:(NSString*) childName withPass:(NSString*) childPassword withCallBack: (requestCallBack) callBack;
-(void) postInviteAdultToFamily:(NSString*) email withCallBack: (requestCallBack) callBack;
-(void) getAdultPermissions: (NSString*) userId forAdultId: (NSString*) adultId withCallBack: (requestCallBack) callBack;

-(void) getProfileInfo:(NSString*) userId withCallBack: (requestCallBack) callBack;
-(void) postProfileImage: (NSData*) imageData withCallBack: (requestCallBack) callBack;
-(void) postProfileInfo: (ProfileInfo*) profileInfo withCallBack: (requestCallBack) callBack;

-(void) postFollowUser: (NSString*) userId withCallBack: (requestCallBack) callBack;
-(void) postUnfollowUser: (NSString*) userId withCallBack: (requestCallBack) callBack;
- (void)getLoopById:(NSString *)userId count:(int)count offset:(int)offset withCallBack:(requestCallBack)callBack;

@end