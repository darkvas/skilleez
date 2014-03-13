//
//  SkilleezService.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "NetworkManager.h"

#define skilleezUrl @"http://skilleezv3.elasticbeanstalk.com/"
#define loginUri @"/Account/LogOn"

@implementation NetworkManager

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
        [RKObjectManager sharedManager].HTTPClient;
       // observerCollection = [[NSMutableSet alloc] init];
    }
    return self;
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