//
//  SSBYearViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/15/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBConstants.h"
#import "SSBRestClient.h"
#import "SSBYearViewController.h"

@interface SSBYearViewController ()

@property NSMutableArray *matchNumbers;
@property NSMutableArray *fighterWinners;
@property NSMutableArray *ownerWinners;
@property NSString *yearNumber;

@end

@implementation SSBYearViewController

- (id)init {
    return [super initWithNibName:@"SSBYearView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.matchNumbers = [[NSMutableArray alloc] init];
    self.fighterWinners = [[NSMutableArray alloc] init];
    self.ownerWinners = [[NSMutableArray alloc] init];
    
    self.yearNumber = @"1";
    
    return [super initWithNibName:@"SSBYearView" bundle:[NSBundle bundleForClass:[self class]]];
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

- (IBAction)loadYearData:(id)sender {
    // get the selected year from the pop up button
    NSString *selectedYear = [[self.yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
   self.yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    SSBRestClient *client = [[SSBRestClient alloc] init];
    [client getMatchResultsForYear:self.yearNumber withBlock:^void(SSBYear *yearObject) {
        self.matchNumbers = [[yearObject matches] mutableCopy];
        self.fighterWinners = [[yearObject fighterWinners] mutableCopy];
        self.ownerWinners = [[yearObject ownerWinners] mutableCopy];
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    NSInteger count = 0;
    if (self.matchNumbers) {
        count = [self.matchNumbers count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableColumn == self.matchNumberColumn) {
        return [self.matchNumbers objectAtIndex:row];
    }
    else if (tableColumn == self.fighterColumn) {
        return [self.fighterWinners objectAtIndex:row];
    }
    else if (tableColumn == self.ownerColumn) {
        return [self.ownerWinners objectAtIndex:row];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    SSBRestClient *client = [[SSBRestClient alloc] init];

    // edit was made in the fighter column
    if (column == self.fighterColumn) {
        NSString *fighterName =  anObject;
        [client updateWinningFIghter:fighterName forMatch:row + 1 andYear:self.yearNumber withBlock:^void(NSError *error) {
            if (error) {
                [self presentError:error];
            }
            else {
                [client getMatchResultsForYear:self.yearNumber withBlock:^void(SSBYear *yearObject) {
                    self.matchNumbers = [[yearObject matches] mutableCopy];
                    self.fighterWinners = [[yearObject fighterWinners] mutableCopy];
                    self.ownerWinners = [[yearObject ownerWinners] mutableCopy];
                    
                    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }];
            }
        }];
    }
    // edit was made in the owner column
    else if (column == self.ownerColumn) {
        NSString *ownerName =  anObject;
        [client updateWinningOwner:ownerName forMatch:row + 1 andYear:self.yearNumber withBlock:^void(NSError *error) {
            if (error) {
                [self presentError:error];
            }
            else {
                [client getMatchResultsForYear:self.yearNumber withBlock:^void(SSBYear *yearObject) {
                    self.matchNumbers = [[yearObject matches] mutableCopy];
                    self.fighterWinners = [[yearObject fighterWinners] mutableCopy];
                    self.ownerWinners = [[yearObject ownerWinners] mutableCopy];
                    
                    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }];
            }
        }];
    }
    
    [tv reloadData];
}

//have a method that takes  2 params that represent a range to search in - start match and end match (ex 1 and 11)
    // then it will tally the number times each owner (A, T, P) appears in that range
    // it will then determine who gets postive, negative, no change in salary 


@end
