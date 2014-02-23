//
//  SSBYearViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/15/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBYearViewController.h"
#import "SSBConstants.h"
#import "SSBRestClient.h"

@interface SSBYearViewController ()

@property NSArray *matchNumbers;
@property NSArray *fighterWinners;
@property NSArray *ownerWinners;

@end

@implementation SSBYearViewController

@synthesize yearSelectionButton = _yearSelectionButton;
@synthesize tableView = _tableView;
@synthesize matchNumberColumn = _matchNumberColumn;
@synthesize fighterColumn = _fighterColumn;
@synthesize ownerColumn = _ownerColumn;

@synthesize matchNumbers = _matchNumbers;
@synthesize fighterWinners = _fighterWinners;
@synthesize ownerWinners = _ownerWinners;

- (id)init {
    
    return [super initWithNibName:@"SSBYearView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    _matchNumbers = [[NSArray alloc] init];
    _fighterWinners = [[NSArray alloc] init];
    _ownerWinners = [[NSArray alloc] init];
    
    return [super initWithNibName:@"SSBYearView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)awakeFromNib {
    
    [_yearSelectionButton removeAllItems];
    NSMutableArray *yearStrings = [[NSMutableArray alloc] init];
    for (int i = 1; i <= NumberOfYears; i++) {
        NSString *yearString = [NSString stringWithFormat:@"Year %d", i];
        [yearStrings addObject:yearString];
    }
    
    [_yearSelectionButton addItemsWithTitles:yearStrings];
}

- (IBAction)loadYearData:(id)sender {
    
    // get the selected year from the pop up button
    NSString *selectedYear = [[_yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
    NSString *yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    SSBRestClient *client = [[SSBRestClient alloc] init];
    [client getMatchResultsForYear:yearNumber withBlock:^void(SSBYear *yearObject) {
        _matchNumbers = [yearObject matches];
        _fighterWinners = [yearObject fighterWinners];
        _ownerWinners = [yearObject ownerWinners];
        
        [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    
    NSInteger count = 0;
    if (_matchNumbers) {
        count = [_matchNumbers count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableColumn == _matchNumberColumn) {
        return [_matchNumbers objectAtIndex:row];
    }
    else if (tableColumn == _fighterColumn) {
        return [_fighterWinners objectAtIndex:row];
    }
    else if (tableColumn == _ownerColumn) {
        return [_ownerWinners objectAtIndex:row];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    
    [tv reloadData];
}

//have a method that takes  2 params that represent a range to search in - start match and end match (ex 1 and 11)
    // then it will tally the number times each owner (A, T, P) appears in that range
    // it will then determine who gets postive, negative, no change in salary 


@end
