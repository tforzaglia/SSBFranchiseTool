//
//  SSBFighterSalaryViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/1/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBFighterSalaryViewController.h"
#import "SSBConstants.h"
#import "SSBRestClient.h"

@interface SSBFighterSalaryViewController ()

@property NSMutableArray *fighterNameArray;
@property NSMutableArray *fighterObjectArray;
@property NSString *yearNumber;

- (SSBFighter *)searchArrayForFighterByName:(NSString *)name;
    
@end

@implementation SSBFighterSalaryViewController

@synthesize yearSelectionButton = _yearSelectionButton;
@synthesize tableView = _tableView;
@synthesize fighterColumn = _fighterColumn;
@synthesize ownerColumn = _ownerColumn;
@synthesize salaryColumn = _salaryColumn;

@synthesize fighterNameArray = _fighterNameArray;
@synthesize fighterObjectArray = _fighterObjectArray;
@synthesize yearNumber = _yearNumber;

- (id)init {
    
    return [super initWithNibName:@"SSBFighterSalaryView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];

    _fighterNameArray = [[NSMutableArray alloc] initWithObjects:@"Bowser", @"Captain Falcon", @"Diddy Kong", @"Donkey Kong", @"Falco", @"Fox", @"Ganondorf", @"Ice Climbers", @"Ike", @"Jigglypuff", @"King Dedede", @"Kirby", @"Link" ,
        @"Lucario", @"Lucas", @"Luigi", @"Mario", @"Marth", @"Metaknight", @"Mr Game and Watch", @"Olimar", @"Ness",
        @"Pikachu", @"Pit", @"Pokemon Trainer", @"Peach", @"ROB", @"Samus", @"Snake", @"Sonic", @"Toon Link",
        @"Wario", @"Wolf", @"Yoshi", @"Zelda", nil];
    
    // set to year 1 by default
    _yearNumber = @"1";
    
    _fighterObjectArray = [[NSMutableArray alloc] init];
    SSBRestClient *client = [[SSBRestClient alloc] init];

    // make rest calls for each fighter and get them into separate SSBFighter objects
    for (int i = 0; i < [_fighterNameArray count]; i++) {
        [client getFighterInfoByName:[_fighterNameArray objectAtIndex:i] withBlock:^void(SSBFighter *fighter) {
            [_fighterObjectArray addObject:fighter];
        }];
    }

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

- (IBAction)loadSalaryInfo:(id)sender {
    
    // get the selected year from the pop up button
    NSString *selectedYear = [[_yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
    _yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    // fill the table with different info based on the year
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


- (SSBFighter *)searchArrayForFighterByName:(NSString *)name {
    
    for (SSBFighter *fighter in _fighterObjectArray) {
        if ([name isEqualToString:[fighter name]]) {
            return fighter;
        }
    }
    
    return nil;
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    
    NSInteger count = 0;
    if (_fighterNameArray) {
        count = [_fighterNameArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSInteger year = [_yearNumber integerValue];
    NSString *currentName = [_fighterNameArray objectAtIndex:row];
    SSBFighter *currentFighter =  [self searchArrayForFighterByName:currentName];
    
    if (tableColumn == _fighterColumn) {
        return [_fighterNameArray objectAtIndex:row];
    }
    else if (tableColumn == _ownerColumn) {
        return [[currentFighter ownersThroughTheYears] objectAtIndex:year - 1];
    }
    else if (tableColumn == _salaryColumn) {
        return [[currentFighter salariesThroughTheYears] objectAtIndex:year - 1];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    
    [tv reloadData];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    
    NSString *name = [_fighterNameArray objectAtIndex:[[obj object] selectedRow]];
    NSString *salary =  [[obj.userInfo valueForKey:@"NSFieldEditor"] string];
    
    SSBRestClient *client = [[SSBRestClient alloc] init];
    // determine if the column updated was the salary or owner -- call the appropriate method
    [client updateSalary:salary forFighter:name andYear:_yearNumber withBlock:^void(NSError *error) {
        if (error) {
            [self presentError:error];
        }
        else {
            [_fighterObjectArray removeObject:[self searchArrayForFighterByName:name]];
            [client getFighterInfoByName:name withBlock:^void(SSBFighter *fighter) {
                [_fighterObjectArray addObject:fighter];
            }];
            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

@end
