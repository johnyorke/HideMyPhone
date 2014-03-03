//
//  HMIMainMenuViewController.m
//  Hide My iPhone
//
//  Created by John Yorke on 16/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "HMIMainMenuViewController.h"
#import "HMISeekViewController.h"


@interface HMIMainMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UIButton *seekbutton;
@property (weak, nonatomic) IBOutlet UIButton *howToPlayButton;
@property (weak, nonatomic) IBOutlet UITextField *gameNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

@property CGPoint gameNameTextFieldCenter;
@property CGPoint gameNameLabelCenter;

@property CGRect hideButtonFrame;
@property CGRect seekButtonFrame;
@property CGRect howToPlayFrame;

@property BOOL buttonsInPlace;

@end

@implementation HMIMainMenuViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];

    self.gameNameTextFieldCenter = self.gameNameTextField.center;
    self.gameNameLabelCenter = self.gameNameLabel.center;
    
    self.gameNameTextField.delegate = self;
    
    // Remove in phase 2
    [self.gameNameTextField setHidden:YES];
    [self.gameNameLabel setHidden:YES];
    
    self.hideButtonFrame = self.hideButton.frame;
    self.seekButtonFrame = self.seekbutton.frame;
    self.howToPlayFrame = self.howToPlayButton.frame;
    
    self.buttonsInPlace = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    if (self.buttonsInPlace == NO) {
        [self animateButtonsIntoPlace];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) animateButtonsIntoPlace
{
    self.hideButton.center = CGPointMake(self.hideButton.center.x, self.hideButton.center.y - 400);
    self.seekbutton.center = CGPointMake(self.seekbutton.center.x, self.seekbutton.center.y - 400);
    self.howToPlayButton.center = CGPointMake(self.howToPlayButton.center.x, self.howToPlayButton.center.y - 400);
    
    [UIView animateWithDuration:0.8f delay:0.5f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.hideButton.frame = self.hideButtonFrame;
        self.seekbutton.frame = self.seekButtonFrame;
        self.howToPlayButton.frame = self.howToPlayFrame;
    }completion:nil];
    self.buttonsInPlace = YES;
}

- (void) keyboardDidShow
{
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.gameNameTextField.center = CGPointMake(self.gameNameTextField.center.x, self.view.frame.size.height / 5);
        self.gameNameLabel.center = CGPointMake(self.gameNameLabel.center.x, (self.view.frame.size.height / 5) + 20);
    }completion:nil];
}

- (void) keyboardDidHide
{
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.gameNameTextField.center = self.gameNameTextFieldCenter;
        self.gameNameLabel.center = self.gameNameLabelCenter;
    }completion:nil];
}

- (NSString *) returnGameName
{
    return self.gameName;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.gameName = textField.text;
    
    NSLog(@"%@", self.gameName);
    
    return YES;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
