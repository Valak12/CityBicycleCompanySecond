//
//  AccessoriesViewController.m
//  CityBicycleCompany
//
//  Created by Vala Kohnechi on 11/26/14.
//  Copyright (c) 2014 MVA. All rights reserved.
//

#import "AccessoriesViewController.h"
#import <Parse/Parse.h>
#import "AccessoryCollectionViewCell.h"
#import "ChosenAccessory.h"
#import "Photo.h"
#import "Accessory.h"
#import "ShoppingCartViewController.h"
#import "Cart.h"
@interface AccessoriesViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *colorSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property ChosenAccessory *localChosenAccessory;
@property NSMutableArray *accessoryImageArray;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property NSMutableArray *addToCartArray;
@end

@implementation AccessoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.localChosenAccessory = [[ChosenAccessory alloc]init];
    self.accessoryImageArray = [@[]mutableCopy];
    self.addToCartArray = [@[]mutableCopy];
   
    [self updateUserInterfaceWithOurAccessoryFromParse];
    [self queryImages];
    [self.quantityTextField setDelegate:self];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.widthConstraint.constant = self.scrollView.frame.size.width;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(self.scrollView.frame.size.width, self.collectionView.frame.size.height);
}
- (IBAction)onDIsmissButtonTapped:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateUserInterfaceWithOurAccessoryFromParse
{
    self.nameLabel.text = self.accessoryFromParse.name;
    self.descriptionLabel.text = self.accessoryFromParse.accessoryDescription;
    [self.sizeSegmentedControl removeAllSegments];
    [self.colorSegmentedControl removeAllSegments];

    
    for (NSString *size in self.accessoryFromParse.size )
    {
        
        [self.sizeSegmentedControl insertSegmentWithTitle:size atIndex:self.sizeSegmentedControl.numberOfSegments animated:YES];
    }
    if (self.sizeSegmentedControl.numberOfSegments == 0)
    {
        [self.sizeSegmentedControl removeAllSegments];
        self.sizeSegmentedControl.hidden = YES;
        self.sizeLabel.hidden = YES;
        
    }
    for (NSString *color in self.accessoryFromParse.color)
    {
        [self.colorSegmentedControl insertSegmentWithTitle:color atIndex:self.colorSegmentedControl.numberOfSegments animated:YES];
    }
    if (self.colorSegmentedControl.numberOfSegments == 0)
    {
        [self.colorSegmentedControl removeAllSegments];
        self.colorSegmentedControl.hidden = YES;
        self.colorLabel.hidden = YES;
    }
}


- (void)queryImages
{
    PFQuery *queryImages = [Photo query];
    [queryImages whereKey:@"accessory" equalTo:self.accessoryFromParse];
    [queryImages findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (Photo *photo in objects) {
                [self.accessoryImageArray addObject:photo.productPhoto];
            }
            
            [self.collectionView reloadData];
            self.pageControl.numberOfPages = self.accessoryImageArray.count;
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
    
}
- (IBAction)onAddToCartPressed:(id)sender
{
    self.localChosenAccessory.chosenName = self.accessoryFromParse.name;

    if (self.sizeSegmentedControl.selectedSegmentIndex == -1 && self.sizeSegmentedControl.hidden == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"City Bicycle Company"
                                                        message:@"Please select a size"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }else
    {
        self.localChosenAccessory.chosenSize = self.accessoryFromParse.size[self.sizeSegmentedControl.selectedSegmentIndex];
    }
    
    
    if (self.colorSegmentedControl.selectedSegmentIndex == -1 && self.colorSegmentedControl.hidden == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"City Bicycle Company"
                                                        message:@"Please select a color"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }else
    {
        self.localChosenAccessory.color = self.accessoryFromParse.color[self.colorSegmentedControl.selectedSegmentIndex];
    }
    
    if (![self.quantityTextField.text isEqualToString:@""])
    {
        NSNumberFormatter *quantityConversion = [[NSNumberFormatter alloc]init];
        [quantityConversion setNumberStyle:NSNumberFormatterNoStyle];
        NSNumber *myNumber = [quantityConversion numberFromString:self.quantityTextField.text];
        self.localChosenAccessory.chosenQuantity = myNumber;
        [self.quantityTextField resignFirstResponder];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"City Bicycle Company"
                                                        message:@"Please enter a quantity"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.localChosenAccessory.chosenPrice = self.accessoryFromParse.originalPrice;
    
    [self.addToCartArray addObject:self.localChosenAccessory];
    
//    Cart *cart = [Cart new];
//    [cartArray addItemToCart:self.localChosenAccessory];
    
    Cart *singleton = [Cart sharedManager];
    [singleton addItemToCart:self.localChosenAccessory];
    [singleton save];
    
//
//    Cart *mySingleton = [Cart sharedManager];
//    mySingleton.cartArray = self.addToCartArray;
    

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AccessoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"accessoryCell" forIndexPath:indexPath];
    PFFile *file = self.accessoryImageArray[indexPath.row];
    
    if (!file.isDataAvailable)
    {
        cell.accessoryImageView.alpha = 0;
    }
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.accessoryImageView.image = [UIImage imageWithData:data];
        [UIView animateWithDuration:.2 animations:^{
            cell.accessoryImageView.alpha = 1;
        }];
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.accessoryImageArray.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageNumber = roundf( self.collectionView.contentOffset.x/self.collectionView.frame.size.width );
    self.pageControl.currentPage = pageNumber;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.quantityTextField resignFirstResponder];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"accessoryToCartSegue"])
    {
        ShoppingCartViewController *vc = segue.destinationViewController;
        ChosenAccessory *chosenAccessory = [[ChosenAccessory alloc]init];
        chosenAccessory.passTheAccessoryArray = self.addToCartArray;
        vc.theChosenAccessory = chosenAccessory;
        
    }
    
    
}



@end
