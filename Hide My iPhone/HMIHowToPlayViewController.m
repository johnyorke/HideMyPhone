//
//  HMIHowToPlayViewController.m
//  Hide My iPhone
//
//  Created by John Yorke on 18/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "HMIHowToPlayViewController.h"

@interface HMIHowToPlayViewController ()

@end

@implementation HMIHowToPlayViewController

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
    
    // Add GR so you can go back to menu
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToMainMenu)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}

- (void) viewDidAppear:(BOOL)animated
{

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
}

- (IBAction)goToTwitter:(id)sender 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/search?q=%23hidemyiphone&src=typd"]];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
