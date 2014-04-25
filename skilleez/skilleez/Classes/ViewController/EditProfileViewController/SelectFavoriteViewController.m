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
#import "SelectFavoriteCollectionViewCell.h"

enum {
    SPORT = 0,
    SUBJECT = 1,
    MUSIC = 2,
    FOOD = 3
};

@interface SelectFavoriteViewController () {
    NSArray *items, *subjects, *sport, *food, *music;
    int type;
    ProfileInfo *profileInfo;
    NSString *selectedImageName;
}

@property (weak, nonatomic) IBOutlet UILabel *whatColorLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *selectColorLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SelectFavoriteViewController

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
    sport = [NSArray arrayWithObjects: @"sport_baseball_icon.png", @"sport_basketball_icon.png", @"sport_biking_icon.png", @"sport_football_icon.png",@"sport_hokey_icon.png",@"sport_skate_icon.png",@"sport_soccer_icon.png", @"sport_swim_icon.png", nil];
    subjects = [NSArray arrayWithObjects: @"subject_art_icon.png", @"subject_band_icon.png", @"subject_history_icon.png", @"subject_math_icon.png",@"subject_pe_icon.png",@"subject_reading_icon.png",@"subject_science_icon.png", @"subject_tech_icon.png", nil];
    music = [NSArray arrayWithObjects: @"music_classical_icon.png", @"music_country_icon.png", @"music_edm_icon.png", @"music_jazz_icon.png",@"music_pop_icon.png",@"music_rap_icon.png",@"music_reg_icon.png", @"music_rock_icon.png", nil];
    food = [NSArray arrayWithObjects: @"food_blt_icon.png", @"food_burger_icon.png", @"food_icecream_icon.png", @"food_mac_icon.png",@"food_pasta_icon.png",@"food_pizza_icon.png",@"food_pop_corn_icon.png", @"food_salad_icon.png", nil];
    [self customize];
    [self.collectionView registerClass:[SelectFavoriteCollectionViewCell class] forCellWithReuseIdentifier:@"SelectFavoriteCollectionViewCell"];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    // Do any additional setup after loading the view from its nib.
    [self setTypeInfo];
    if(self.selectedImage)
        self.imageView.image = [UIImage imageNamed:self.selectedImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectFavoriteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectFavoriteCollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:[items objectAtIndex:indexPath.row]];
    [cell setImage:[UIImage imageNamed:[items objectAtIndex:indexPath.row]]];
    cell.layer.borderWidth = 1.f;
    cell.layer.borderColor = [[UIColor grayColor] CGColor];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [items count];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.imageView setImage:[UIImage imageNamed:[items objectAtIndex:indexPath.row]]];
    self.selectedImage = [items objectAtIndex:indexPath.row];
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
            [self.imageView setImage:[UIImage imageNamed:@"sport_baseball_icon.png"]];
            break;
        case SUBJECT:
            items = subjects;
            self.whatColorLbl.text = @"What is your favorite school subject?";
            self.selectColorLbl.hidden = YES;
            [self.imageView setImage:[UIImage imageNamed:@"subject_art_icon.png"]];
            break;
        case MUSIC:
            items = music;
            self.whatColorLbl.text = @"What is your favorite music style?";
            [self.imageView setImage:[UIImage imageNamed:@"music_classical_icon.png"]];
            self.selectColorLbl.hidden = YES;
            break;
        default:
            items = food;
            self.whatColorLbl.text = @"What is your favorite food?";
            [self.imageView setImage:[UIImage imageNamed:@"food_blt_icon.png"]];
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
    self.whatColorLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.selectColorLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_SMALL];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 14.f;
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView.layer.borderWidth = BORDER_WIDTH_BIG;
}

@end
