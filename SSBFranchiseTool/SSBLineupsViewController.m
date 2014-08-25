//
//  SSBLineupsViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBConstants.h"
#import "SSBLineupsViewController.h"
#import "SSBRestClient.h"

@interface SSBLineupsViewController ()

@property NSMutableArray *numberArray;
@property NSMutableArray *aLineupArray;
@property NSMutableArray *tLineupArray;
@property NSMutableArray *pLineupArray;

@end

@implementation SSBLineupsViewController

- (id)init {
    return [super initWithNibName:@"SSBLineupsView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.numberArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];
    self.aLineupArray = [[NSMutableArray alloc] init];
    self.tLineupArray = [[NSMutableArray alloc] init];
    self.pLineupArray = [[NSMutableArray alloc] init];
    
    return [super initWithNibName:@"SSBLineupsView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)awakeFromNib {
    [self.yearSelectionButton removeAllItems];
    NSMutableArray *yearStrings = [[NSMutableArray alloc] init];
    for (int i = 1; i <= SSBNumberOfYears; i++) {
        NSString *yearString = [NSString stringWithFormat:@"Year %d", i];
        [yearStrings addObject:yearString];
    }
    
    [self.yearSelectionButton addItemsWithTitles:yearStrings];
}

- (IBAction)loadLineup:(id)sender {
    // get the selected year from the pop up button
    NSString *selectedYear = [[self.yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
    NSString *yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    SSBRestClient *client = [[SSBRestClient alloc] init];
    [client getLineupsForYear:yearNumber withBlock:^void(NSArray *lineups) {
        self.aLineupArray = [[[lineups objectAtIndex:0] componentsSeparatedByString:@","] mutableCopy];
        self.tLineupArray = [[[lineups objectAtIndex:1] componentsSeparatedByString:@","] mutableCopy];
        self.pLineupArray = [[[lineups objectAtIndex:2] componentsSeparatedByString:@","] mutableCopy];
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    NSInteger count = 0;
    if (self.pLineupArray) {
        count = [self.pLineupArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableColumn == self.numberColumn) {
        return [self.numberArray objectAtIndex:row];
    }
    else if (tableColumn == self.aColumn) {
        return [self.aLineupArray objectAtIndex:row];
    }
    else if (tableColumn == self.tColumn) {
        return [self.tLineupArray objectAtIndex:row];
    }
    else if (tableColumn == self.pColumn) {
        return [self.pLineupArray objectAtIndex:row];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    [tv reloadData];
}

@end
