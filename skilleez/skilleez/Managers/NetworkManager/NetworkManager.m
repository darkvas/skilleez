//
//  SkilleezService.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "NetworkManager.h"
#import "LoginRequest.h"
#import "LoginResponce.h"

#define SKILLEEZ_URL @"http://skilleezv3.elasticbeanstalk.com/"
#define LOGIN_URI @"Account/LogOn"
#define GETUSERINFO_URI @"api/User/GetMyInfo"
#define GETSKILLEELIST_URI @"api/Skillee/GetList"

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

-(void)LoginWithUserName:(NSString *)username password:(NSString*)password {

    LoginRequest *dataObject = [[LoginRequest alloc] init];
    _username = username;
    _password = password;
    [dataObject setUsername:username];
    [dataObject setPassword:password];   
    
    NSURL *baseURL = [NSURL URLWithString:[SKILLEEZ_URL stringByAppendingString:LOGIN_URI]];
    
    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *requestMapping =  [[LoginRequest defineLoginRequestMapping] inverseMapping];
    
    [objectManager addRequestDescriptor: [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[LoginRequest class] rootKeyPath:nil]];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    RKObjectMapping *responseMapping = [LoginResponce defineLoginResponseMapping];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor
                                          responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:@"" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
                                          ]];
    
    
    [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];
    
    [objectManager postObject:dataObject path:@""
                   parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       NSLog(@"It Worked: %@", [mappingResult array]);
                       
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       NSLog(@"It Failed: %@", error);
                       
                   }];
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

    [manager getObjectsAtPath:[SKILLEEZ_URL stringByAppendingString:GETUSERINFO_URI]
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
    [manager.HTTPClient setAuthorizationHeaderWithUsername:_username password:_password];
    
    RKObjectMapping *skilleeMapping = [SkilleeModel defineObjectMapping];
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:skilleeMapping
                                                                                             method:RKRequestMethodGET
                                                                                        pathPattern:nil
                                                                                            keyPath:@"ReturnValue"
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObjectsAtPath:[NSString stringWithFormat:@"%@%@?Count=%i&Offset=%i", SKILLEEZ_URL, GETSKILLEELIST_URI, count, offset]
                         parameters:nil
                            success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         NSLog(@"success: mappings: %@", mappingResult.firstObject);
         dispatch_async(dispatch_get_main_queue(), ^{successGetSkilleeList(mappingResult.array);});
     }
                            failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         NSLog (@"failure: operation: %@ \n\nerror: %@", operaton, error);
         dispatch_async(dispatch_get_main_queue(), ^{failure(error);});
     }];
}

/*- (void)tryLoginWithURL:(NSString *)url userName:(NSString*)userName password:(NSString*)password handler:(ObjectLoaderCompletionHandler)handler {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_async(concurrentQueue, ^{
        NSString * apiUrlString = [NSString stringWithFormat:@"%@/api/IpadData/RegisterDeviceV2", url];
        NSMutableURLRequest *submitRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiUrlString]
                                                                     cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                                 timeoutInterval:120.0];
        [submitRequest setHTTPMethod:@"POST"];
        NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
        NSString * token = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken" ];
        if ([token length] >0)
        {
            [params setValue:token forKey:@"PushNotificationToken"];
        }
        char* macAddressString= (char*)malloc(18);
        [params setValue:[[NSString alloc] initWithCString:getMacAddress(macAddressString, "en0") encoding:NSMacOSRomanStringEncoding] forKey:@"IpadMAC"];
        free(macAddressString);
        
        NSData * submitData =[OBIService encodeDictionary:params];
        [submitRequest setValue:[NSString stringWithFormat:@"%d", submitData.length] forHTTPHeaderField:@"Content-Length"];
        [submitRequest setHTTPBody:submitData];
        
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", userName, password];
        //NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"admin", @"111111"];
        NSData * authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString * base64string = [authData base64EncodedString];
        NSString * authValue = [NSString stringWithFormat:@"Basic %@ ", base64string];
        
        // need to remove \n\r characters from output of this stupid base64encoder
        NSCharacterSet *allowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/= "] invertedSet];
        NSString *resultString = [[authValue componentsSeparatedByCharactersInSet:allowedChars] componentsJoinedByString:@""];
        [submitRequest addValue:resultString forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *response = nil;
        NSError * responseError = nil;
        NSData * responseData = [NSURLConnection sendSynchronousRequest:submitRequest returningResponse:&response error:&responseError];
        NSInteger responseStatusCode = [(NSHTTPURLResponse *)response statusCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        if (responseError) {
            if(handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(NO, nil, responseData, responseError);
                });
            }
        }
        else {
            if (responseStatusCode >= 500 && responseStatusCode < 600) {
                NSString * errorDescription = [NSString stringWithFormat:@"Failed with response status code %d", responseStatusCode];
                NSDictionary * userInfo = @{ NSLocalizedDescriptionKey : errorDescription };
                NSError * error = [NSError errorWithDomain:OBIServiceErrorDomain
                                                      code:responseStatusCode
                                                  userInfo:userInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(NO, nil, responseData, error);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary * userProfile = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                 options:0
                                                                                   error:nil];
                    userProfile = [[userProfile objectForKey:@"ReturnValue"] objectForKey:@"RegisterDeviceResult"];
                    handler(YES, userProfile, responseData, nil);
                });
            }
        }
    });
}*/

@end