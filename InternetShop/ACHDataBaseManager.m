//
//  ACHDataBaseManager.m
//  InternetShop
//
//  Created by Andrew on 18.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import "ACHDataBaseManager.h"
#import "ProductEntity+CoreDataProperties.h"

@interface  ACHDataBaseManager()

@property (strong, nonatomic) NSURL *storeURL;

@end

@implementation ACHDataBaseManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static NSString *dataBaseName = @"ProductModel";
static NSString *entityName = @"ProductEntity";


#pragma mark - Singleton

+(ACHDataBaseManager *)shareDataBaseManager {
    static ACHDataBaseManager *singletonObject = nil;
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
        [singletonObject dataBaseInit];
    });
    return singletonObject;
}
#pragma mark - Initializaton

- (void)dataBaseInit {
    if (!self.managedObjectContext) {
        [self managedObjectContext];
    }
}

#pragma mark - Accessors

- (BOOL)addNewItem:(id <ACHProductInfoDataSource>)newItem {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    
    ProductEntity *productEntity = [[ProductEntity alloc] initWithEntity:entity
                                    insertIntoManagedObjectContext:self.managedObjectContext];
    productEntity.name = newItem.name;
    productEntity.type = newItem.type;
    productEntity.price = @(newItem.price);
    
    NSError *error = nil;
    [productEntity.managedObjectContext save:&error];
    
    if (!error) {
        return YES;
    }
    return NO;
}

- (NSArray *)items {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    return array;
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:dataBaseName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    self.storeURL = storeURL;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        }
    }
}

#pragma mark - Core Data Clear support

- (BOOL)clearDataBase {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *items = [context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *entity in items) {
        [context deleteObject:entity];
    }
    [context save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

@end
