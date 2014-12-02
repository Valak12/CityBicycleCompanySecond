//
//  Bicycle.m
//  CityBicycleCompany
//
//  Created by Vala Kohnechi on 12/1/14.
//  Copyright (c) 2014 MVA. All rights reserved.
//

#import "Bicycle.h"

@implementation Bicycle

@dynamic wheelsetColor;
@dynamic coordinatePosition;
@dynamic description;
@dynamic handleBars;
@dynamic hasAluminumAlloy;
@dynamic hasRearBreak;
@dynamic isOnSale;
@dynamic name;
@dynamic originalPrice;
@dynamic pedalStrap;
@dynamic quantity;
@dynamic saleDetail;
@dynamic salePrice;
@dynamic size;
@dynamic bicyclePhoto;

+ (void) load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Bicycle";
}
@end
