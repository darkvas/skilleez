//
//  AdultPermission.h
//  skilleez
//
//  Created by Vasya on 4/2/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdultPermission : NSObject

@property (nonatomic, strong) NSString* Id;
@property (nonatomic, strong) NSString* AdultId;
@property (nonatomic, strong) NSString* ChildId;
@property (nonatomic, strong) NSString* ChildName;
@property (nonatomic, strong) NSString* ChildAvatarUrl;
@property (nonatomic) BOOL ChangesApproval;
@property (nonatomic) BOOL LoopApproval;
@property (nonatomic) BOOL ProfileApproval;
@property (nonatomic, strong) NSString* MainFamilyUserId;

+(RKObjectMapping*) defineObjectMapping;

@end
