//
//  HMIHideViewController.h
//  Hide My iPhone
//
//  Created by John Yorke on 17/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface HMIHideViewController : UIViewController <CBPeripheralManagerDelegate, CLLocationManagerDelegate>

@end
