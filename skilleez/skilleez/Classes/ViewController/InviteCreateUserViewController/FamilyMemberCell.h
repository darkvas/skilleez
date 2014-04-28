//
//  FamilyMemberCell.h
//  skilleez
//
//  Created by Vasya on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyMemberModel.h"
#import "ProfileInfo.h"

@interface FamilyMemberCell : UITableViewCell

@property (nonatomic,strong) id delegate;

-(void) setMemberData: (FamilyMemberModel*) familyMember andTag:(int) rowTag;
-(void) setProfileData: (ProfileInfo*) profile andTag:(int) rowTag;

@end
