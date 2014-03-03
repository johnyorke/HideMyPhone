//
//  HMIPanelLabelStore.h
//  Hide My iPhone
//
//  Created by John Yorke on 16/11/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMIPanelLabelStore : NSObject

@property (nonatomic, strong) NSArray *descriptionArray;

+ (instancetype) sharedStore;

@end
