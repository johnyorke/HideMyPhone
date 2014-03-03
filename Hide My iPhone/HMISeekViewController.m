//
//  HMISeekViewController.m
//  Hide My iPhone
//
//  Created by John Yorke on 16/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "HMISeekViewController.h"
#import "HMISeekPanelView.h"
#import "HMIPanelLabelStore.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "HMISearchingBox.h"

NSString * const seekUUID = @"B6DD298A-897B-4D97-A2F9-2C400A3BC775";


@interface HMISeekViewController ()

@property (strong, nonatomic) HMISeekPanelView *panelZero;
@property (strong, nonatomic) HMISeekPanelView *panelOne;
@property (strong, nonatomic) HMISeekPanelView *panelTwo;
@property (strong, nonatomic) HMISeekPanelView *panelThree;
@property (strong, nonatomic) HMISeekPanelView *panelFour;
@property (strong, nonatomic) HMISeekPanelView *panelFive;
@property (strong, nonatomic) HMISeekPanelView *panelSix;
@property (strong, nonatomic) HMISeekPanelView *panelSeven;

@property (strong, nonatomic) NSArray *colourArray;
@property (strong, nonatomic) NSArray *panelArray;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) CBPeripheralManager *myPeripheralManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSDate *lastRanged;

@property BOOL allPanelsInPlace;
@property BOOL isShowingAlert;

@property (nonatomic, strong) HMISearchingBox *searchBox;

@end

@implementation HMISeekViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.colourArray = @[[UIColor colorWithRed:0.92 green:0.13 blue:0.18 alpha:1.0],
                         [UIColor colorWithRed:0.93 green:0.18 blue:0.33 alpha:1.0],
                         [UIColor colorWithRed:0.93 green:0.33 blue:0.33 alpha:1.0],
                         [UIColor colorWithRed:0.93 green:0.45 blue:0.34 alpha:1.0],
                         [UIColor colorWithRed:0.93 green:0.69 blue:0.56 alpha:1.0],
                         [UIColor colorWithRed:0.52 green:0.79 blue:0.62 alpha:1.0],
                         [UIColor colorWithRed:0.54 green:0.69 blue:0.92 alpha:1.0],
                         [UIColor colorWithRed:0.06 green:0.47 blue:0.63 alpha:1.0]];
    
    self.panelZero = [[HMISeekPanelView alloc] initWithFrame:CGRectMake(0, 
                                                                        0, 
                                                                        [UIScreen mainScreen].bounds.size.width, 
                                                                        [UIScreen mainScreen].bounds.size.height / 8)];
    self.panelOne = [[HMISeekPanelView alloc] initWithFrame:CGRectMake(0, 
                                                                       0, 
                                                                       [UIScreen mainScreen].bounds.size.width, 
                                                                       [UIScreen mainScreen].bounds.size.height / 8)];
    self.panelTwo = [[HMISeekPanelView alloc] initWithFrame:CGRectMake(0, 
                                                                       0, 
                                                                       [UIScreen mainScreen].bounds.size.width, 
                                                                       [UIScreen mainScreen].bounds.size.height / 8)];
    self.panelThree = [[HMISeekPanelView alloc] initWithFrame:CGRectMake(0, 
                                                                         0, 
                                                                         [UIScreen mainScreen].bounds.size.width, 
                                                                         [UIScreen mainScreen].bounds.size.height / 8)];
    self.panelFour = [[HMISeekPanelView alloc] initWithFrame:CGRectMake(0, 
                                                                        0, 
                                                                        [UIScreen mainScreen].bounds.size.width, 
                                                                        [UIScreen mainScreen].bounds.size.height / 8)];
    self.panelFive = [[HMISeekPanelView alloc] initWithFrame:CGRectMake(0, 
                                                                        0, 
                                                                        [UIScreen mainScreen].bounds.size.width, 
                                                                        [UIScreen mainScreen].bounds.size.height / 8)];
    self.panelSix = [[HMISeekPanelView alloc] initWithFrame:CGRectMake(0, 
                                                                       0, 
                                                                       [UIScreen mainScreen].bounds.size.width, 
                                                                       [UIScreen mainScreen].bounds.size.height / 8)];
    self.panelSeven = [[HMISeekPanelView alloc] initWithFrame:CGRectMake(0, 
                                                                         0, 
                                                                         [UIScreen mainScreen].bounds.size.width, 
                                                                         [UIScreen mainScreen].bounds.size.height / 8)];
    
    self.panelArray = @[self.panelZero,
                        self.panelOne,
                        self.panelTwo,
                        self.panelThree,
                        self.panelFour,
                        self.panelFive,
                        self.panelSix,
                        self.panelSeven];
    
    // Set up CL and BT and start advertising and monitoring
    self.myPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self startAdvertising];
    [self startMonitoringForBeacons];
    
    self.allPanelsInPlace = NO;
    
    self.searchBox = [[HMISearchingBox alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    self.searchBox.center = self.view.center;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self presentAlertForNoLocationAccess];
    }
    
    self.isShowingAlert = NO;
}

