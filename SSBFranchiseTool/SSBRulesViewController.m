//
//  SSBRulesViewController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/10/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBRulesViewController.h"

@interface SSBRulesViewController()

@property (strong) NSMutableArray *winRowValues;
@property (strong) NSMutableArray *salaryChangeRowValues;

@end

@implementation SSBRulesViewController

@synthesize tableView = _tableView;
@synthesize winColumn = _winColumn;
@synthesize salaryChangeColumn = _salaryChangeColumn;
@synthesize winRowValues = _winRowValues;
@synthesize salaryChangeRowValues = _salaryChangeRowValues;

- (id)init {
    
    _winRowValues = [[NSMutableArray alloc] initWithObjects:@"0", @"1-2", @"3-4", @"5-6", @"7+", nil];
    _salaryChangeRowValues = [[NSMutableArray alloc] initWithObjects:@"-1M", @"-0.5M", @"0", @"+0.5M", @"+1M", nil];

    return [super initWithNibName:@"SSBRulesView" bundle:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];
    
    _winRowValues = [[NSMutableArray alloc] initWithObjects:@"0", @"1-2", @"3-4", @"5-6", @"7+", nil];
    _salaryChangeRowValues = [[NSMutableArray alloc] initWithObjects:@"-1M", @"-0.5M", @"0", @"+0.5M", @"+1M", nil];
    
    return [super initWithNibName:@"SSBRulesView" bundle:nil];
    //return [super initWithNibName:@"SSBRulesView" bundle:[NSBundle bundleForClass:[self class]]];
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {

    NSInteger count = 0;
    if (_winRowValues) {
        count = [_winRowValues count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableColumn == _winColumn) {
        return [_winRowValues objectAtIndex:row];
    }
    else if (tableColumn == _salaryChangeColumn) {
        return [_salaryChangeRowValues objectAtIndex:row];
    }
    else
        return @"";
}

- (void)tableView:(NSTableView *)tv setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    [tv reloadData];
}



@end
