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
static NSString *GET_WAITING_FOR_APPROVAL_URI = @"api/Skillee/GetWaitingForApprovalList";
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
static NSString *GET_ADULTPERMISSIONS = @"api/User/GetAdultPermissions";

static NSString *GET_PROFILEINFO_URI = @"api/Profile/GetProfileInfo";
static NSString *POST_PROFILEIMAGE_URI = @"api/Profile/EditProfileImage";
static NSString *POST_PROFILEINFO_URI = @"api/Profile/EditProfileInfo";

static NSString *POST_FOLLOW_USER = @"api/Loop/FollowUser";
static NSString *POST_UNFOLLOW_USER = @"api/Loop/UnfollowUser";

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

#pragma mark - Private Metods

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
    RKObjectMapping *userInfoMapping = [UserInfo defineObjectMapping];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userInfoMapping
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:GET_USERINFO_URI
                                                                               keyPath:@"ReturnValue"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    RKObjectMapping *skilleeMapping = [SkilleeModel defineObjectMapping];
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:skilleeMapping
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
                                                                            pathPattern:GET_WAITING_FOR_APPROVAL_URI
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
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[AdultPermission defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_ADULTPERMISSIONS
                                                                                keyPath:@"ReturnValue"
                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:[ProfileInfo defineObjectMapping]
                                                                                 method:RKRequestMethodGET
                                                                            pathPattern:GET_PROFILEINFO_URI
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
    
}

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBeck: (void(^)(BOOL loginResult, NSError* error)) loginCallBack
{
    _username = username;
    _password = password;
    
    [self getUserInfo:^(UserInfo *userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{loginCallBack(YES, nil);});
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{loginCallBack(NO, error);});
    }];
}

-(void) getUserInfo:(void (^)(UserInfo *userInfo))successUserInfo failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];

    [manager getObjectsAtPath:[SKILLEEZ_URL stringByAppendingString:GET_USERINFO_URI]
                         parameters:nil
                            success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{successUserInfo(mappingResult.firstObject);});
     }
                            failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) getSkilleeList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(errorFunc)failure
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@?Count=%i&Offset=%i", SKILLEEZ_URL, GET_SKILLEE_LIST_URI, count, offset];
    [self prepareSkilleeRequest];
    [self getSkilleeResultForUrl:requestUrl withSuccess:successGetSkilleeList failure:failure];
}

-(void) prepareSkilleeRequest
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
}

-(void) getSkilleeResultForUrl: (NSString*) requestUrl withSuccess: (void (^)(NSArray *skilleeList))successSkillee failure:(errorFunc)failure
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
         dispatch_async(dispatch_get_main_queue(), ^{successSkillee(skilleArray);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) getSkilleeListForUser:(NSString*) userId count: (int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(errorFunc)failure
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@?UserId=%@&Count=%i&Offset=%i", SKILLEEZ_URL, GET_USER_SKILLEE_LIST_URI, userId, count, offset];
    [self prepareSkilleeRequest];
    [self getSkilleeResultForUrl:requestUrl withSuccess:successGetSkilleeList failure:failure];
}

-(void) getWaitingForApproval:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(errorFunc)failure
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@?Count=%i&Offset=%i", SKILLEEZ_URL, GET_WAITING_FOR_APPROVAL_URI, count, offset];
    [self prepareSkilleeRequest];
    [self getSkilleeResultForUrl:requestUrl withSuccess:successGetSkilleeList failure:failure];
}

-(void) getFavoriteList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(errorFunc)failure
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@?Count=%i&Offset=%i", SKILLEEZ_URL, GET_FAVORITE_LIST, count, offset];
    [self prepareSkilleeRequest];
    [self getSkilleeResultForUrl:requestUrl withSuccess:successGetSkilleeList failure:failure];
}

-(void) getWaitingForApprovalCountSuccess: (void (^)(int approvalCount))success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@%@?Count=%i&Offset=%i", SKILLEEZ_URL, GET_WAITING_FOR_APPROVAL_COUNT, 1, 0]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         int resultCount = [((PostResponse*)mappingResult.firstObject).ReturnValue integerValue];
         dispatch_async(dispatch_get_main_queue(), ^{success(resultCount);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSMutableURLRequest *request = [manager multipartFormRequestWithObject:skilleeRequest
                                                                    method:RKRequestMethodPOST
                                                                      path:[SKILLEEZ_URL stringByAppendingString:POST_CREATE_SKILLEE]
                                                                parameters:nil
                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { }];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"BehalfUserId\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n%@", skilleeRequest.BehalfUserId] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
                                                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{success();});
                                                                             }
                                                                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
                                                                             }];
    [manager enqueueObjectRequestOperation:operation];
}

