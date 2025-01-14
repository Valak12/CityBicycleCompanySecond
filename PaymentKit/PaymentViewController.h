//
//  PaymentViewController.h
//  CityBicycleCompany
//
//  Created by May Yang on 12/15/14.
//  Copyright (c) 2014 MVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKView.h"

@interface PaymentViewController : UIViewController <PTKViewDelegate>
@property IBOutlet PTKView *paymentView;
@property IBOutlet PTKAddressZip *addressZip;
@property (nonatomic) NSDecimalNumber *amount;
@property (nonatomic)NSMutableArray *shippingInfo;

@end
