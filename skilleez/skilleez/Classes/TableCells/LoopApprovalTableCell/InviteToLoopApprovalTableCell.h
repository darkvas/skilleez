//
//  InviteToLoopApprovalTableCell.h
//  skilleez
//
//  Created by Roma on 4/12/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopInvitationModel.h"
#import "SimpleTableCell.h"

@protocol InviteToLoopDelegate <NSObject>

- (void)didViewProfile:(NSInteger)index;

@end

@interface InviteToLoopApprovalTableCell : UITableViewCell

@property (nonatomic,strong) id delegate;

- (void)fillCell:(LoopInvitationModel *)invitation forAdultOfInvitor:(BOOL)isInvitor andTag:(NSInteger)tag;

@end
