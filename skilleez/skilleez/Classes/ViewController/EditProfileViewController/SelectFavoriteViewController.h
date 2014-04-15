//
//  ColorViewController.h
//  skilleez
//
//  Created by Roma on 3/28/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileInfo.h"

/*extern const NSInteger SPORT;
extern const NSInteger SUBJECT;
extern const NSInteger MUSIC;
extern const NSInteger FOOD;*/

@protocol FavoriteViewControllerDelegate <NSObject>

- (void)imageSelected:(UIImage *)image withType:(int)type;

@end

@interface SelectFavoriteViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

- (id)initWithType:(int)favoriteType;
- (id)initWithType:(int)favoriteType andProfile:(ProfileInfo *)profile;

@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) id<FavoriteViewControllerDelegate> delegate;

@end
