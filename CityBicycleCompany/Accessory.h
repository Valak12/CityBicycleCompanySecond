//
//  Accessory.h
//  CityBicycleCompany
//
//  Created by Vala Kohnechi on 12/1/14.
//  Copyright (c) 2014 MVA. All rights reserved.
//

#import <Parse/Parse.h>
@class Photo;
@interface Accessory : PFObject <PFSubclassing>

@property NSArray *color;
@property NSString *accessoryDescription;
@property NSString *detailSale;
@property NSString *name;
@property NSNumber *originalPrice;
@property NSNumber *quantity;
@property NSNumber *salePrice;
@property NSArray *size;
@property BOOL isOnSale;
//@property Photo *accessoryPhoto;
@property PFFile *accessoryPhoto;



@end
