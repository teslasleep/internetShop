//
//  ACHProduct.h
//  InternetShop
//
//  Created by Andrew on 13.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ACHProductInfoDataSource.h"


@interface ACHProduct : NSObject <ACHProductInfoDataSource>

@property (strong, nonatomic) NSString *productName;
@property (assign, nonatomic) CGFloat productPrice;
@property (strong, nonatomic) NSString *productType;

@end
