//
//  LoopInvitationModel.h
//  skilleez
//
//  Created by Hedgehog on 22.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileInfo.h"
#import "InvitorModel.h"
#import "InviteeModel.h"

@interface LoopInvitationModel : NSObject

@property (nonatomic, strong) NSString *InvitationId;
@property (nonatomic, strong) InvitorModel *Invitor;
@property (nonatomic, strong) InviteeModel *Invitee;

+ (RKObjectMapping *)defineObjectMapping;

@end
