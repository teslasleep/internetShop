//
//  ACHDetailedInformationViewController.h
//  InternetShop
//
//  Created by Andrew on 12.01.16.
//  Copyright © 2016 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACHProductInfoDataSource;

@interface ACHDetailedInformationViewController : UIViewController

@property (strong, nonatomic) id <ACHProductInfoDataSource> item;

@end
