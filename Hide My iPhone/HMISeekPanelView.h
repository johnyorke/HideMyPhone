//
//  HMISeekPanelView.h
//  Hide My iPhone
//
//  Created by John Yorke on 14/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMISeekPanelView : UIView
@property (weak, nonatomic) IBOutlet UILabel *panelLabel;

- (void) makeSelected;

@end
