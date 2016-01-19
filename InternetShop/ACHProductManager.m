//
//  ACHProductManager.m
//  InternetShop
//
//  Created by Andrew on 13.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import "ACHProductManager.h"
#import "ACHDataBaseManager.h"
#import "ACHProduct.h"

NSString* const ProductManagerProductsDidChangeNotification = @"ProductManagerProductsDidChangeNotification";
NSString* const ProductManagerProductsUserInfoKey = @"ProductManagerProductsUserInfoKey";

@interface  ACHProductManager()

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) ACHDataBaseManager *dbManager;

@end

@implementation ACHProductManager

#pragma mark - Singleton

+(ACHProductManager *)shareManager {
    static ACHProductManager *singletonObject = nil;
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    return singletonObject;
}

#pragma mark - Accessors

- (NSArray *)items {
    if (self.products == nil) {
        [self loadDataFromDB];
    }
    return self.products;
}

- (ACHDataBaseManager *)dbManager {
    return [ACHDataBaseManager shareDataBaseManager];
}
#pragma mark - Work with data

- (void)clearAllData {
    [[ACHDataBaseManager shareDataBaseManager] clearDataBase];
    self.products = nil;
    [self itemsChanged];
}

- (void)loadDefaultData {
    dispatch_queue_t myCustomQueue;
    myCustomQueue = dispatch_queue_create("com.internetShop.productManager", NULL);
    
    dispatch_async(myCustomQueue, ^{
        [self loadDataFromPlist];
        
    });
    
    dispatch_sync(myCustomQueue, ^{
        [self performSelector:@selector(updateNotification) withObject:nil afterDelay:5.f];
    });
}

#pragma mark - Load data from plist

- (void)loadDataFromPlist {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
        for (id iter in [data allKeys]) {
            NSArray *items = [data objectForKey:iter];
            for (int i = 0; i < [items count]; i++) {
                ACHProduct *newProduct = [[ACHProduct alloc] init];
                newProduct.productName = [[items objectAtIndex:i] objectForKey:@"name"];
                newProduct.productPrice = [[[items objectAtIndex:i] objectForKey:@"price"] doubleValue];
                newProduct.productType = iter;
                [self.dbManager addNewItem:newProduct];
            }
        }
    }
}

- (void)loadDataFromDB {
    self.products = self.dbManager.items;
}

- (void)itemsChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:ProductManagerProductsDidChangeNotification
                                                        object:nil
                                                      userInfo:nil];
}

- (void)updateNotification {
    [self loadDataFromDB];
    [self itemsChanged];

}

#pragma mark - Multithreding

- (void)addNewItem:(id <ACHProductInfoDataSource>)item {
    
    dispatch_queue_t myCustomQueue;
    myCustomQueue = dispatch_queue_create("com.internetShop.productManager", NULL);
       
       dispatch_async(myCustomQueue, ^{
           [self.dbManager addNewItem:item];

       });
       
       dispatch_sync(myCustomQueue, ^{
           [self performSelector:@selector(updateNotification) withObject:nil afterDelay:5.f];
       });
}

@end