- (void) peripheralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [self setUpColourBars];
    
    // Make sure backButton is on top of colour bars
    [self.view addSubview:self.backButton];
}

- (void) setUpColourBars
{
    for (NSInteger x = 0; x < [self.panelArray count]; x++) {     
        HMISeekPanelView *tempView = [self.panelArray objectAtIndex:x];
        
        // Add GR so you can go back to menu
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToMainMenu)];
        
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        
        [tempView addGestureRecognizer:swipe];
        
        // Create y coordinate based on its index number (top to bottom of screen)
        CGFloat yCoord;
        float timeDelay;
        
        // Check if it's first in the array
        if (x == 0) {
            yCoord = 0;
            timeDelay = 0;
        } else {
            yCoord = ([UIScreen mainScreen].bounds.size.height / 8) * x;
            timeDelay = 0.2 * x;
        }
        
        // Move the panel off screen
        tempView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 
                                    yCoord, 
                                    [UIScreen mainScreen].bounds.size.width, 
                                    [UIScreen mainScreen].bounds.size.height / 8);
        
        tempView.backgroundColor = [self.colourArray objectAtIndex:x];
        
        tempView.panelLabel.text = [[HMIPanelLabelStore sharedStore].descriptionArray objectAtIndex:x];
        
        [self.view addSubview:tempView];
        
        [UIView animateWithDuration:0.5 delay:timeDelay usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            tempView.frame = CGRectMake(0, 
                                        yCoord, 
                                        [UIScreen mainScreen].bounds.size.width, 
                                        [UIScreen mainScreen].bounds.size.height / 8);        
        }completion:^(BOOL finished){
            if (x == [self.panelArray count] - 1) {
                self.allPanelsInPlace = YES;
            }
        }];
    }
}

- (void) startAdvertising
{
    if (self.myPeripheralManager.isAdvertising) {
        [self.myPeripheralManager stopAdvertising];
    }
    // Define a region
    NSUUID *myProximityUUID = [[NSUUID alloc]
                               initWithUUIDString:seekUUID];
    
    NSNumber *majorNumber = @2;
    NSNumber *minorNumber = @1;
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc]
                              initWithProximityUUID:myProximityUUID
                              major:[majorNumber unsignedShortValue]
                              minor:[minorNumber unsignedShortValue]
                              identifier:@"Hide My Phone"];
    
    // Ask region to provide Core-Bluetooth-ready peripheral data
    NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:nil];
    
    [self.myPeripheralManager startAdvertising:peripheralData];
}

