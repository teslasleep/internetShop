//
//  ACHShopViewController.m
//  InternetShop
//
//  Created by Andrew on 12.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import "ACHShopViewController.h"

#import "ACHDetailedInformationViewController.h"
#import "ACHCartManager.h"
#import "ACHProductCell.h"
#import "ACHProductManager.h"
#import "ACHProductInfoDataSource.h"

@interface ACHShopViewController ()

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) ACHProductManager *manager;
@property (strong, nonatomic) ACHCartManager *cart;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ACHShopViewController

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(productsDidChanged:)
                                                     name:ProductManagerProductsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTableContent];
    self.priceLabel.text = [self cartPrice];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Accessors

- (ACHProductManager *)manager {
    return [ACHProductManager shareManager];
}
- (ACHCartManager *)cart {
    return [ACHCartManager shareCartManager];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ACHProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACHProductCell"];
    id <ACHProductInfoDataSource> product = [self productAtIndex:indexPath];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", product.name];
    cell.priceLabel.text = [NSString stringWithFormat:@"%1.2f", product.price];
    cell.typeLabel.text = [NSString stringWithFormat:@"%@", product.type];
    cell.addToCartButton.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ACHDetailedInformationViewController *detaledInfoVC =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ACHDetailedInformationViewController"];
    detaledInfoVC.item = [self productAtIndex:indexPath];
    [self.navigationController pushViewController:detaledInfoVC animated:YES];
}

#pragma mark - Actions

- (IBAction)addToCardAction:(UIButton *)sender {
    sender.enabled = NO;
    [self.cart addItemToCart:[self.items objectAtIndex:sender.tag]];
    [self performSelector:@selector(enableButtonState:) withObject:sender afterDelay:3.f];
}

- (IBAction)clearCartAction:(UIButton *)sender {
    [self.cart clearCart];
    self.priceLabel.text = [self cartPrice];
}

#pragma mark - *** Other ***

- (void)enableButtonState:(UIButton *)sender {
    sender.enabled = YES;
    self.priceLabel.text = [self cartPrice];
}

-(NSString *)cartPrice {
    CGFloat price = [self.cart totalPrice];
    if (price == 0) {
        return @"emty";
    } else {
    return [NSString stringWithFormat:@"%1.2f",price];
    }
}

#pragma mark - Local table methods

- (id <ACHProductInfoDataSource>)productAtIndex:(NSIndexPath*)indexPath {
    return [self.items objectAtIndex:indexPath.row];
}

- (void) updateTableContent {
    self.items = self.manager.items;
    [self.tableView reloadData];
}

#pragma mark - Local notification

- (void)productsDidChanged:(NSNotification *)notification {
    [self updateTableContent];
    if ([self.items count] != 0 ) {
        [self alert:@"New products loaded!"];
    }
}

- (void)alert:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Information"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
