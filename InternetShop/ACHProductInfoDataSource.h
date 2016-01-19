//
//  ACHProductInfoDataSource.h
//  InternetShop
//
//  Created by Andrew on 13.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol ACHProductInfoDataSource <NSObject>

@property (readonly) NSString *name;
@property (readonly)  CGFloat price;
@property (readonly) NSString *type;

@end
