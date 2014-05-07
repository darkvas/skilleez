//
//  ProfileViewController.m
//  skilleez
//
//  Created by Roma on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ProfileViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "ColorViewController.h"
#import "UtilityController.h"
#import "TextValidator.h"

enum {
    SPORT = 0,
    SUBJECT = 1,
    MUSIC = 2,
    FOOD = 3
};

@interface ProfileViewController () {
    ProfileInfo *profile;
    float keyboardHeight;
    BOOL editMode;
}

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UIButton *userColorButton;
@property (weak, nonatomic) IBOutlet UIButton *userSportButton;
@property (weak, nonatomic) IBOutlet UIButton *userSubjectButton;
@property (weak, nonatomic) IBOutlet UIButton *userMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *userFoodButton;
@property (weak, nonatomic) IBOutlet UITextView *userDescTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *coloredView;

- (IBAction)selectColor:(id)sender;
- (IBAction)selectFavorite:(id)sender;

@end

@implementation ProfileViewController

- (id)initWithProfile:(ProfileInfo *)profileInfo editMode:(BOOL)edit
{
    if (self = [super init]) {
        profile = profileInfo;
        editMode = edit;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:profile.Login leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    if (!editMode) {
        self.userDescTextView.editable = NO;
    }
    [self.userAvatarImg setImageWithURL: profile.AvatarUrl];
    self.userColorButton.backgroundColor = profile.Color;
    self.coloredView.backgroundColor = profile.Color;
    [self.userSportButton setBackgroundImage:[profile.FavoriteSport isEqualToString:@""] || !profile.FavoriteSport ? [UIImage imageNamed:@"sport_baseball_icon.png"] : [UIImage imageNamed:profile.FavoriteSport] forState:UIControlStateNormal];
    [self.userSubjectButton setBackgroundImage:[profile.FavoriteSchoolSubject isEqualToString:@""] || !profile.FavoriteSchoolSubject ? [UIImage imageNamed:@"subject_art_icon.png"] : [UIImage imageNamed:profile.FavoriteSchoolSubject] forState:UIControlStateNormal];
    [self.userMusicButton setBackgroundImage:[profile.FavoriteTypeOfMusic isEqualToString:@""] || !profile.FavoriteTypeOfMusic ? [UIImage imageNamed:@"music_classical_icon.png"] : [UIImage imageNamed:profile.FavoriteTypeOfMusic] forState:UIControlStateNormal];
    [self.userFoodButton setBackgroundImage:[profile.FavoriteFood isEqualToString:@""] || !profile.FavoriteFood ? [UIImage imageNamed:@"food_blt_icon.png"] : [UIImage imageNamed:profile.FavoriteFood] forState:UIControlStateNormal];
    self.userDescTextView.text = (!profile.AboutMe || [profile.AboutMe isEqualToString:@""]) ? self.userDescTextView.text : profile.AboutMe;
    CGRect rect = self.userDescTextView.frame;
    CGSize textViewSize = [self.userDescTextView sizeThatFits:CGSizeMake(self.userDescTextView.frame.size.width, FLT_MAX)];
    textViewSize.height += 10;
    rect.size = textViewSize;
    self.userDescTextView.frame = rect;
    self.userDescTextView.delegate = self;
    self.scrollView.frame = CGRectMake(0, 64, 320, 504);
    self.scrollView.contentSize = CGSizeMake(320, 314 + rect.size.height);
    [self.view addSubview: self.scrollView];
    [self customize];
    [self turnEditMode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if(textView == self.userDescTextView) {
        return [TextValidator allowInputCharForText:text withRangeLength:range.length withOldLength:textView.text.length];
    }
    return YES;
}

#pragma mark - KeyboardShowHide

- (void)keyboardWillShow: (NSNotification*) notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    keyboardHeight = keyboardFrameBeginRect.size.height;
    
    if (self.scrollView.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.scrollView.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide
{
    if (self.scrollView.frame.origin.y >= 0) {
        [self setViewMovedUp:NO];
    } else if (self.scrollView.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];

    CGRect rect = self.scrollView.frame;
    if (movedUp) {
        rect.size.height -= keyboardHeight;
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + keyboardHeight) animated:YES];
    } else {
        rect.size.height += keyboardHeight;
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y - keyboardHeight) animated:NO];
    }
    self.scrollView.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark - ColorViewControllerObserver

- (void)colorSelected:(UIColor *)color
{
    self.userColorButton.backgroundColor = color;
    self.coloredView.backgroundColor = color;
    profile.Color = color;
    profile.FavoriteColor = [[UtilityController sharedInstance] getStringFromColor:color];
}

#pragma mark - FavoriteViewControllerDelegate

- (void)imageSelected:(NSString *)image withType:(int)type
{
    switch (type) {
        case SPORT:
            [self.userSportButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
            profile.FavoriteSport = image;
            break;
        case SUBJECT:
            [self.userSubjectButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
            profile.FavoriteSchoolSubject = image;
            break;
        case MUSIC:
            [self.userMusicButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
            profile.FavoriteTypeOfMusic = image;
            break;
        default:
            [self.userFoodButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
            profile.FavoriteFood = image;
            break;
    }
}

#pragma mark - Class methods

- (void)turnEditMode
{
    if (!editMode) {
        self.userDescTextView.editable = NO;
        self.userSportButton.userInteractionEnabled = NO;
        self.userColorButton.userInteractionEnabled = NO;
        self.userFoodButton.userInteractionEnabled = NO;
        self.userMusicButton.userInteractionEnabled = NO;
        self.userSubjectButton.userInteractionEnabled = NO;
    }
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    profile.AboutMe = self.userDescTextView.text;
    [self.delegate profileChanged:profile];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customize
{
    self.userDescTextView.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.userDescTextView.textColor = [UIColor whiteColor];
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = BORDER_WIDTH_SMALL;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userColorButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userColorButton.layer.masksToBounds = YES;
    self.userColorButton.layer.borderWidth = BORDER_WIDTH_SMALL;
    self.userColorButton.layer.cornerRadius = BUTTON_CORNER_RADIUS_MEDIUM;
    self.userSportButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userSportButton.layer.masksToBounds = YES;
    self.userSportButton.layer.borderWidth = BORDER_WIDTH_SMALL;
    self.userSportButton.layer.cornerRadius = BUTTON_CORNER_RADIUS_MEDIUM;
    self.userMusicButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userMusicButton.layer.masksToBounds = YES;
    self.userMusicButton.layer.borderWidth = BORDER_WIDTH_SMALL;
    self.userMusicButton.layer.cornerRadius = BUTTON_CORNER_RADIUS_MEDIUM;
    self.userSubjectButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userSubjectButton.layer.masksToBounds = YES;
    self.userSubjectButton.layer.borderWidth = BORDER_WIDTH_SMALL;
    self.userSubjectButton.layer.cornerRadius = BUTTON_CORNER_RADIUS_MEDIUM;
    self.userFoodButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userFoodButton.layer.masksToBounds = YES;
    self.userFoodButton.layer.borderWidth = BORDER_WIDTH_SMALL;
    self.userFoodButton.layer.cornerRadius = BUTTON_CORNER_RADIUS_MEDIUM;
}

- (IBAction)selectColor:(id)sender {
    ColorViewController *color = [[ColorViewController alloc] initWithProfile:profile];
    color.delegate = self;
    [self.navigationController pushViewController:color animated:YES];
}

- (IBAction)selectFavorite:(id)sender {
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType: ((UIButton *)sender).tag - 1 andProfile:profile];
    favorite.delegate = self;
    [self.navigationController pushViewController:favorite animated:YES];
}

@end
