//
//  SkilleezService.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "NetworkManager.h"
#import "PostResponse.h"

static NSString *SKILLEEZ_URL = @"http://skilleezv3.elasticbeanstalk.com/";
static NSString *LOGIN_URI = @"Account/LogOn";
static NSString *GET_USERINFO_URI = @"api/User/GetMyInfo";
static NSString *GET_SKILLEE_LIST_URI = @"api/Skillee/GetList";
static NSString *GET_USER_SKILLEE_LIST_URI = @"api/Skillee/GetUserSkilleezList";
static NSString *GET_WAITING_FOR_APPROVAL_LIST_URI = @"api/Skillee/GetWaitingForApprovalList";
static NSString *GET_WAITING_FOR_APPROVAL_SKILLEEZ_URI = @"api/Skillee/GetWaitingForApprovalSkilleezList";
static NSString *GET_WAITING_FOR_APPROVAL_COUNT = @"api/Skillee/GetWaitingForApprovalCount";
static NSString *GET_FAVORITE_LIST = @"api/Skillee/GetFavoriteList";
static NSString *GET_CAN_APPROVE = @"api/Skillee/CanApprove";

static NSString *POST_CREATE_SKILLEE = @"api/Skillee/CreateSkilleez";
static NSString *POST_REMOVE = @"api/Skillee/Remove";
static NSString *POST_ADD_TO_FAVORITES = @"api/Skillee/AddToFavorites";
static NSString *POST_REMOVE_FROM_FAVORITES = @"api/Skillee/RemoveFromFavorites";
static NSString *POST_MARK_AS_TATTLE = @"api/Skillee/MarkAsTattle";
static NSString *POST_APPROVE_OR_DENY = @"api/Skillee/ApproveOrDeny";

static NSString *POST_ADD_CHILD_TO_FAMILY = @"api/User/AddChildToTheFamily";
static NSString *POST_INVITE_ADULT_TO_FAMILY = @"api/User/InviteAdultToTheFamily";
static NSString *POST_REMOVE_MEMBER_FROM_FAMILY = @"api/User/DeleteMemberFromTheFamily";
static NSString *GET_FRIENDS_AND_FAMILY = @"api/User/GetFriendsAndFamily";
static NSString *GET_FAMILY_MEMBERS = @"api/User/GetFamilyMembers";
static NSString *GET_ADULTPERMISSIONS = @"api/User/GetAdultPermissions";
static NSString *POST_SETADULTPERMISSIONS = @"api/User/SetAdultPermissions";

static NSString *GET_PROFILEINFO_URI = @"api/Profile/GetProfileInfoById";
static NSString *GET_PROFILEINFO_BY_LOGIN = @"api/Profile/GetProfileInfoByLogin";//?Login={Login}
static NSString *POST_PROFILEIMAGE_URI = @"api/Profile/EditProfileImage";
static NSString *POST_PROFILEINFO_URI = @"api/Profile/EditProfileInfo";

static NSString *GET_LOOP_BY_ID = @"api/Loop/GetLoopById";
static NSString *GET_WAITING_FOR_APPROVAL_INVITATIONS_URI = @"api/Loop/GetWaitingForApprovalInvitationsToLoop";
static NSString *POST_FOLLOW_USER = @"api/Loop/FollowUser";
static NSString *POST_UNFOLLOW_USER = @"api/Loop/UnfollowUser";

static NSString *GET_PENDING_INVITATIONS_TO_LOOP = @"api/Loop/GetPendingInvitationsToLoop";
static NSString *GET_WAITING_FOR_APPROVAL_INVITATIONS_TO_LOOP = @"api/Loop/GetWaitingForApprovalInvitationsToLoop";
static NSString *POST_INVITE_TO_LOOP_BY_USERID = @"api/Loop/InviteToLoopByUserId";
static NSString *POST_INVITE_TO_LOOP_BY_EMAIL = @"api/Loop/InviteToLoopByEmail";
static NSString *POST_ACCEPT_INVITATION_TO_LOOP = @"api/Loop/AcceptInvitationToLoop";
static NSString *POST_DECLINE_INVITATION_TO_LOOP = @"api/Loop/DeclineInvitationToLoop";
static NSString *POST_APPROVE_INVITATION_TO_LOOP = @"api/Loop/ApproveInvitationToLoop";
static NSString *POST_DISAPPROVE_INVITATION_TO_LOOP = @"api/Loop/DisapproveInvitationToLoop";

