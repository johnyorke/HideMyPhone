//
//  HMISearchingBox.m
//  Hide My iPhone
//
//  Created by John Yorke on 17/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "HMISearchingBox.h"

@implementation HMISearchingBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        HMISearchingBox *view = (HMISearchingBox *)[[[NSBundle mainBundle] loadNibNamed:@"HMISearchingBox" owner:nil options:nil] objectAtIndex:0];
        self = view;
    }
    return self;
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