-(void) postRemoveSkillee:(NSString*) skilleeId success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{@"Id": skilleeId};
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_REMOVE] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postAddToFavorites:(NSString*) skilleeId success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{@"Id": skilleeId};
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_ADD_TO_FAVORITES] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postRemoveFromFavorites:(NSString*) skilleeId success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{@"Id": skilleeId};
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_REMOVE_FROM_FAVORITES] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postMarkAsTatle:(NSString*) skilleeId success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{@"Id": skilleeId};
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_MARK_AS_TATTLE] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postApproveOrDenySkillee:(NSString*) skilleeId isApproved:(BOOL)approved success: (void (^)(void))success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
        @"SkilleeID": skilleeId,
        @"IsApproved": approved ? @"true" : @"false",
    };
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_APPROVE_OR_DENY] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

//TODO: service always return error - check it later
-(void) getCanApprove: (NSString*) skilleeId success: (void (^)(bool canApprove))success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@%@?Id=%@", SKILLEEZ_URL, GET_CAN_APPROVE, skilleeId]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSLog(@"success: mappings: %@", mappingResult.firstObject);
         BOOL result = (BOOL)mappingResult.firstObject;
         dispatch_async(dispatch_get_main_queue(), ^{success(result);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         NSLog (@"failure: operation: %@ \n\nerror: %@", operaton, error);
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

#pragma mark User - need to test

-(void) postAddChildToFamily:(NSString*) childName withPass:(NSString*) childPassword success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                                   @"ChildID": childName,
                                   @"ChildPassword": childPassword
                               };
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_ADD_CHILD_TO_FAMILY] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postInviteAdultToFamily:(NSString*) email success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Email": email
                               };
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_INVITE_ADULT_TO_FAMILY] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postRemoveMemberFromFamily:(NSString*) mainFamilyUserId memberId: (NSString*) memberId success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
    NSDictionary *jsonData = @{
                               @"MainFamilyUserId": mainFamilyUserId,
                               @"MemberId": memberId
                               };
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_INVITE_ADULT_TO_FAMILY] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) getFriendsAnsFamily: (NSString*) userId success: (void (^)(NSArray *friends))success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@%@?Id=%@", SKILLEEZ_URL, GET_FRIENDS_AND_FAMILY, userId]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* familyMembers = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[FamilyMemberModel class]])
                 [familyMembers addObject:obj];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{success(familyMembers);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) getAdultPermissions: (NSString*) userId forAdultId: (NSString*) adultId success: (void (^)(NSArray *permissions))success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@%@?MainFamilyUserId=%@&AdultId=%@", SKILLEEZ_URL, GET_ADULTPERMISSIONS, userId, adultId]
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSMutableArray* permissions = [NSMutableArray new];
         for (NSObject* obj in mappingResult.array) {
             if([obj isKindOfClass:[AdultPermission class]])
                 [permissions addObject:obj];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{success(permissions);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

#pragma mark Profile - need to test

-(void) getProfileInfo:(NSString*) userId success: (void (^)(ProfileInfo *profileInfo))success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@%@?Id=%@", SKILLEEZ_URL, GET_PROFILEINFO_URI, userId]
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

         dispatch_async(dispatch_get_main_queue(), ^{success(profile);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postProfileImage: (NSData*) imageData success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSMutableURLRequest *request = [manager multipartFormRequestWithObject:imageData
                                                                    method:RKRequestMethodPOST
                                                                      path:[SKILLEEZ_URL stringByAppendingString:POST_PROFILEIMAGE_URI]
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
                                                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{success();});
                                                                             }
                                                                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
                                                                             }];
    [manager enqueueObjectRequestOperation:operation];
}

-(void) postProfileInfo: (ProfileInfo*) profileInfo success: (voidFunc)success failure:(errorFunc)failure
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
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_PROFILEINFO_URI] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

#pragma mark FOLLOW/UNFOLLOW

-(void) postFollowUser: (NSString*) userId success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": userId
                               };
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_FOLLOW_USER] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) postUnfollowUser: (NSString*) userId success: (voidFunc)success failure:(errorFunc)failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    NSDictionary *jsonData = @{
                               @"Id": userId
                               };
    
    [manager postObject:nil path:[SKILLEEZ_URL stringByAppendingString:POST_UNFOLLOW_USER] parameters:jsonData
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{success();});
     }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

@end