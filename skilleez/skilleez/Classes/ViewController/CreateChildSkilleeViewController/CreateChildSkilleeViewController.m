//
//  CreateChildSkilleeViewController.m
//  skilleez
//
//  Created by Roma on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "CreateChildSkilleeViewController.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"

@interface CreateChildSkilleeViewController (){
    UIImagePickerController *imagePicker;
    NSData* chosenData;
    enum mediaType dataMediaType;
}

@property (weak, nonatomic) IBOutlet UILabel *createSkilleeLbl;
@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
@property (weak, nonatomic) IBOutlet UITextView *commentTxt;
@property (weak, nonatomic) IBOutlet UILabel *addMediaLbl;
@property (weak, nonatomic) IBOutlet UIButton *launchBtn;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;
@property (weak, nonatomic) IBOutlet UITextField *postOnTxt;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCon;

- (IBAction)launchSkillee:(id)sender;
- (IBAction)pickImage:(id)sender;
- (IBAction)pickVideo:(id)sender;

@end

@implementation CreateChildSkilleeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleTxt.delegate = self;
    //self.heightCon.constant = 506;
    self.commentTxt.delegate = self;
    [self setDefaultFonts];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"big_text_view_BG.png"]];
    imgView.frame = CGRectMake(0, 0, 295, 128);
    [self.commentTxt addSubview: imgView];
    UILabel *placeholder = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 195, 36)];
    placeholder.textColor = [UIColor colorWithRed:0.09 green:0.09 blue:0.12 alpha:1.0];
    [placeholder setFont:[UIFont getDKCrayonFontWithSize:22]];
    placeholder.text = @"Enter Comments here";
    [self.commentTxt addSubview:placeholder];
    [self.commentTxt sendSubviewToBack: imgView];
    [self.commentTxt sendSubviewToBack:placeholder];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.titleTxt)
    {
        [self.commentTxt becomeFirstResponder];
    }
    return YES;
}*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSString* contentType = info[UIImagePickerControllerMediaType];
    if([contentType isEqualToString:@"public.image"]) {
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        chosenData = UIImageJPEGRepresentation(chosenImage, 1.0f);
        dataMediaType = mediaTypeImage;
    } else if([contentType isEqualToString:@"public.movie"]){
        NSString* filePath = info[@"UIImagePickerControllerMediaURL"];
        chosenData = [[NSData alloc] initWithContentsOfFile:filePath];
        dataMediaType = mediaTypeVideo;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.commentTxt.text.length == 0)
    {
        for (UIView *lbl in self.commentTxt.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)lbl;
                label.text = @"Enter Comments here";
            }
        }
    } else if(self.commentTxt.text.length > 0) {
        for (UIView *lbl in self.commentTxt.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)lbl;
                label.text = @"";
            }
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.commentTxt.text isEqualToString:@""])
    {
        for (UIView *lbl in self.commentTxt.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)lbl;
                label.text = @"Enter Comments here";
            }
        } ;
    }
}

- (void)setDefaultFonts
{
    [self.createSkilleeLbl setFont:[UIFont getDKCrayonFontWithSize:31]];
    [self.titleTxt setFont:[UIFont getDKCrayonFontWithSize:22]];
    [self.commentTxt setFont:[UIFont getDKCrayonFontWithSize:22]];
    [self.postOnTxt setFont:[UIFont getDKCrayonFontWithSize:22]];
    [self.addMediaLbl setFont:[UIFont getDKCrayonFontWithSize:18]];
    [self.launchBtn setFont:[UIFont getDKCrayonFontWithSize:31]];
    [self.termsBtn setFont:[UIFont getDKCrayonFontWithSize:16]];
}

- (IBAction)launchSkillee:(id)sender {
    SkilleeRequest* skilleeRequest = [SkilleeRequest new];
    skilleeRequest.Title = self.titleTxt.text;
    skilleeRequest.Comment = self.commentTxt.text;
    skilleeRequest.BehalfUserId = self.postOnTxt.text;
    skilleeRequest.Media = chosenData;
    skilleeRequest.MediaType = dataMediaType;
    
    [[NetworkManager sharedInstance] postCreateSkillee:skilleeRequest success:^{
        NSLog(@"Done");
    } failure:^(NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Launch failed" message:@"Launch skillee failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }];
}

- (IBAction)pickImage:(id)sender {
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString*) kUTTypeImage];
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)pickVideo:(id)sender {
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    [self presentModalViewController:imagePicker animated:YES];
}
@end