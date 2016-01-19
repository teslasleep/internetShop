//
//  ACHDetailedInformationViewController.m
//  InternetShop
//
//  Created by Andrew on 12.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import "ACHDetailedInformationViewController.h"
#import "ACHProductInfoDataSource.h"

@interface  ACHDetailedInformationViewController()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ACHDetailedInformationViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    [self updateFields];
}

#pragma mark - *** Other ***

- (void)updateFields {
    if (self.item != nil) {
            self.nameLabel.text = [self.item name];
            self.typeLabel.text = [self.item type];
            self.priceLabel.text = [NSString stringWithFormat:@"%1.2f", [self.item price]];
    } else {
        self.nameLabel.text = @"Name";
        self.typeLabel.text = @"Type";
        self.priceLabel.text = @"Price";
    }
}

@end
