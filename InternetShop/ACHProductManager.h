//
//  ACHProductManager.h
//  InternetShop
//
//  Created by Andrew on 13.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACHProductInfoDataSource.h"

extern NSString* const ProductManagerProductsDidChangeNotification;
extern NSString* const ProductManagerProductsUserInfoKey;

@interface ACHProductManager : NSObject
@property (readonly) NSArray* items;

+ (ACHProductManager *)shareManager;

- (void)addNewItem:(id <ACHProductInfoDataSource>)item;
- (void)clearAllData;
- (void)loadDefaultData;

@end
