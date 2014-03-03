//
//  HMIHideViewController.m
//  Hide My iPhone
//
//  Created by John Yorke on 17/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "HMIHideViewController.h"

NSString * const hideUUID = @"B6DD298A-897B-4D97-A2F9-2C400A3BC775";

@interface HMIHideViewController ()

@property (strong, nonatomic) CBPeripheralManager *myPeripheralManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) UIImageView *beaconAnimation;
@property (weak, nonatomic) IBOutlet UIImageView *beaconButton;
@property (weak, nonatomic) IBOutlet UILabel *beaconLabel;
@property (strong, nonatomic) UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UIView *nearbyBeaconView;

@property (nonatomic, strong) NSDate *lastRanged;

@property (nonatomic, strong) NSString *gameName;

@property (weak, nonatomic) IBOutlet UILabel *endGameLabel;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation HMIHideViewController

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
	// Do any additional setup after loading the view.
    
    // Set up CL and BT and start advertising and monitoring
    self.myPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self startAdvertising];
    [self startMonitoringForBeacons];
    
    // Add GR so you can go back to menu
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToMainMenu)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    // Set up the animation
    self.beaconAnimation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 312, 312)];
    self.beaconAnimation.center = self.view.center;
    self.beaconAnimation.alpha = 0.2f;
    [self.view addSubview:self.beaconAnimation];
    
    UIImage *frameZero = [UIImage imageNamed:@"beaconAnimationZero.png"];
    UIImage *frameOne = [UIImage imageNamed:@"beaconAnimationOne.png"];
    UIImage *frameTwo = [UIImage imageNamed:@"beaconAnimationTwo.png"];
    UIImage *frameThree = [UIImage imageNamed:@"beaconAnimationThree.png"];
    
    NSArray *animationImages = @[frameZero,frameOne,frameTwo,frameThree];
    
    self.beaconAnimation.animationDuration = 3.0f;
    self.beaconAnimation.animationImages = animationImages;
    [self.beaconAnimation startAnimating];
    
    self.phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneIcon"]];
    self.phoneIcon.center = self.nearbyBeaconView.center;
    [self.nearbyBeaconView addSubview:self.phoneIcon];
    self.phoneIcon.alpha = 0;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self presentAlertForNoLocationAccess];
        [self.beaconAnimation stopAnimating];
    }
    
    self.endGameLabel.alpha = 0;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTheGame)];
}


- (void) peripheralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
        if ([beacons count] > 0) {
            if ([[[beacons objectAtIndex:0] major]  isEqual: @2]) {
                NSDate *attemptDate = [NSDate date];
                NSTimeInterval betweenRangeAndAttempt = [attemptDate timeIntervalSinceDate:self.lastRanged];
                
                // Only update every 3 seconds or on first run
                if (betweenRangeAndAttempt > 3 || !self.lastRanged) {
                    self.phoneIcon.alpha = 0.5;
                    [UIView animateWithDuration:1.0f animations:^{
                        self.phoneIcon.center = CGPointMake(self.view.center.x, (self.nearbyBeaconView.frame.size.height / 20) * [[beacons objectAtIndex:0] accuracy]);
                        self.lastRanged = [NSDate date];
                        
                        // To end the game
                        if (CLProximityImmediate == [[beacons firstObject] proximity]) {
                            self.endGameLabel.alpha = 1.0f;
                            self.beaconLabel.text = @"Found?";
                            [self.beaconButton addGestureRecognizer:self.tapGesture];
                        } else {
                            self.endGameLabel.alpha = 0;
                            self.beaconLabel.text = @"Hiding";
                            [self.beaconButton removeGestureRecognizer:self.tapGesture];
                        }
                    }];
                }
            }
        } else self.phoneIcon.alpha = 0;
}

- (void) startAdvertising
{
    if (self.myPeripheralManager.isAdvertising) {
        [self.myPeripheralManager stopAdvertising];
    }
    // Define a region
    NSUUID *myProximityUUID = [[NSUUID alloc]
                               initWithUUIDString:hideUUID];
    
    NSNumber *majorNumber = @1;
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
                                                                            initWithUUIDString:hideUUID]
                                                                identifier:@"Hide My Phone"];    
    [self.locationManager startRangingBeaconsInRegion:region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) endTheGame
{
    NSLog(@"Game ended!");
    self.myPeripheralManager = nil;
    self.locationManager = nil;
    self.endGameLabel.text = @"Game over!\nDevice has been found!";
    self.beaconLabel.text = @"Found!";
    [self.beaconAnimation stopAnimating];
    [self.phoneIcon removeFromSuperview];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
