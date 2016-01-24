//
//  ACHStorageViewController.m
//  InternetShop
//
//  Created by Andrew on 12.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import "ACHStorageViewController.h"

#import "ACHProductManager.h"
#import "ACHProductCell.h"
#import "ACHProductInfoDataSource.h"
#import "ACHDetailedInformationViewController.h"

@interface  ACHStorageViewController()

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) ACHProductManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *loadDefaultButton;

@end

@implementation ACHStorageViewController

#pragma mark - View cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productsDidChanged:)
                                                 name:ProductManagerProductsDidChangeNotification
                                               object:nil];
    [self updateTableContent];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Accessors

- (ACHProductManager *)manager {
    return [ACHProductManager shareManager];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ACHProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACHProductCell"];
    
    id <ACHProductInfoDataSource> productField =  [self productAtIndex:indexPath];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", productField.name];
    cell.priceLabel.text = [NSString stringWithFormat:@"%1.2f", productField.price];
    cell.typeLabel.text = [NSString stringWithFormat:@"%@", productField.type];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ACHDetailedInformationViewController *detaledInfoVC =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ACHDetailedInformationViewController"];
    detaledInfoVC.item = [self productAtIndex:indexPath];
    [self.navigationController pushViewController:detaledInfoVC animated:YES];
}

#pragma mark - Actions

- (IBAction)clearAllAction:(UIButton *)sender {
    if ([self.items count] != 0) {
        [self.manager clearAllData];
    } else {
        [self alertWithMessage:@"No data!"];
    }
}

- (IBAction)loadDeafultDataAction:(UIButton *)sender {
    self.loadDefaultButton.enabled = NO;
    self.loadDefaultButton.backgroundColor = [UIColor lightGrayColor];
    [self.manager loadDefaultData];
}


#pragma mark - *** Other ***

- (void)productsDidChanged:(NSNotification *)notification {
    [self updateTableContent];
    if ([self.items count] != 0 ) {
        [self alertWithMessage:@"New products loaded!"];
    }
    
}

- (void) updateTableContent {
    if (!self.loadDefaultButton.enabled) {
        self.loadDefaultButton.enabled = YES;
        self.loadDefaultButton.backgroundColor = [UIColor clearColor];
    }
    self.items = self.manager.items;
    [self.tableView reloadData];
}

- (id <ACHProductInfoDataSource>)productAtIndex:(NSIndexPath*)indexPath {
    return [self.items objectAtIndex:indexPath.row];
}

- (void)alertWithMessage:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Information"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
