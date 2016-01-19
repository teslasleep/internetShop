//
//  ACHDataBaseManager.h
//  InternetShop
//
//  Created by Andrew on 18.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ACHProductInfoDataSource.h"

@interface ACHDataBaseManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly) NSArray *items;

+ (ACHDataBaseManager *)shareDataBaseManager;

- (BOOL)addNewItem:(id <ACHProductInfoDataSource>)newItem;
- (BOOL)clearDataBase;

@end
