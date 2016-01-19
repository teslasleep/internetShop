//
//  ProductEntity+CoreDataProperties.h
//  InternetShop
//
//  Created by Andrew on 18.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProductEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *price;

@end

NS_ASSUME_NONNULL_END
