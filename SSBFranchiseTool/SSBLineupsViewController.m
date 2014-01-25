//
//  SSBLineupsViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBLineupsViewController.h"
#import "SSBConstants.h"
#import "SSBRestClient.h"
#import "SSBConstants.h"

@interface SSBLineupsViewController ()

@property NSMutableArray *numebrArray;
@property NSMutableArray *aLineupArray;
@property NSMutableArray *tLineupArray;
@property NSMutableArray *pLineupArray;

@end

@implementation SSBLineupsViewController

@synthesize yearSelectionButton = _yearSelectionButton;
@synthesize tableView = _tableView;
@synthesize numberColumn = _numberColumn;
@synthesize aColumn = _aColumn;
@synthesize pColumn = _pColumn;
@synthesize tColumn = _tColumn;

@synthesize numebrArray = _numberArray;
@synthesize aLineupArray = _aLineupArray;
@synthesize tLineupArray = _tLineupArray;
@synthesize pLineupArray = _pLineupArray;

- (id)init {
    
    return [super initWithNibName:@"SSBLineupsView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    _numberArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];
    _aLineupArray = [[NSMutableArray alloc] init];
    _tLineupArray = [[NSMutableArray alloc] init];
    _pLineupArray = [[NSMutableArray alloc] init];
    return [super initWithNibName:@"SSBLineupsView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)awakeFromNib {
    
    [_yearSelectionButton removeAllItems];
    NSMutableArray *yearStrings = [[NSMutableArray alloc] init];
    for (int i = 1; i <= NumberOfYears; i++) {
        NSString *str = [NSString stringWithFormat:@"Year %d", i];
        [yearStrings addObject:str];
    }
    
    [_yearSelectionButton addItemsWithTitles:yearStrings];
}

- (IBAction)loadLineup:(id)sender {
    
    // get the selected year from the pop up button
    NSString *selectedYear = [[_yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
    NSString *yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    SSBRestClient *client = [[SSBRestClient alloc] init];
    [client getLineupsForYear:yearNumber withBlock:^void(NSArray *lineups) {
        _aLineupArray = [[[lineups objectAtIndex:0] componentsSeparatedByString:@","] mutableCopy];
        _tLineupArray = [[[lineups objectAtIndex:1] componentsSeparatedByString:@","] mutableCopy];
        _pLineupArray = [[[lineups objectAtIndex:2] componentsSeparatedByString:@","] mutableCopy];
        
        [_tableView performSelectorOnMainThread:@selector( reloadData ) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    
    NSInteger count = 0;
    if (_pLineupArray) {
        count = [_pLineupArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableColumn == _numberColumn) {
        return [_numberArray objectAtIndex:row];
    }
    else if (tableColumn == _aColumn) {
        return [_aLineupArray objectAtIndex:row];
    }
    else if (tableColumn == _tColumn) {
        return [_tLineupArray objectAtIndex:row];
    }
    else if (tableColumn == _pColumn) {
        return [_pLineupArray objectAtIndex:row];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    
    [tv reloadData];
}

@end
