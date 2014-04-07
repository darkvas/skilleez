//
//  SkilleeModel.m
//  skilleez
//
//  Created by Vasya on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SkilleeModel.h"

@implementation SkilleeModel

-(UIColor*) getColor
{
    int rgbValue = [self.UserColor intValue];
    uint value;
    [[NSScanner scannerWithString: self.UserColor] scanHexInt: &value];
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                                                       green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                                                        blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (RKObjectMapping*)defineObjectMapping {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SkilleeModel class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"Id": @"Id",
                                                   @"UserId": @"UserId",
                                                   @"UserName": @"UserName",
                                                   @"UserAvatarUrl": @"UserAvatarUrl",
                                                   @"UserColor": @"UserColor",
                                                   @"PostedDate": @"PostedDate",
                                                   @"MediaUrl": @"MediaUrl",
                                                   @"MediaThumbnailUrl": @"MediaThumbnailUrl",
                                                   @"Title": @"Title",
                                                   @"Comment": @"Comment"}];
    return mapping;
}

- (BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    if (![object isKindOfClass:self.class])
        return NO;
    SkilleeModel *model = (SkilleeModel *)object;
    if (![model.Id isEqualToString:self.Id])
        return NO;
    else if (![model.UserId isEqualToString:self.UserId])
        return NO;
    else if (![model.UserName isEqualToString:self.UserName])
        return NO;
    else if (![model.UserAvatarUrl isEqual:self.UserAvatarUrl])
        return NO;
    else if (![model.UserColor isEqualToString:self.UserColor])
        return NO;
    else if (![model.PostedDate isEqualToDate:self.PostedDate])
        return NO;
    else if (![model.MediaUrl isEqual:self.MediaUrl])
        return NO;
    else if (![model.MediaThumbnailUrl isEqual:self.MediaThumbnailUrl])
        return NO;
    else if (![model.Title isEqualToString:self.Title])
        return NO;
    else if (![model.Comment isEqualToString:self.Comment])
        return NO;
    else
        return YES;
}

@end
