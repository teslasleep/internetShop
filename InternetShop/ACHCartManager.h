//
//  ACHCartManager.h
//  InternetShop
//
//  Created by Andrew on 19.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "ACHProductInfoDataSource.h"

@interface ACHCartManager : NSObject

@property (readonly) NSArray *items;

+ (ACHCartManager *)shareCartManager;

- (BOOL)addItemToCart:(id<ACHProductInfoDataSource>)item;
- (void)clearCart;
- (CGFloat)totalPrice;

@end
