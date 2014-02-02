//
//  SSBFighterSalaryViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/1/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBFighterSalaryViewController.h"
#import "SSBConstants.h"

@interface SSBFighterSalaryViewController ()

@property NSMutableArray *fighterArray;

@end

@implementation SSBFighterSalaryViewController

@synthesize yearSelectionButton = _yearSelectionButton;
@synthesize tableView = _tableView;
@synthesize fighterColumn = _fighterColumn;
@synthesize ownerColumn = _ownerColumn;
@synthesize salaryColumn = _salaryColumn;

@synthesize fighterArray = _fighterArray;

- (id)init {
    
    return [super initWithNibName:@"SSBFighterSalaryView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    _fighterArray = [[NSMutableArray alloc] initWithObjects:@"Bowser", @"Captain Falcon", @"Diddy Kong", @"Donkey Kong", @"Falco", @"Fox", @"Ganondorf", @"Ice Climbers", @"Ike", @"Jigglypuff", @"King Dedede", @"Kirby", @"Link" ,
        @"Lucario", @"Lucas", @"Luigi", @"Mario", @"Marth", @"Metaknight", @"Mr Game and Watch", @"Olimar", @"Ness",
        @"Pikachu", @"Pit", @"Pokemon Trainer", @"Peach", @"ROB", @"Samus", @"Snake", @"Sonic", @"Toon Link",
        @"Wario", @"Wolf", @"Yoshi", @"Zelda", nil];
    return [super initWithNibName:@"SSBFighterSalaryView" bundle:[NSBundle bundleForClass:[self class]]];
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

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    
    NSInteger count = 0;
    if (_fighterArray) {
        count = [_fighterArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableColumn == _fighterColumn) {
        return [_fighterArray objectAtIndex:row];
    }
    else if (tableColumn == _ownerColumn) {
        //return [_aLineupArray objectAtIndex:row];
        return @"";
    }
    else if (tableColumn == _salaryColumn) {
        //return [_tLineupArray objectAtIndex:row];
        return @"";
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    
    [tv reloadData];
}


@end
