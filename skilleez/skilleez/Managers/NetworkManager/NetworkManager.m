//
//  SkilleezService.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "NetworkManager.h"
#import "PostResponse.h"

#define SKILLEEZ_URL @"http://skilleezv3.elasticbeanstalk.com/"
#define LOGIN_URI @"Account/LogOn"
#define GET_USERINFO_URI @"api/User/GetMyInfo"
#define GET_SKILLEE_LIST_URI @"api/Skillee/GetList"
#define GET_USER_SKILLEE_LIST_URI @"api/Skillee/GetUserSkilleezList"
#define GET_WAITING_FOR_APPROVAL_URI @"api/Skillee/GetWaitingForApprovalList"
#define GET_FAVORITE_LIST @"api/Skillee/GetFavoriteList"

#define POST_CREATE_SKILLEE @"api/Skillee/CreateSkilleez"
#define POST_REMOVE @"api/Skillee/Remove"
#define POST_ADD_TO_FAVORITES @"api/Skillee/AddToFavorites"
#define POST_REMOVE_FROM_FAVORITES @"api/Skillee/RemoveFromFavorites"
#define POST_MARK_AS_TATTLE @"api/Skillee/MarkAsTattle"
#define POST_APPROVE_OR_DENY @"api/Skillee/ApproveOrDeny"

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

/*
POST api/Skillee/MarkAsTattle
GET api/Skillee/CanApprove
POST api/Skillee/ApproveOrDeny
POST api/Skillee/Remove*/

-(void) postCreateSkillee:(SkilleeRequest*) skilleeRequest success: (void (^)(void))success failure:(void (^)(NSError *error))failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];

    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
    /*RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[[SkilleeRequest defineObjectMapping] inverseMapping]
                                                                                   objectClass:[SkilleeRequest class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    [manager addRequestDescriptor:requestDescriptor];*/
    
    /*NSDictionary *jsonData = @{@"BehalfUserId":skilleeRequest.BehalfUserId,
                               @"Title":skilleeRequest.Title,
                               @"Comment":skilleeRequest.Comment,
                               @"Media": @""
                               };
    */
    
    NSMutableURLRequest *request = [manager multipartFormRequestWithObject:skilleeRequest
                                     method:RKRequestMethodPOST
                                       path:[SKILLEEZ_URL stringByAppendingString:POST_CREATE_SKILLEE]
                                 parameters:nil
                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                      [formData
                       appendPartWithFileData:skilleeRequest.Media
                       name:@"Media"
                       fileName:@"BG_loading_img.png"
                       mimeType:@"image/png"];
                  }];
    
    //[manager setRequestSerializationMIMEType:RKMIMETypeJSON];
    //[manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];

    [request setValue:@"multipart/form-data; boundary=----WebKitFormBoundarynIA8MxGIz6YCfuIx" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
                                                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                 NSLog(@"Success");
                                                                             }
                                                                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                 NSLog(@"Failed");
                                                                             }];
    
    [manager enqueueObjectRequestOperation:operation];

    
    /*[manager postObject:skilleeRequest path:[SKILLEEZ_URL stringByAppendingString:POST_CREATE_SKILLEE] parameters:nil
                success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
    {
        dispatch_async(dispatch_get_main_queue(), ^{success();});
    }
                failure:^(RKObjectRequestOperation * operaton, NSError * error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
    }];*/
}

/*- (void)denyAccessToItemWithPath:(NSString *)aPath
              forUsersWithEmails:(NSSet *)aEmails
                    rightsToDeny:(NSSet *)aRights
{
    
    NSString *emails = [[aEmails allObjects] componentsJoinedByString:@";"];
    NSString *rights = [[aRights allObjects] componentsJoinedByString:@";"];
    
    
    
    NSDictionary *jsonData = @{@"emails":emails,
                               @"path":aPath,
                               @"rights":rights,
                               @"fileId": @""
                               };
    
    NSString *serviceCallName = [NSString stringWithFormat:@"%@/deny", [NBSession sharedSession].accessToken];
    
    AFHTTPClient *client = [RKObjectManager sharedManager].HTTPClient;
    [client postPath:serviceCallName parameters:jsonData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(restClient:didDenyAccessToItemWithPath:)]) {
            [self.delegate restClient:self didDenyAccessToItemWithPath:aPath];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorTimedOut)
        {
            [self connectionProblem];
        }else{
            if ([self.delegate respondsToSelector:@selector(restClient:didFailDenyAccessToItemWithPath:error:)]) {
                [self.delegate restClient:self didFailDenyAccessToItemWithPath:aPath error:error];
            }
        }
    }];
}*/

/*-(void)postObjects:(id)object path:(NSString *)path handler:(ObjectLoaderCompletionHandler)handler
{
    NSMutableURLRequest * request = [[RKObjectManager sharedManager] requestWithObject:[ServiceResponse new]
                                                                                method:RKRequestMethodPOST
                                                                                  path:path parameters:nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    CJSONSerializer *serializer = [CJSONSerializer serializer];
    NSError * error = nil;
    NSData *data  = [serializer serializeDictionary:object error:&error];
    if(!error) {
        [request setHTTPBody:data];
    }
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    
    RKObjectRequestOperation * operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request
                                                                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                                          if(handler) {
                                                                                                              ServiceResponse * response = (ServiceResponse*)[mappingResult firstObject];
                                                                                                              id responseToHandle;
                                                                                                              if (response.resultCode != 0) {
                                                                                                                  responseToHandle = response;
                                                                                                              }
                                                                                                              else // else - return returnedValue
                                                                                                              {
                                                                                                                  responseToHandle = response.returnedValue;
                                                                                                              }
                                                                                                              handler(YES, responseToHandle, operation.HTTPRequestOperation.responseData, nil);
                                                                                                          }
                                                                                                      }
                                                                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                                          NSLog(@"%@", operation.HTTPRequestOperation.responseString);
                                                                                                          NSLog(@"%@", error);
                                                                                                          if(handler) {
                                                                                                              NSData * responseData = operation.HTTPRequestOperation.responseData;
                                                                                                              handler(NO, nil, responseData, error);
                                                                                                          }
                                                                                                      }];
    [[RKObjectManager sharedManager].operationQueue addOperation:operation];
}*/

-(void) postAddToFavorites:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
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

-(void) postRemoveFromFavorites:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
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

-(void) postMarkAsTatle:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
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

-(void) postRemoveSkillee:(NSString*) skilleeId success: (void (^)(void))success failure:(void (^)(NSError *error))failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
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

//need check and test
-(void) postApproveSkillee:(NSString*) skilleeId isApproved:(BOOL)approved success: (void (^)(void))success failure:(void (^)(NSError *error))failure
{
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[PostResponse defineObjectMapping]
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
    NSDictionary *jsonData = @{
        @"SkilleeID": skilleeId,
        @"IsApproved": @(approved),
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

@end