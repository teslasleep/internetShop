//
//  ACHCartManager.m
//  InternetShop
//
//  Created by Andrew on 19.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import "ACHCartManager.h"

@interface  ACHCartManager()

@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) CGFloat price;

@end

@implementation ACHCartManager

#pragma mark - Singleton

+(ACHCartManager *)shareCartManager {
    static ACHCartManager *singletonObject = nil;
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    return singletonObject;
}

#pragma mark - *** Other ***

- (BOOL)addItemToCart:(id<ACHProductInfoDataSource>)item {
    
    dispatch_queue_t myCustomQueue;
    myCustomQueue = dispatch_queue_create("com.internetShop.cartManager", NULL);
    
    dispatch_async(myCustomQueue, ^{
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
        [array addObject:item];
        self.items = array;
    });
    
    dispatch_sync(myCustomQueue, ^{
        [self updatePrice];
    });
    
    return YES;
}

- (void)clearCart {
    self.items = nil;
    self.price = 0.f;
}

- (CGFloat)totalPrice {
    return self.price;
}

- (void)updatePrice {
    for (id<ACHProductInfoDataSource> item in self.items) {
        self.price += item.price;
    }
}
@end
