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
@property NSArray *aTotalSalaryArray;
@property NSArray *tTotalSalaryArray;
@property NSArray *pTotalSalaryArray;
@property NSArray *aSalaryRemainingArray;
@property NSArray *tSalaryRemainingArray;
@property NSArray *pSalaryRemainingArray;

@end

@implementation SSBSalaryCapViewController

@synthesize tableView = _tableView;
@synthesize yearColumn = _yearColumn;
@synthesize aColumn = _aColumn;
@synthesize tColumn = _tColumn;
@synthesize pColumn = _pColumn;

@synthesize yearArray = _yearArray;
@synthesize aTotalSalaryArray = _aTotalSalaryArray;
@synthesize tTotalSalaryArray = _tTotalSalaryArray;
@synthesize pTotalSalaryArray = _pTotalSalaryArray;
@synthesize aSalaryRemainingArray = _aSalaryRemainingArray;
@synthesize tSalaryRemainingArray = _tSalaryRemainingArray;
@synthesize pSalaryRemainingArray = _pSalaryRemainingArray;

- (id)init {
    
    return [super initWithNibName:@"SSBSalaryCapView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    _yearArray = [[NSMutableArray alloc] init];
    _aTotalSalaryArray = [[NSArray alloc] init];
    _tTotalSalaryArray = [[NSArray alloc] init];
    _pTotalSalaryArray = [[NSArray alloc] init];
    _aSalaryRemainingArray = [[NSArray alloc] init];
    _tSalaryRemainingArray = [[NSArray alloc] init];
    _pSalaryRemainingArray = [[NSArray alloc] init];
    
    for (int i = 1; i <= NumberOfYears; i++) {
        [_yearArray addObject:[NSNumber numberWithInt:i]];
    }
    
    return [super initWithNibName:@"SSBSalaryCapView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)fillSalaryTable {

    // make a call to the rest client , get the salary cap through the year array for each owner
    SSBRestClient *client = [[SSBRestClient alloc] init];
    [client getOwnerSalariesWithBlock:^void(NSArray *aSalary, NSArray *tSalary, NSArray *pSalary) {
        _aTotalSalaryArray = [aSalary objectAtIndex:0];
        _aSalaryRemainingArray = [aSalary objectAtIndex:1];
        _tTotalSalaryArray = [tSalary objectAtIndex:0];
        _tSalaryRemainingArray = [tSalary objectAtIndex:1];
        _pTotalSalaryArray = [pSalary objectAtIndex:0];
        _pSalaryRemainingArray = [pSalary objectAtIndex:1];
        
        [_tableView performSelectorOnMainThread:@selector( reloadData ) withObject:nil waitUntilDone:NO];
    }];
    
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    
    NSInteger count = 0;
    if (_pSalaryRemainingArray) {
        count = [_pSalaryRemainingArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableColumn == _yearColumn) {
        return [_yearArray objectAtIndex:row];
    }
    else if (tableColumn == _aColumn) {
        float total = [[_aTotalSalaryArray objectAtIndex:row] floatValue];
        float remaining = [[_aSalaryRemainingArray objectAtIndex:row] floatValue];
        float used = total - remaining;
        
        return [NSString stringWithFormat:@"%f / %f", used, total];
    }
    else if (tableColumn == _tColumn) {
        float total = [[_tTotalSalaryArray objectAtIndex:row] floatValue];
        float remaining = [[_tSalaryRemainingArray objectAtIndex:row] floatValue];
        float used = total - remaining;
        
        return [NSString stringWithFormat:@"%f / %f", used, total];
    }
    else if (tableColumn == _pColumn) {
        float total = [[_pTotalSalaryArray objectAtIndex:row] floatValue];
        float remaining = [[_pSalaryRemainingArray objectAtIndex:row] floatValue];
        float used = total - remaining;
        
        return [NSString stringWithFormat:@"%f / %f", used, total];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    
    [tv reloadData];
}

@end

