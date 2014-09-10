//
//  SSBLineupsViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBLineupsViewController.h"
#import "SSBManager.h"
#import "SSBRestClient.h"

@interface SSBLineupsViewController ()

@property (nonatomic, strong) NSMutableArray *numberArray;
@property (nonatomic, strong) NSMutableArray *aLineupArray;
@property (nonatomic, strong) NSMutableArray *tLineupArray;
@property (nonatomic, strong) NSMutableArray *pLineupArray;

- (IBAction)loadLineup:(id)sender;
- (IBAction)updateLineup:(id)sender;

- (void)fillLineupArraysWithBlankStrings;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNewYearCreatedNotification:)
                                                 name:@"NewYearCreatedNotification"
                                               object:nil];
    
    return [super initWithNibName:@"SSBLineupsView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)awakeFromNib {
    [self.yearSelectionButton removeAllItems];
    NSMutableArray *yearStrings = [[NSMutableArray alloc] init];
    for (int i = 1; i <= [[SSBManager sharedManager] numberOfYears]; i++) {
        NSString *yearString = [NSString stringWithFormat:@"Year %d", i];
        [yearStrings addObject:yearString];
    }
    
    [self.yearSelectionButton addItemsWithTitles:yearStrings];
}

- (void)receivedNewYearCreatedNotification:(NSNotification *)notification {
    NSString *yearString = [NSString stringWithFormat:@"Year %ld", [[SSBManager sharedManager] numberOfYears]];
    [self.yearSelectionButton addItemWithTitle:yearString];
}

- (IBAction)loadLineup:(id)sender {
    // get the selected year from the pop up button
    NSString *selectedYear = [[self.yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
    NSString *yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    [self.aLineupArray removeAllObjects];
    [self.tLineupArray removeAllObjects];
    [self.pLineupArray removeAllObjects];
    
    [[[SSBManager sharedManager] restClient] getLineupsForYear:yearNumber withBlock:^void(NSArray *lineups) {
        if (![lineups[0] isEqual:[NSNull null]]) {
            self.aLineupArray = [[lineups[0] componentsSeparatedByString:@","] mutableCopy];
            self.tLineupArray = [[lineups[1] componentsSeparatedByString:@","] mutableCopy];
            self.pLineupArray = [[lineups[2] componentsSeparatedByString:@","] mutableCopy];
        
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        else {
            [self fillLineupArraysWithBlankStrings];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (IBAction)updateLineup:(id)sender {
    NSString *aLineup = [[self.aLineupArray valueForKey:@"description"] componentsJoinedByString:@","];
    NSString *tLineup = [[self.tLineupArray valueForKey:@"description"] componentsJoinedByString:@","];
    NSString *pLineup = [[self.pLineupArray valueForKey:@"description"] componentsJoinedByString:@","];
    
    // get the selected year from the pop up button
    NSString *selectedYear = [[self.yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
    NSString *yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    [[[SSBManager sharedManager] restClient] updateLineup:aLineup forOwner:@"A" andYear:yearNumber withBlock:^void(NSError *error) {
        if (error) {
            [self presentError:error];
        }
        else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
    [[[SSBManager sharedManager] restClient] updateLineup:tLineup forOwner:@"T" andYear:yearNumber withBlock:^void(NSError *error) {
        if (error) {
            [self presentError:error];
        }
        else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
    [[[SSBManager sharedManager] restClient] updateLineup:pLineup forOwner:@"P" andYear:yearNumber withBlock:^void(NSError *error) {
        if (error) {
            [self presentError:error];
        }
        else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)fillLineupArraysWithBlankStrings {
    for (int i = 0; i < 11; i++) {
        self.aLineupArray[i] = @"";
        self.tLineupArray[i] = @"";
        self.pLineupArray[i] = @"";
    }
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    NSInteger count = 0;
    if (self.numberArray) {
        count = [self.numberArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableColumn == self.numberColumn) {
        return [self.numberArray objectAtIndex:row];
    }
    else if (tableColumn == self.aColumn) {
        if ([self.aLineupArray count] == 0) {
            return @"";
        }
        return self.aLineupArray[row];
    }
    else if (tableColumn == self.tColumn) {
        if ([self.tLineupArray count] == 0) {
            return @"";
        }
        return self.tLineupArray[row];
    }
    else if (tableColumn == self.pColumn) {
        if ([self.pLineupArray count] == 0) {
            return @"";
        }
        return self.pLineupArray[row];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    NSString *fighterName =  anObject;
    if (column == self.aColumn) {
        [self.aLineupArray replaceObjectAtIndex:row withObject:fighterName];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    else if (column == self.tColumn) {
        [self.tLineupArray replaceObjectAtIndex:row withObject:fighterName];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    else if (column == self.pColumn) {
        [self.pLineupArray replaceObjectAtIndex:row withObject:fighterName];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    [tv reloadData];
}

@end
