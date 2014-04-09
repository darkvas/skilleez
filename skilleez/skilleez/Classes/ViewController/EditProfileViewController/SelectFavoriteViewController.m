//
//  ColorViewController.m
//  skilleez
//
//  Created by Roma on 3/28/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SelectFavoriteViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "ProfileInfo.h"

@interface SelectFavoriteViewController () {
    NSArray *items, *subjects, *sport, *food, *music;
    int type;
    ProfileInfo *profileInfo;
}

@property (weak, nonatomic) IBOutlet UILabel *whatColorLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *selectColorLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SelectFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(int)favoriteType
{
    if (self = [super init]) {
        type = favoriteType;
    }
    return self;
}

- (id)initWithType:(int)favoriteType andProfile:(ProfileInfo *)profile
{
    if (self = [super init]) {
        type = favoriteType;
        profileInfo = profile;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sport = [NSArray arrayWithObjects: @"http://www.nasa.gov/images/content/711375main_grail20121205_4x3_946-710.jpg", @"http://www.nasa.gov/images/content/711375main_grail20121205_4x3_946-710.jpg", @"http://www.nasa.gov/images/content/711375main_grail20121205_4x3_946-710.jpg", @"http://www.spacetoday.org/Occurrences//images/Moon/ASU_LRO_Moon_map_279x279.jpg", @"http://www.spacetoday.org/Occurrences//images/Moon/ASU_LRO_Moon_map_279x279.jpg", @"http://www.spacetoday.org/Occurrences//images/Moon/ASU_LRO_Moon_map_279x279.jpg", @"http://mcgovern.mit.edu/news/wp-content/uploads/2013/08/image7LR.jpg", @"http://mcgovern.mit.edu/news/wp-content/uploads/2013/08/image7LR.jpg", @"http://mcgovern.mit.edu/news/wp-content/uploads/2013/08/image7LR.jpg", @"profile_icon.png", @"plane_img.png", @"profile_icon.png", @"rocket_BTN.png", @"profile_icon.png", @"rocket_BTN.png", nil];
    [self customize];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    // Do any additional setup after loading the view from its nib.
    [self setTypeInfo];
    if(self.selectedImage)
        self.imageView.image = self.selectedImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UICollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.layer.borderWidth = 1.f;
    cell.layer.borderColor = [[UIColor grayColor] CGColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    [imageView setImageWithURL:[NSURL URLWithString:[items objectAtIndex:indexPath.row]]];
    [cell addSubview:imageView];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [items count];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.imageView setImageWithURL:[NSURL URLWithString:[items objectAtIndex:indexPath.row]]];
    self.selectedImage = self.imageView.image;
     NSLog(@"selected color: %@", self.selectedImage);
}

#pragma mark - Class methods

- (void)setTypeInfo
{
    switch (type) {
        case SPORT:
            items = sport;
            self.whatColorLbl.text = @"What is your favorite sport?";
            self.selectColorLbl.hidden = YES;
            break;
        case SUBJECT:
            items = subjects;
            self.whatColorLbl.text = @"What is your favorite school subject?";
            self.selectColorLbl.hidden = YES;
            break;
        case MUSIC:
            items = music;
            self.whatColorLbl.text = @"What is your favorite music style?";
            self.selectColorLbl.hidden = YES;
            break;
        default:
            items = food;
            self.whatColorLbl.text = @"What is your favorite food?";
            self.selectColorLbl.hidden = YES;
            break;
    }
    [self.collectionView reloadData];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    NSLog(@"selected color: %@", self.selectedImage);
    [self.delegate imageSelected:self.selectedImage withType:type];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customize
{
    self.whatColorLbl.font = [UIFont getDKCrayonFontWithSize:22.f];
    self.selectColorLbl.font = [UIFont getDKCrayonFontWithSize:18.f];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 14.f;
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView.layer.borderWidth = 5.f;
}

@end