@implementation NetworkManager
{
    RKObjectManager* manager;
    NSString* _username;
    NSString* _password;
}

#pragma mark - Public Metods

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupRestKit];
    }
    return self;
}

- (void)setupRestKit
{
    manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SKILLEEZ_URL]];
    [manager.HTTPClient setDefaultHeader: @"Accept" value:RKMIMETypeJSON];
    
    [self initResponseDescriptors];
}

-(void) initResponseDescriptors
{
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[UserInfo defineObjectMapping]
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:GET_USERINFO_URI
                                                                               keyPath:@"ReturnValue"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    RKObjectMapping *skilleeMapping = [SkilleeModel defineObjectMapping];
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[SkilleeModel defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_SKILLEE_LIST_URI
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:skilleeMapping
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_USER_SKILLEE_LIST_URI
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:skilleeMapping
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_WAITING_FOR_APPROVAL_SKILLEEZ_URI
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:skilleeMapping
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_FAVORITE_LIST
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:GET_WAITING_FOR_APPROVAL_COUNT
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_CREATE_SKILLEE
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_REMOVE
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_ADD_TO_FAVORITES
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_REMOVE_FROM_FAVORITES
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_MARK_AS_TATTLE
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_APPROVE_OR_DENY
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_CAN_APPROVE
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_ADD_CHILD_TO_FAMILY
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_INVITE_ADULT_TO_FAMILY
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[FamilyMemberModel defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_FRIENDS_AND_FAMILY
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[FamilyMemberModel defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_FAMILY_MEMBERS
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[AdultPermission defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_ADULTPERMISSIONS
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_SETADULTPERMISSIONS
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[ProfileInfo defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_PROFILEINFO_URI
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[ProfileInfo defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_PROFILEINFO_BY_LOGIN
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_PROFILEIMAGE_URI
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_PROFILEINFO_URI
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_FOLLOW_USER
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_UNFOLLOW_USER
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[UserInfo defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_LOOP_BY_ID
                                                                                keyPath:@"ReturnValue.FriendsFromLoop"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_INVITE_TO_LOOP_BY_USERID
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_INVITE_TO_LOOP_BY_EMAIL
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    RKObjectMapping *inviteeMapping = [InviteeModel defineObjectMapping];
    RKObjectMapping *invitorMapping = [InvitorModel defineObjectMapping];
    RKObjectMapping *invitationMapping = [LoopInvitationModel defineObjectMapping];
    
    [invitationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Invitee"
                                                                                      toKeyPath:@"Invitee"
                                                                                    withMapping:inviteeMapping]];
    
    [invitationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Invitor"
                                                                                      toKeyPath:@"Invitor"
                                                                                    withMapping:invitorMapping]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:invitationMapping
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_WAITING_FOR_APPROVAL_LIST_URI
                                                                                keyPath:@"ReturnValue.LoopInvitations"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:skilleeMapping
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_WAITING_FOR_APPROVAL_LIST_URI
                                                                                keyPath:@"ReturnValue.Skilleez"
                                                                            statusCodes:RKStatusCodeIndexSetForClass (RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:invitationMapping
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_PENDING_INVITATIONS_TO_LOOP
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_ACCEPT_INVITATION_TO_LOOP
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_DECLINE_INVITATION_TO_LOOP
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_APPROVE_INVITATION_TO_LOOP
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:POST_DISAPPROVE_INVITATION_TO_LOOP
                                                                                keyPath:nil
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

#pragma mark - User requests

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBack: (requestCallBack) loginCallBack
{
    _username = username;
    _password = password;
    
    [self getUserInfo:^(RequestResult * requestResult) {
        dispatch_async(dispatch_get_main_queue(), ^{loginCallBack(requestResult);});
    } ];
}

-(void) getUserInfo:(requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:GET_USERINFO_URI
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:mappingResult.firstObject]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) getSkilleeList:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@?Count=%i&Offset=%i", GET_SKILLEE_LIST_URI, count, offset];
    [self prepareSkilleeRequest];
    [self getSkilleeResultForUrl:requestUrl withCallBack: callBack];
}

-(void) prepareSkilleeRequest
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
}

-(void) getSkilleeResultForUrl: (NSString*) requestUrl withCallBack: (requestCallBack) callBack
{
    [manager getObjectsAtPath:requestUrl
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* skilleArray = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[SkilleeModel class]])
                 [skilleArray addObject:obj];
         }
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValueArray:skilleArray]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) getSkilleeListForUser:(NSString*) userId count: (int) count offset: (int) offset withCallBack: (requestCallBack) callBack
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@?UserId=%@&Count=%i&Offset=%i", GET_USER_SKILLEE_LIST_URI, userId, count, offset];
    [self prepareSkilleeRequest];
    [self getSkilleeResultForUrl:requestUrl withCallBack: callBack];
}

-(void) getWaitingForApprovalSkilleez:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@?Count=%i&Offset=%i", GET_WAITING_FOR_APPROVAL_SKILLEEZ_URI, count, offset];
    [self prepareSkilleeRequest];
    [self getSkilleeResultForUrl:requestUrl withCallBack: callBack];
}

