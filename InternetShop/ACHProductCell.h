//
//  ACHProductCell.h
//  InternetShop
//
//  Created by Andrew on 12.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACHProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

- (IBAction)addToCardAction:(UIButton *)sender;

@end
