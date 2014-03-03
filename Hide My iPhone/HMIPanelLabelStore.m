//
//  HMIPanelLabelStore.m
//  Hide My iPhone
//
//  Created by John Yorke on 16/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "HMIPanelLabelStore.h"

@implementation HMIPanelLabelStore

- (id) init
{
    self = [super init];
    
    self.descriptionArray = @[@"Scorching",
                              @"Very hot",
                              @"Hot",
                              @"Lukewarm",
                              @"Tepid",
                              @"Cold",
                              @"Very cold",
                              @"Freezing"];
    return self;
}

+ (instancetype) sharedStore
{
    static dispatch_once_t onceToken;
    static HMIPanelLabelStore *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

@end
