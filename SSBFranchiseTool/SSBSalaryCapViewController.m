//
//  SSBSalaryCapViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/25/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBConstants.h"
#import "SSBRestClient.h"
#import "SSBSalaryCapViewController.h"

@interface SSBSalaryCapViewController ()

@property NSMutableArray *yearArray;
@property NSArray *aTotalSalaryArray;
@property NSArray *tTotalSalaryArray;
@property NSArray *pTotalSalaryArray;
@property NSArray *aSalaryRemainingArray;
@property NSArray *tSalaryRemainingArray;
@property NSArray *pSalaryRemainingArray;

@end

@implementation SSBSalaryCapViewController

- (id)init {
    return [super initWithNibName:@"SSBSalaryCapView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.yearArray = [[NSMutableArray alloc] init];
    self.aTotalSalaryArray = [[NSArray alloc] init];
    self.tTotalSalaryArray = [[NSArray alloc] init];
    self.pTotalSalaryArray = [[NSArray alloc] init];
    self.aSalaryRemainingArray = [[NSArray alloc] init];
    self.tSalaryRemainingArray = [[NSArray alloc] init];
    self.pSalaryRemainingArray = [[NSArray alloc] init];
    
    for (int i = 1; i <= SSBNumberOfYears; i++) {
        [self.yearArray addObject:[NSNumber numberWithInt:i]];
    }
    
    return [super initWithNibName:@"SSBSalaryCapView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)fillSalaryTable {
    // make a call to the rest client , get the salary cap through the year array for each owner
    SSBRestClient *client = [[SSBRestClient alloc] init];
    [client getOwnerSalariesWithBlock:^void(NSArray *aSalary, NSArray *tSalary, NSArray *pSalary) {
        self.aTotalSalaryArray = [aSalary objectAtIndex:0];
        self.aSalaryRemainingArray = [aSalary objectAtIndex:1];
        self.tTotalSalaryArray = [tSalary objectAtIndex:0];
        self.tSalaryRemainingArray = [tSalary objectAtIndex:1];
        self.pTotalSalaryArray = [pSalary objectAtIndex:0];
        self.pSalaryRemainingArray = [pSalary objectAtIndex:1];
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    NSInteger count = 0;
    if (self.pSalaryRemainingArray) {
        count = [self.pSalaryRemainingArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableColumn == self.yearColumn) {
        return [self.yearArray objectAtIndex:row];
    }
    else if (tableColumn == self.aColumn) {
        float total = [[self.aTotalSalaryArray objectAtIndex:row] floatValue];
        float remaining = [[self.aSalaryRemainingArray objectAtIndex:row] floatValue];
        float used = total - remaining;
        
        return [NSString stringWithFormat:@"%g / %g", used, total];
    }
    else if (tableColumn == self.tColumn) {
        float total = [[self.tTotalSalaryArray objectAtIndex:row] floatValue];
        float remaining = [[self.tSalaryRemainingArray objectAtIndex:row] floatValue];
        float used = total - remaining;
        
        return [NSString stringWithFormat:@"%g / %g", used, total];
    }
    else if (tableColumn == self.pColumn) {
        float total = [[self.pTotalSalaryArray objectAtIndex:row] floatValue];
        float remaining = [[self.pSalaryRemainingArray objectAtIndex:row] floatValue];
        float used = total - remaining;
        
        return [NSString stringWithFormat:@"%g / %g", used, total];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    [tv reloadData];
}

@end

