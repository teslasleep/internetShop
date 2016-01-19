//
//  ACHAddNewProductViewController.m
//  InternetShop
//
//  Created by Andrew on 17.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import "ACHAddNewProductViewController.h"
#import "ACHProductManager.h"
#import "ACHProduct.h"

@interface ACHAddNewProductViewController () <UITextFieldDelegate>

@property (strong, nonatomic) id <UITextFieldDelegate> externalDelegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *fieldsCollection;

@end

@implementation ACHAddNewProductViewController

#pragma mark - Initialization

-(instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    self.delegate = self;
    [self setActiveReturnKey:self.fieldsCollection];
    return self;
}

#pragma mark - Accessor methods

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    if (delegate != self) {
        self.externalDelegate = delegate;
    }
}

- (IBAction)saveAction:(UIButton *)sender {
    if ([self saveNewProduct]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSArray *collection = [NSArray arrayWithArray:self.fieldsCollection];
    
    if ([textField isEqual:[collection lastObject]]) {
             if ([self saveNewProduct]) {
                [textField resignFirstResponder];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [textField resignFirstResponder];
            }
    } else {
        NSUInteger index = [collection indexOfObject:textField] + 1;
        [[collection objectAtIndex:index] becomeFirstResponder];
    }
    return YES;
}

#pragma mark - *** Other ***

- (BOOL) isFillNameAndType {
    return [self.nameTextField.text length] > 0 && [self.typeTextField.text length] > 0;
}

- (void)setActiveReturnKey:(NSArray *)collection {
    for (UITextField *textField in collection) {
        textField.enablesReturnKeyAutomatically = YES;
    }
}

- (BOOL)saveNewProduct {
    if ([self isFillNameAndType]) {
        ACHProduct *newProduct = [[ACHProduct alloc] init];
        newProduct.productName = self.nameTextField.text;
        newProduct.productPrice = [self.priceTextField.text doubleValue];
        newProduct.productType = self.typeTextField.text;
        [[ACHProductManager shareManager] addNewItem:newProduct];
        return YES;
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Attention"
                                                                       message:@"Please fill name and type!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    return NO;
}

@end