-(void) getFavoriteList:(int) count offset: (int) offset withCallBack: (requestCallBack) callBack
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@?Count=%i&Offset=%i", GET_FAVORITE_LIST, count, offset];
    [self prepareSkilleeRequest];
    [self getSkilleeResultForUrl:requestUrl withCallBack: callBack];
}

-(void) getWaitingForApprovalCount: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?Count=%i&Offset=%i", GET_WAITING_FOR_APPROVAL_COUNT, 1, 0]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         int resultCount = [((PostResponse*)mappingResult.firstObject).ReturnValue integerValue];
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:@(resultCount)]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}


- (void)getWaitingForApprovalList:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    [manager getObjectsAtPath:GET_WAITING_FOR_APPROVAL_LIST_URI
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* skilleArray = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             //if([obj isKindOfClass:[SkilleeModel class]])
                 [skilleArray addObject:obj];
         }
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValueArray:skilleArray]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

#pragma mark - Skillee methods

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSMutableURLRequest *request = [manager multipartFormRequestWithObject:skilleeRequest
                                                                    method:RKRequestMethodPOST
                                                                      path:POST_CREATE_SKILLEE
                                                                parameters:nil
                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { }];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"BehalfUserId\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n%@", skilleeRequest.BehalfUserId ? skilleeRequest.BehalfUserId : @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"Title\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n%@", skilleeRequest.Title] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"Comment\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n%@", skilleeRequest.Comment] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if(skilleeRequest.MediaType == mediaTypeImage){
        [body appendData:[@"Content-Disposition: form-data; name=\"Media\";filename=\"picture.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }else if(skilleeRequest.MediaType == mediaTypeVideo){
        [body appendData:[@"Content-Disposition: form-data; name=\"Media\";filename=\"video.mp4\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:skilleeRequest.Media];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [request setHTTPBody:body];
    
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
                                                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:@(YES)]);});
                                           }
                                                                             failure:^(RKObjectRequestOperation *operation, NSError *error)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
                                           }];
    
    [manager enqueueObjectRequestOperation:operation];
}

