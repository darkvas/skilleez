//
//  MessageCell.h
//  skilleez
//
//  Created by Vasya on 4/10/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileInfo.h"

@interface MessageCell : UITableViewCell

@property (nonatomic,strong) id delegate;

-(void) setMessageData: (ProfileInfo*) familyMember andTag:(int) rowTag;

@end
