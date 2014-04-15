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
#import "SelectFavoriteViewController.h"

#define CORNER_RADIUS 5.f
#define BORDER_WIDTH 2.f

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    //TODO:change on real data in future
    [self.userSportButton setBackgroundImage:[UIImage imageNamed:@"sport_baseball_icon.png"] forState:UIControlStateNormal];
    [self.userSubjectButton setBackgroundImage:[UIImage imageNamed:@"subject_art_icon.png"] forState:UIControlStateNormal];
    [self.userMusicButton setBackgroundImage:[UIImage imageNamed:@"music_classical_icon.png"] forState:UIControlStateNormal];
    [self.userFoodButton setBackgroundImage:[UIImage imageNamed:@"food_blt_icon.png"] forState:UIControlStateNormal];
    self.userDescTextView.text = profile.AboutMe == nil ? self.userDescTextView.text : profile.AboutMe;
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
	// Do any additional setup after loading the view.216
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
}

#pragma mark - FavoriteViewControllerDelegate

- (void)imageSelected:(UIImage *)image withType:(int)type
{
    switch (type) {
        case SPORT:
            [self.userSportButton setBackgroundImage:image forState:UIControlStateNormal];
            break;
        case SUBJECT:
            [self.userSubjectButton setBackgroundImage:image forState:UIControlStateNormal];
            break;
        case MUSIC:
            [self.userMusicButton setBackgroundImage:image forState:UIControlStateNormal];
            break;
        default:
            [self.userFoodButton setBackgroundImage:image forState:UIControlStateNormal];
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
}

- (void)customize
{
    self.userDescTextView.font = [UIFont getDKCrayonFontWithSize:21.f];
    self.userDescTextView.textColor = [UIColor whiteColor];
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = 5.f;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userColorButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userColorButton.layer.masksToBounds = YES;
    self.userColorButton.layer.borderWidth = BORDER_WIDTH;
    self.userColorButton.layer.cornerRadius = CORNER_RADIUS;
    self.userSportButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userSportButton.layer.masksToBounds = YES;
    self.userSportButton.layer.borderWidth = BORDER_WIDTH;
    self.userSportButton.layer.cornerRadius = CORNER_RADIUS;
    self.userMusicButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userMusicButton.layer.masksToBounds = YES;
    self.userMusicButton.layer.borderWidth = BORDER_WIDTH;
    self.userMusicButton.layer.cornerRadius = CORNER_RADIUS;
    self.userSubjectButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userSubjectButton.layer.masksToBounds = YES;
    self.userSubjectButton.layer.borderWidth = BORDER_WIDTH;
    self.userSubjectButton.layer.cornerRadius = CORNER_RADIUS;
    self.userFoodButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userFoodButton.layer.masksToBounds = YES;
    self.userFoodButton.layer.borderWidth = BORDER_WIDTH;
    self.userFoodButton.layer.cornerRadius = CORNER_RADIUS;
}

- (UIImage *)getBlankImage:(UIColor *)color
{
    const int defaultSize = 100;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(defaultSize,defaultSize), NO, 0);
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,defaultSize,defaultSize)];
    [color setFill];
    [bezierPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
