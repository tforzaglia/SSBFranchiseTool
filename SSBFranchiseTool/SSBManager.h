//
//  SSBManager.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 9/8/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SSBRestClient.h"

@interface SSBManager : NSObject

@property (nonatomic, strong) SSBRestClient *restClient;
@property (nonatomic) NSInteger numberOfYears;

+ (id)sharedManager;
+ (void)setNumberOfYears:(NSInteger)numberOfYears;

@end
