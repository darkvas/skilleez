//
//  ColorViewController.m
//  skilleez
//
//  Created by Roma on 3/28/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ColorViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"

@interface ColorViewController () {
    NSArray *colors;
}
@property (weak, nonatomic) IBOutlet UILabel *whatColorLbl;
@property (weak, nonatomic) IBOutlet UIView *colorImg;
@property (weak, nonatomic) IBOutlet UILabel *selectColorLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ColorViewController

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
    colors = [NSArray arrayWithObjects:   [UIColor colorWithRed:0.99 green:0.43 blue:0.55 alpha:1.0],
                                          [UIColor colorWithRed:0.99 green:0.66 blue:0.18 alpha:1.0],
                                          [UIColor colorWithRed:0.99 green:0.77 blue:0.45 alpha:1.0],
                                          [UIColor colorWithRed:1.0 green:0.92 blue:0.69 alpha:1.0],
                                          [UIColor colorWithRed:0.98 green:0.97 blue:0.35 alpha:1.0],
                                          [UIColor colorWithRed:0.83 green:1.0 blue:0.03 alpha:1.0],
                                          [UIColor colorWithRed:0.64 green:0.91 blue:0.13 alpha:1.0],
                                          [UIColor colorWithRed:0.35 green:0.9 blue:0.58 alpha:1.0],
                                          [UIColor colorWithRed:0.17 green:1.0 blue:0.87 alpha:1.0],
                                          [UIColor colorWithRed:0.46 green:0.6 blue:1.0 alpha:1.0],
                                          [UIColor colorWithRed:0.46 green:0.0 blue:1.0 alpha:1.0],
                                          [UIColor colorWithRed:0.67 green:0.21 blue:0.99 alpha:1.0],
                                          [UIColor colorWithRed:0.81 green:0.0 blue:1.0 alpha:1.0],
                                          [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0],
                                          [UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1.0],
                                          nil];
    [self customize];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    // Do any additional setup after loading the view from its nib.
    
    if(self.selectedColor)
        self.colorImg.backgroundColor = self.selectedColor;
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
    [cell setBackgroundColor:[colors objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [colors count];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.colorImg.backgroundColor = [colors objectAtIndex:indexPath.row];
    self.selectedColor = self.colorImg.backgroundColor;
     NSLog(@"selected color: %@", self.selectedColor);
}

#pragma mark - Class methods

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    NSLog(@"selected color: %@", self.selectedColor);
    [self.delegate colorSelected:self.selectedColor];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customize
{
    self.whatColorLbl.font = [UIFont getDKCrayonFontWithSize:26.f];
    self.selectColorLbl.font = [UIFont getDKCrayonFontWithSize:18.f];
    self.colorImg.layer.masksToBounds = YES;
    self.colorImg.layer.cornerRadius = 14.f;
    self.colorImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.colorImg.layer.borderWidth = 5.f;
}

@end
