//
//  SSBSalaryCapViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/25/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBMacros.h"
#import "SSBManager.h"
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
    
    return [super initWithNibName:@"SSBSalaryCapView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)fillSalaryTable {
    for (int i = 1; i <= [[SSBManager sharedManager] numberOfYears]; i++) {
        [self.yearArray addObject:[NSNumber numberWithInt:i]];
    }
    
    SSBWeakSelf weakSelf = self;
    // make a call to the rest client , get the salary cap through the year array for each owner
    [[[SSBManager sharedManager] restClient] getOwnerSalariesWithBlock:^void(NSArray *aSalary, NSArray *tSalary, NSArray *pSalary) {
        weakSelf.aTotalSalaryArray = [aSalary objectAtIndex:0];
        weakSelf.aSalaryRemainingArray = [aSalary objectAtIndex:1];
        weakSelf.tTotalSalaryArray = [tSalary objectAtIndex:0];
        weakSelf.tSalaryRemainingArray = [tSalary objectAtIndex:1];
        weakSelf.pTotalSalaryArray = [pSalary objectAtIndex:0];
        weakSelf.pSalaryRemainingArray = [pSalary objectAtIndex:1];
        
        [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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