-(void) postRemoveSkillee:(NSString*) skilleeId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{@"Id": skilleeId};
    
    [manager postObject:nil path:POST_REMOVE parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:skilleeId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postAddToFavorites:(NSString*) skilleeId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{@"Id": skilleeId};
    
    [manager postObject:nil path:POST_ADD_TO_FAVORITES parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:skilleeId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postRemoveFromFavorites:(NSString*) skilleeId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{@"Id": skilleeId};
    
    [manager postObject:nil path:POST_REMOVE_FROM_FAVORITES parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:skilleeId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postMarkAsTatle:(NSString*) skilleeId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{@"Id": skilleeId};
    
    [manager postObject:nil path:POST_MARK_AS_TATTLE parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:skilleeId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postApproveOrDenySkillee:(NSString*) skilleeId isApproved:(BOOL)approved withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
        @"SkilleeID": skilleeId,
        @"IsApproved": approved ? @"true" : @"false",
    };
    
    [manager postObject:nil path:POST_APPROVE_OR_DENY parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:skilleeId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

//TODO: service always return error - check it later
-(void) getCanApprove: (NSString*) skilleeId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?Id=%@", GET_CAN_APPROVE, skilleeId]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSLog(@"success: mappings: %@", mappingResult.firstObject);
         BOOL result = (BOOL)mappingResult.firstObject;
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:@(result)]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         NSLog (@"failure: operation: %@ \n\nerror: %@", operaton, error);
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

#pragma mark User - need to test

-(void) postAddChildToFamily:(NSString*) childName withPass:(NSString*) childPassword withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                                   @"ChildID": childName,
                                   @"ChildPassword": childPassword
                               };
    
    [manager postObject:nil path:POST_ADD_CHILD_TO_FAMILY parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:childName]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postInviteAdultToFamily:(NSString*) email withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Email": email
                               };
    
    [manager postObject:nil path:POST_INVITE_ADULT_TO_FAMILY parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:email]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postRemoveMemberFromFamily:(NSString*) mainFamilyUserId memberId: (NSString*) memberId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"MainFamilyUserId": mainFamilyUserId,
                               @"MemberId": memberId
                               };
    
    [manager postObject:nil path:POST_INVITE_ADULT_TO_FAMILY parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:memberId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) getFriendsAnsFamily: (NSString*) userId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?Id=%@", GET_FRIENDS_AND_FAMILY, userId]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* friendsFamilyMembers = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[FamilyMemberModel class]])
                 [friendsFamilyMembers addObject:obj];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValueArray:friendsFamilyMembers]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) getFamilyMembers: (NSString*) userId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?Id=%@", GET_FAMILY_MEMBERS, userId]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* familyMembers = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[FamilyMemberModel class]])
                 [familyMembers addObject:obj];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValueArray:familyMembers]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) getAdultPermissions: (NSString*) userId forAdultId: (NSString*) adultId withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?MainFamilyUserId=%@&AdultId=%@", GET_ADULTPERMISSIONS, userId, adultId]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* permissions = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[AdultPermission class]])
                 [permissions addObject:obj];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValueArray:permissions]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

- (void) postSetAdultPermissions:(AdultPermission*) permission withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": permission.Id,
                               @"MainFamilyUserId": permission.MainFamilyUserId,
                               @"AdultId": permission.AdultId,
                               @"ChildId": permission.ChildId,
                               @"ChangesApproval": permission.ChangesApproval ? @"true" : @"false",
                               @"LoopApproval": permission.LoopApproval ? @"true" : @"false",
                               @"ProfileApproval": permission.ProfileApproval ? @"true" : @"false"
                               };
    
    [manager postObject:nil path:POST_SETADULTPERMISSIONS parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:permission]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

#pragma mark Profile - need to test

-(void) getProfileInfoByUserId:(NSString*) userId withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?Id=%@", GET_PROFILEINFO_URI, userId]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         ProfileInfo* profile;
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[ProfileInfo class]]) {
                 profile = (ProfileInfo*)obj;
                 break;
             }
         }

         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:profile]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) getProfileInfoByLogin:(NSString*) login withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?Login=%@", GET_PROFILEINFO_BY_LOGIN, login]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         ProfileInfo* profile;
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[ProfileInfo class]]) {
                 profile = (ProfileInfo*)obj;
                 break;
             }
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:profile]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postProfileImage: (NSData*) imageData withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSMutableURLRequest *request = [manager multipartFormRequestWithObject:imageData
                                                                    method:RKRequestMethodPOST
                                                                      path:POST_PROFILEIMAGE_URI
                                                                parameters:nil
                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { }];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name=\"Image\";filename=\"picture.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [request setHTTPBody:body];
    
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
                                                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:@(YES)]);});
                                           }
                                                                             failure:^(RKObjectRequestOperation *operation, NSError *error)
                                           {
                                               dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
                                           }];
    [manager enqueueObjectRequestOperation:operation];
}

