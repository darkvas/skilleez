//
//  SendMessageViewController.m
//  skilleez
//
//  Created by Vasya on 4/9/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SendMessageViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "ActivityIndicatorController.h"

#define MESSAGE_MAXLENGTH 200

@interface SendMessageViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tfMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UILabel *lblSymbolsCount;

-(IBAction)sendMessagePressed:(id)sender;

@end

@implementation SendMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Message" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    
    [self customizeElements];
}

- (void)customizeElements
{
    self.tfMessage.delegate = self;
    [self.tfMessage.layer setCornerRadius:5.0f];
    [self.btnSendMessage.layer setCornerRadius:5.0f];
    
    [self.tfMessage setFont:[UIFont getDKCrayonFontWithSize:24.0f]];
    [self.btnSendMessage.titleLabel setFont:[UIFont getDKCrayonFontWithSize:30.0f]];
    [self.lblSymbolsCount setFont:[UIFont getDKCrayonFontWithSize:18.0f]];
    [self.lblTip setFont:[UIFont getDKCrayonFontWithSize:18.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
}

-(IBAction)sendMessagePressed:(id)sender
{
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.lblSymbolsCount.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)textView.text.length];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    if (newLength <= MESSAGE_MAXLENGTH) {
        return YES;
    } else {
        NSUInteger emptySpace = MESSAGE_MAXLENGTH - (textView.text.length - range.length);
        textView.text = [[[textView.text substringToIndex:range.location]
                          stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        return NO;
    }
}

@end