- (void) startMonitoringForBeacons
{
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
                                                                            initWithUUIDString:seekUUID]
                                                                identifier:@"Hide My Phone"];    
    [self.locationManager startRangingBeaconsInRegion:region];
}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // Get beacons in hide or seek arrays
    NSMutableArray *hideBeacons = [[NSMutableArray alloc] init];
    NSMutableArray *seekBeacons = [[NSMutableArray alloc] init];
    if ([beacons count] > 0) {
        for (NSInteger x = 0; x < [beacons count]; x++) {
            if ([[[beacons objectAtIndex:x] major]  isEqual: @1]) {
                [hideBeacons addObject:[beacons objectAtIndex:x]];
            } else if ([[[beacons objectAtIndex:x] major]  isEqual: @2]){
                [seekBeacons addObject:[beacons objectAtIndex:x]];
            }
        }
    }
    
    // Make sure the intro animation is complete 
    if (self.allPanelsInPlace) {
        NSDate *attemptDate = [NSDate date];
        NSTimeInterval betweenRangeAndAttempt = [attemptDate timeIntervalSinceDate:self.lastRanged];
        
        // Only update every 3 seconds or on first run
        if (betweenRangeAndAttempt > 0.5f || !self.lastRanged) {
            if ([hideBeacons count] > 0) {
                [self hideSearchingBox];
                float distanceToBeacon = [[hideBeacons objectAtIndex:0] accuracy];
                if (distanceToBeacon < 0.2 && distanceToBeacon > 0) {
                    [self resetPanelLabelAlphas];
                    self.panelZero.panelLabel.alpha = 0.7f;
                } else if (distanceToBeacon > 0.2 && distanceToBeacon < 2) {
                    [self resetPanelLabelAlphas];
                    self.panelOne.panelLabel.alpha = 0.7f;
                } else if (distanceToBeacon > 2 && distanceToBeacon < 5) {
                    [self resetPanelLabelAlphas];
                    self.panelTwo.panelLabel.alpha = 0.7f;
                } else if (distanceToBeacon > 5 && distanceToBeacon < 8) {
                    [self resetPanelLabelAlphas];
                    self.panelThree.panelLabel.alpha = 0.7f;
                } else if (distanceToBeacon > 8 && distanceToBeacon < 11) {
                    [self resetPanelLabelAlphas];
                    self.panelFour.panelLabel.alpha = 0.7f;
                } else if (distanceToBeacon > 11 && distanceToBeacon < 14) {
                    [self resetPanelLabelAlphas];
                    self.panelFive.panelLabel.alpha = 0.7f;
                } else if (distanceToBeacon > 14 && distanceToBeacon < 17) {
                    [self resetPanelLabelAlphas];
                    self.panelSix.panelLabel.alpha = 0.7f;
                } else if (distanceToBeacon > 17) {
                    [self resetPanelLabelAlphas];
                    self.panelSeven.panelLabel.alpha = 0.7f;
                } else NSLog(@"Lost!");
                
                self.lastRanged = [NSDate date];
            } else [self showSearchingBox];
        }
    }
}

- (void) showSearchingBox
{
    if (self.isShowingAlert == NO) {
        self.searchBox.center = CGPointMake(self.view.center.x, self.view.center.y - [UIScreen mainScreen].bounds.size.height);
        
        [self.view addSubview:self.searchBox];
        [self resetPanelLabelAlphas];
        
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:2.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.searchBox.center = self.view.center;
            self.isShowingAlert = YES;
        }completion:nil];
    }
}

- (void) hideSearchingBox
{
    if (self.isShowingAlert) {
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:2.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.searchBox.center = CGPointMake(self.view.center.x, self.view.center.y + [UIScreen mainScreen].bounds.size.height);
            self.isShowingAlert = YES;
        }completion:^(BOOL finished){
            [self.searchBox removeFromSuperview];
            self.isShowingAlert = NO;
        }];
    }
}

- (IBAction)backButtonTapped:(id)sender
{
    [self backToMainMenu];
}

- (void) backToMainMenu
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.myPeripheralManager stopAdvertising];
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) resetPanelLabelAlphas
{
    self.panelZero.panelLabel.alpha = 0.1f;
    self.panelOne.panelLabel.alpha = 0.1f;
    self.panelTwo.panelLabel.alpha = 0.1f;
    self.panelThree.panelLabel.alpha = 0.1f;
    self.panelFour.panelLabel.alpha = 0.1f;
    self.panelFive.panelLabel.alpha = 0.1f;
    self.panelSix.panelLabel.alpha = 0.1f;
    self.panelSeven.panelLabel.alpha = 0.1f;
}

- (void) presentAlertForNoLocationAccess
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Locations Access" message:@"Please go to Settings > Privacy > Location and enable Hide My iPhone to play" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"No Locations Access"]){
        [self backToMainMenu];
    }
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end