-(void) postProfileInfo: (ProfileInfo*) profileInfo withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Login": profileInfo.Login ? profileInfo.Login : @"",
                               @"Password": profileInfo.Password ? profileInfo.Password : @"",
                               @"ScreenName": profileInfo.ScreenName ? profileInfo.ScreenName : @"",
                               @"FavoriteColor": profileInfo.FavoriteColor ? profileInfo.FavoriteColor : @"",
                               @"FavoriteSport": profileInfo.FavoriteSport ? profileInfo.FavoriteSport : @"",
                               @"FavoriteSchoolSubject": profileInfo.FavoriteSchoolSubject ? profileInfo.FavoriteSchoolSubject : @"",
                               @"FavoriteTypeOfMusic": profileInfo.FavoriteTypeOfMusic ? profileInfo.FavoriteTypeOfMusic : @"",
                               @"FavoriteFood": profileInfo.FavoriteFood ? profileInfo.FavoriteFood : @"",
                               @"AboutMe": profileInfo.AboutMe ? profileInfo.AboutMe : @""
                               };
    
    [manager postObject:nil path:POST_PROFILEINFO_URI parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:profileInfo]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

#pragma mark FOLLOW/UNFOLLOW

-(void) postFollowUser: (NSString*) userId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": userId
                               };
    
    [manager postObject:nil path:POST_FOLLOW_USER parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:userId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postUnfollowUser: (NSString*) userId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": userId
                               };
    
    [manager postObject:nil path:POST_UNFOLLOW_USER parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:userId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

- (void)getLoopById:(NSString *)userId count:(int)count offset:(int)offset withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?Id=%@&count=%i&offset=%i", GET_LOOP_BY_ID, userId, count, offset]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* friends = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[ProfileInfo class]])
                 [friends addObject:obj];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValueArray:friends]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

#pragma mark - Invitation to loop

- (void) getPendingInvitations:(int)count offset:(int)offset withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@?count=%i&offset=%i", GET_PENDING_INVITATIONS_TO_LOOP, count, offset]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* pendingInvitations = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[LoopInvitationModel class]])
                 [pendingInvitations addObject:obj];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValueArray:pendingInvitations]);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postInviteToLoopByUserId: (NSString*) userId withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": userId
                               };
    
    [manager postObject:nil path:POST_INVITE_TO_LOOP_BY_USERID parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:userId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

-(void) postInviteToLoopByEmail: (NSString*) email withCallBack: (requestCallBack) callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Email": email
                               };
    
    [manager postObject:nil path:POST_INVITE_TO_LOOP_BY_EMAIL parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:email]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

- (void)postAcceptInvitationToLoop:(NSString *)invitationId withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": invitationId
                               };
    
    [manager postObject:nil path:POST_ACCEPT_INVITATION_TO_LOOP parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:invitationId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

- (void)postDeclineInvitationToLoop:(NSString *)invitationId withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": invitationId
                               };

    [manager postObject:nil path:POST_ACCEPT_INVITATION_TO_LOOP parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:invitationId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

- (void)postApproveInvitationToLoop:(NSString *)invitationId withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": invitationId
                               };
    
    [manager postObject:nil path:POST_APPROVE_INVITATION_TO_LOOP parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:invitationId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

- (void)postDisapproveInvitationToLoop:(NSString *)invitationId withCallBack:(requestCallBack)callBack
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": invitationId
                               };
    
    [manager postObject:nil path:POST_DISAPPROVE_INVITATION_TO_LOOP parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithValue:invitationId]);});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{callBack([[RequestResult alloc] initWithError:error]);});
     }];
}

@end