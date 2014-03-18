//
//  SkilleezService.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "NetworkManager.h"

#define SKILLEEZ_URL @"http://skilleezv3.elasticbeanstalk.com/"
#define LOGIN_URI @"Account/LogOn"
#define GET_USERINFO_URI @"api/User/GetMyInfo"
#define GET_SKILLEE_LIST_URI @"api/Skillee/GetList"
#define GET_USER_SKILLEE_LIST_URI @"api/Skillee/GetUserSkilleezList"
#define GET_WAITING_FOR_APPROVAL_URI @"api/Skillee/GetWaitingForApprovalList"
#define GET_FAVORITE_LIST @"api/Skillee/GetFavoriteList"

#define POST_CREATE_SKILLEE @"api/Skillee/CreateSkilleez"

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

- (void)setupRestKit{
    
    manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SKILLEEZ_URL]];
    [manager.HTTPClient setDefaultHeader: @"Accept" value:RKMIMETypeJSON];
}

-(void) tryLogin:(NSString *)username password:(NSString*)password withLoginCallBeck: (void(^)(BOOL loginResult)) loginCallBack
{
    _username = username;
    _password = password;
    
    [self getUserInfo:^(UserInfo *userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{loginCallBack(YES);});
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{loginCallBack(NO);});
    }];
}

-(void) getUserInfo:(void (^)(UserInfo *userInfo))successUserInfo failure:(void (^)(NSError *error))failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    RKObjectMapping *userInfoMapping = [UserInfo defineObjectMapping];
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userInfoMapping
                                                                                             method:RKRequestMethodGET
                                                                                        pathPattern:nil
                                                                                            keyPath:@"ReturnValue"
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];

    [manager getObjectsAtPath:[SKILLEEZ_URL stringByAppendingString:GET_USERINFO_URI]
                         parameters:nil
                            success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSLog(@"success: mappings: %@", mappingResult.firstObject);
         dispatch_async(dispatch_get_main_queue(), ^{successUserInfo(mappingResult.firstObject);});
     }
                            failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         NSLog (@"failure: operation: %@ \n\nerror: %@", operaton, error);
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) getSkilleeList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure
{
    [self prepareSkilleeRequest];
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@?Count=%i&Offset=%i", SKILLEEZ_URL, GET_SKILLEE_LIST_URI, count, offset];
    [self getSkilleeResultForUrl:requestUrl withSuccess:successGetSkilleeList failure:failure];
}

-(void) prepareSkilleeRequest
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    RKObjectMapping *skilleeMapping = [SkilleeModel defineObjectMapping];
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:skilleeMapping
                                                                                             method:RKRequestMethodGET
                                                                                        pathPattern:nil
                                                                                            keyPath:@"ReturnValue"
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
}

-(void) getSkilleeResultForUrl: (NSString*) requestUrl withSuccess: (void (^)(NSArray *skilleeList))successSkillee failure:(void (^)(NSError *error))failure
{
    [manager getObjectsAtPath:requestUrl
                   parameters:nil
                      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         dispatch_async(dispatch_get_main_queue(), ^{successSkillee(mappingResult.array);});
     }
                      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

-(void) getSkilleeListForUser:(int) userId count: (int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure
{
    [self prepareSkilleeRequest];
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@?UserId=%iCount=%i&Offset=%i", SKILLEEZ_URL, GET_USER_SKILLEE_LIST_URI, userId, count, offset];
    [self getSkilleeResultForUrl:requestUrl withSuccess:successGetSkilleeList failure:failure];
}

-(void) getWaitingForApproval:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure
{
    [self prepareSkilleeRequest];
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@?Count=%i&Offset=%i", SKILLEEZ_URL, GET_WAITING_FOR_APPROVAL_URI, count, offset];
    [self getSkilleeResultForUrl:requestUrl withSuccess:successGetSkilleeList failure:failure];
}

-(void) getFavoriteList:(int) count offset: (int) offset success: (void (^)(NSArray *skilleeList))successGetSkilleeList failure:(void (^)(NSError *error))failure
{
    [self prepareSkilleeRequest];
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@?Count=%i&Offset=%i", SKILLEEZ_URL, GET_FAVORITE_LIST, count, offset];
    [self getSkilleeResultForUrl:requestUrl withSuccess:successGetSkilleeList failure:failure];
}

/*POST api/Skillee/AddToFavorites
POST api/Skillee/RemoveFromFavorites
POST api/Skillee/MarkAsTattle
GET api/Skillee/CanApprove
POST api/Skillee/ApproveOrDeny
POST api/Skillee/Remove*/

-(void) postSkillee:(SkilleeModel*) skillee withBehalfUserId: (NSString*) behalfUserId success: (void (^)(void))success failure:(void (^)(NSError *error))failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];

    //This is used for mapping responses, you already should have one of this. PS:[Data mapping] is a method that returns an RKObjectMapping for my model
    /*RKObjectMapping *skilleeMapping = [SkilleeModel defineObjectMapping];
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:skilleeMapping
                                                                                             method:RKRequestMethodGET
                                                                                        pathPattern:nil
                                                                                            keyPath:@"ReturnValue"
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[skilleeMapping inverseMapping] objectClass:[SkilleeModel class] rootKeyPath:@"data" method:RKRequestMethodPOST];
    [manager addRequestDescriptor:requestDescriptor];*/
    
    NSDictionary *jsonData = @{@"BehalfUserId":behalfUserId,
                               @"Title":skillee.Title,
                               @"Comment":skillee.Comment,
                               @"Media": @""
                               };
    
    /*NSString* myFilePath = @"/some/path/to/picture.gif";
    RKParams* params = [RKParams params];
    
    // Set some simple values -- just like we would with NSDictionary
    [params setValue:@"Blake" forParam:@"name"];
    [params setValue:@"blake@restkit.org" forParam:@"email"];*/
    
    [manager postObject:skillee path:[SKILLEEZ_URL stringByAppendingString:POST_CREATE_SKILLEE] parameters:jsonData
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