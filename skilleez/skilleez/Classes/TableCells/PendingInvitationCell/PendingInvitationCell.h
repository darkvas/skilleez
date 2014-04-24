//
//  PendingInvitationCell.h
//  skilleez
//
//  Created by Vasya on 4/23/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopInvitationModel.h"

@interface PendingInvitationCell : UITableViewCell

@property (nonatomic, readonly, strong) LoopInvitationModel *invitation;

- (void)fillCell:(PendingInvitationCell*) aCell withInvitation:(LoopInvitationModel*) anInvitation;

@end
