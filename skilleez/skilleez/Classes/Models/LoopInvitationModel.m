//
//  LoopInvitationModel.m
//  skilleez
//
//  Created by Hedgehog on 22.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoopInvitationModel.h"

@implementation LoopInvitationModel

+ (RKObjectMapping *)defineObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[LoopInvitationModel class]];
    [mapping addAttributeMappingsFromDictionary:@{ @"InvitationId": @"InvitationId"}];
    return mapping;
}

@end
