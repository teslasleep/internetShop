//
//  ACHProduct.m
//  InternetShop
//
//  Created by Andrew on 13.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import "ACHProduct.h"
#import "ACHProductInfoDataSource.h"

@implementation ACHProduct

#pragma mark - ACHProductInfoDataSource

- (NSString *)name {
    return self.productName;
}

- (CGFloat)price {
    return self.productPrice;
}

- (NSString *)type {
    return self.productType;
}

@end
