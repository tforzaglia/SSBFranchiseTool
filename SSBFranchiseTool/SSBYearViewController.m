//
//  SSBYearViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/15/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBMacros.h"
#import "SSBManager.h"
#import "SSBRestClient.h"
#import "SSBYearViewController.h"

@interface SSBYearViewController ()

@property (nonatomic, strong) NSMutableArray *matchNumbers;
@property (nonatomic, strong) NSMutableArray *fighterWinners;
@property (nonatomic, strong) NSMutableArray *ownerWinners;
@property (nonatomic, strong) NSString *yearNumber;

@end

@implementation SSBYearViewController

#pragma mark Initialization Methods

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
    for (int i = 1; i <= [[SSBManager sharedManager] numberOfYears]; i++) {
        NSString *yearString = [NSString stringWithFormat:@"Year %d", i];
        [yearStrings addObject:yearString];
    }
    
    [self.yearSelectionButton addItemsWithTitles:yearStrings];
}

#pragma mark IBAction methods

- (IBAction)loadYearData:(id)sender {
    // get the selected year from the pop up button
    NSString *selectedYear = [[self.yearSelectionButton selectedItem] title];
    
    // remove the Year text to get the number to pass to the web service
   self.yearNumber = [selectedYear stringByReplacingOccurrencesOfString:@"Year " withString:@""];
    
    SSBWeakSelf weakSelf = self;
    [[[SSBManager sharedManager] restClient] getMatchResultsForYear:self.yearNumber withBlock:^void(SSBYear *yearObject) {
        weakSelf.matchNumbers = [[yearObject matches] mutableCopy];
        weakSelf.fighterWinners = [[yearObject fighterWinners] mutableCopy];
        weakSelf.ownerWinners = [[yearObject ownerWinners] mutableCopy];
        
        [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (IBAction)createNewYear:(id)sender {
    SSBWeakSelf weakSelf = self;
    NSInteger numberOfYears = [[SSBManager sharedManager] numberOfYears];
    [[SSBManager sharedManager] setNumberOfYears:numberOfYears + 1];
    [[[SSBManager sharedManager] restClient] createNewYear:numberOfYears + 1 withBlock:^void(NSError *error) {
        if (error) {
            [weakSelf presentError:error];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewYearCreatedNotification" object:weakSelf];
            
            NSString *yearString = [NSString stringWithFormat:@"Year %ld", [[SSBManager sharedManager] numberOfYears]];
            [weakSelf.yearSelectionButton addItemWithTitle:yearString];
        }
    }];
}

#pragma mark Helper Methods

//have a method that takes  2 params that represent a range to search in - start match and end match (ex 1 and 11)
// then it will tally the number times each owner (A, T, P) appears in that range
// it will then determine who gets postive, negative, no change in salary

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
    SSBWeakSelf weakSelf = self;
    
    // edit was made in the fighter column
    if (column == self.fighterColumn) {
        NSString *fighterName =  anObject;
        [[[SSBManager sharedManager] restClient] updateWinningFIghter:fighterName forMatch:row + 1 andYear:self.yearNumber withBlock:^void(NSError *error) {
            if (error) {
                [weakSelf presentError:error];
            }
            else {
                [[[SSBManager sharedManager] restClient] getMatchResultsForYear:weakSelf.yearNumber withBlock:^void(SSBYear *yearObject) {
                    weakSelf.matchNumbers = [[yearObject matches] mutableCopy];
                    weakSelf.fighterWinners = [[yearObject fighterWinners] mutableCopy];
                    weakSelf.ownerWinners = [[yearObject ownerWinners] mutableCopy];
                    
                    [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }];
            }
        }];
    }
    // edit was made in the owner column
    else if (column == self.ownerColumn) {
        NSString *ownerName =  anObject;
        [[[SSBManager sharedManager] restClient] updateWinningOwner:ownerName forMatch:row + 1 andYear:weakSelf.yearNumber withBlock:^void(NSError *error) {
            if (error) {
                [weakSelf presentError:error];
            }
            else {
                [[[SSBManager sharedManager] restClient] getMatchResultsForYear:weakSelf.yearNumber withBlock:^void(SSBYear *yearObject) {
                    weakSelf.matchNumbers = [[yearObject matches] mutableCopy];
                    weakSelf.fighterWinners = [[yearObject fighterWinners] mutableCopy];
                    weakSelf.ownerWinners = [[yearObject ownerWinners] mutableCopy];
                    
                    [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }];
            }
        }];
    }
    
    [tv reloadData];
}

@end
