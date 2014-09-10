//
//  SSBManager.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 9/8/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBManager.h"
#import "SSBRestClient.h"

@implementation SSBManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static SSBManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        self.restClient = [[SSBRestClient alloc] init];
        
        [self.restClient getFighterInfoByName:@"Bowser" withBlock:^void(SSBFighter *fighter) {
            self.numberOfYears = [fighter.winsThroughTheYears count];
        }];
    }
    return self;
}

+ (void)setNumberOfYears:(NSInteger)numberOfYears {
    self.numberOfYears = numberOfYears;
}

@end
