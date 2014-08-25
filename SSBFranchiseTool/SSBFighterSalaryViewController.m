//
//  SSBFighterSalaryViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/1/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBConstants.h"
#import "SSBFighterSalaryViewController.h"
#import "SSBRestClient.h"

@interface SSBFighterSalaryViewController ()

@property NSMutableArray *fighterNameArray;
@property NSMutableArray *fighterObjectArray;
@property NSString *yearNumber;

- (SSBFighter *)searchArrayForFighterByName:(NSString *)name;
    
@end

@implementation SSBFighterSalaryViewController

- (id)init {
    return [super initWithNibName:@"SSBFighterSalaryView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.fighterNameArray = [[NSMutableArray alloc] initWithObjects:@"Bowser", @"Captain Falcon", @"Diddy Kong", @"Donkey Kong", @"Falco", @"Fox", @"Ganondorf", @"Ice Climbers", @"Ike", @"Jigglypuff", @"King Dedede", @"Kirby", @"Link" ,
        @"Lucario", @"Lucas", @"Luigi", @"Mario", @"Marth", @"Metaknight", @"Mr Game and Watch", @"Olimar", @"Ness",
        @"Pikachu", @"Pit", @"Pokemon Trainer", @"Peach", @"ROB", @"Samus", @"Snake", @"Sonic", @"Toon Link",
        @"Wario", @"Wolf", @"Yoshi", @"Zelda", nil];
    
    // set to year 1 by default
    self.yearNumber = @"1";
    
    self.fighterObjectArray = [[NSMutableArray alloc] init];
    SSBRestClient *client = [[SSBRestClient alloc] init];

    // make rest calls for each fighter and get them into separate SSBFighter objects
    for (int i = 0; i < [self.fighterNameArray count]; i++) {
        [client getFighterInfoByName:[self.fighterNameArray objectAtIndex:i] withBlock:^void(SSBFighter *fighter) {
            [self.fighterObjectArray addObject:fighter];
        }];
    }

    return [super initWithNibName:@"SSBFighterSalaryView" bundle:[NSBundle bundleForClass:[self class]]];
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

- (IBAction)loadSalaryInfo:(id)sender {
    // get the selected year from the pop up button
    NSString *selectedYear = [[self.yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
    self.yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    // fill the table with different info based on the year
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


- (SSBFighter *)searchArrayForFighterByName:(NSString *)name {
    for (SSBFighter *fighter in self.fighterObjectArray) {
        if ([name isEqualToString:[fighter name]]) {
            return fighter;
        }
    }
    
    return nil;
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    
    NSInteger count = 0;
    if (self.fighterNameArray) {
        count = [self.fighterNameArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSInteger year = [self.yearNumber integerValue];
    NSString *currentName = [self.fighterNameArray objectAtIndex:row];
    SSBFighter *currentFighter =  [self searchArrayForFighterByName:currentName];
    
    if (tableColumn == self.fighterColumn) {
        return [self.fighterNameArray objectAtIndex:row];
    }
    else if (tableColumn == self.ownerColumn) {
        return [[currentFighter ownersThroughTheYears] objectAtIndex:year - 1];
    }
    else if (tableColumn == self.salaryColumn) {
        return [[currentFighter salariesThroughTheYears] objectAtIndex:year - 1];
    }
    else if (tableColumn == self.isRestrictedColumn) {
        return [currentFighter isRestricted];
    }
    else if (tableColumn == self.restrictedYearColumn) {
        return [NSNumber numberWithLong:[currentFighter restrictedYear]];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    NSString *name = [self.fighterNameArray objectAtIndex:row];
    SSBRestClient *client = [[SSBRestClient alloc] init];
    
    // edit was made in the salary column
    if (column == self.salaryColumn) {
        NSString *salary =  anObject;
        [client updateSalary:salary forFighter:name andYear:self.yearNumber withBlock:^void(NSError *error) {
            if (error) {
                [self presentError:error];
            }
            else {
                [self.fighterObjectArray removeObject:[self searchArrayForFighterByName:name]];
                [client getFighterInfoByName:name withBlock:^void(SSBFighter *fighter) {
                    [self.fighterObjectArray addObject:fighter];
                }];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }];
    }
    // edit was made in the owner column
    else if (column == self.ownerColumn) {
        NSString *owner =  anObject;
        [client updateOwner:owner forFighter:name andYear:self.yearNumber withBlock:^void(NSError *error) {
            if (error) {                
                [self presentError:error];
            }
            else {
                [self.fighterObjectArray removeObject:[self searchArrayForFighterByName:name]];
                [client getFighterInfoByName:name withBlock:^void(SSBFighter *fighter) {
                    [self.fighterObjectArray addObject:fighter];
                }];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }];
    }
    // edit was made in the is restricted column
    else if (column == self.isRestrictedColumn) {
        NSString *restrictedStatus = anObject;
        [client updateRestrictedStatus:restrictedStatus forFighter:name withBlock:^void(NSError *error) {
            if (error) {
                [self presentError:error];
            }
            else {
                [self.fighterObjectArray removeObject:[self searchArrayForFighterByName:name]];
                [client getFighterInfoByName:name withBlock:^void(SSBFighter *fighter) {
                    [self.fighterObjectArray addObject:fighter];
                }];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }];
    }
    // edit was made in the restricted year column
    else if (column == self.restrictedYearColumn) {
        NSInteger restrictedYear = [anObject intValue];
        [client updateRestrictedYear:restrictedYear forFighter:name withBlock:^void(NSError *error) {
            if (error) {
                [self presentError:error];
            }
            else {
                [self.fighterObjectArray removeObject:[self searchArrayForFighterByName:name]];
                [client getFighterInfoByName:name withBlock:^void(SSBFighter *fighter) {
                    [self.fighterObjectArray addObject:fighter];
                }];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }];
    }
    
    [tv reloadData];
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    SSBFighter *fighter = [self searchArrayForFighterByName:[self.fighterNameArray objectAtIndex:row]];
    NSTextFieldCell *textFieldCell = (NSTextFieldCell *)cell;
    
    if (tableColumn == self.fighterColumn) {
        switch ([fighter restrictedYear]) {
            case 0:
                [textFieldCell setTextColor:[NSColor blackColor]];
                break;
            case 1:
                [textFieldCell setTextColor:[NSColor redColor]];
                break;
            case 2:
                [textFieldCell setTextColor:[NSColor greenColor]];
                break;
            case 3:
                [textFieldCell setTextColor:[NSColor blueColor]];
                break;
            case 4:
                [textFieldCell setTextColor:[NSColor orangeColor]];
                break;
            default:
                [textFieldCell setTextColor:[NSColor blackColor]];
                break;
        }
    }
}

@end
