//
//  HMISeekPanelView.m
//  Hide My iPhone
//
//  Created by John Yorke on 14/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "HMISeekPanelView.h"

@implementation HMISeekPanelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        HMISeekPanelView *view = (HMISeekPanelView *)[[[NSBundle mainBundle] loadNibNamed:@"HMISeekPanelView" owner:nil options:nil] objectAtIndex:0];
        self = view;
    }
    return self;
}

- (void) makeSelected
{
    CGPoint oldCenter = self.center;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width * 1.4, self.frame.size.height * 1.4);
    self.center = oldCenter;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
