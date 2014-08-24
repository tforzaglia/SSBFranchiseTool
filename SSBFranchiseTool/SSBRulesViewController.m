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

- (id)init {

    return [super initWithNibName:@"SSBRulesView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];
    
    self.winRowValues = [[NSMutableArray alloc] initWithObjects:@"0", @"1-2", @"3-4", @"5-6", @"7+", nil];
    self.salaryChangeRowValues = [[NSMutableArray alloc] initWithObjects:@"-1M", @"-0.5M", @"0", @"+0.5M", @"+1M", nil];
    
    return [super initWithNibName:@"SSBRulesView" bundle:[NSBundle bundleForClass:[self class]]];
}

#pragma mark NSTableViewDataSource Protocol Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {

    NSInteger count = 0;
    if (self.winRowValues) {
        count = [self.winRowValues count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableColumn == self.winColumn) {
        return [self.winRowValues objectAtIndex:row];
    }
    else if (tableColumn == self.salaryChangeColumn) {
        return [self.salaryChangeRowValues objectAtIndex:row];
    }
    else
        return @"";
}

@end
