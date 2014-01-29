//
//  SSBSalaryCapViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/25/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBSalaryCapViewController.h"
#import "SSBConstants.h"
#import "SSBRestClient.h"

@interface SSBSalaryCapViewController ()

@property NSMutableArray *yearArray;
@property NSMutableArray *aSalaryArray;
@property NSMutableArray *tSalaryArray;
@property NSMutableArray *pSalaryArray;

@end

@implementation SSBSalaryCapViewController

- (id)init {
    
    return [super initWithNibName:@"SSBSalaryCapView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    _yearArray = [[NSMutableArray alloc] init];
    _aSalaryArray = [[NSMutableArray alloc] init];
    _tSalaryArray = [[NSMutableArray alloc] init];
    _pSalaryArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= NumberOfYears; i++) {
        [_yearArray addObject:[NSNumber numberWithInt:i]];
    }
    
    // make a call to the rest client , get the salary cap through the year array for each owner
    SSBRestClient *client = [[SSBRestClient alloc] init];
    [client getOwnerSalariesWithBlock:^void(NSArray *aSalary, NSArray *tSalary, NSArray *pSalary) {
        _aSalaryArray = [aSalary mutableCopy];
        _tSalaryArray = [tSalary mutableCopy];
        _pSalaryArray = [pSalary mutableCopy];
    }];
    
    return [super initWithNibName:@"SSBSalaryCapView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)awakeFromNib {
    

}

@end
