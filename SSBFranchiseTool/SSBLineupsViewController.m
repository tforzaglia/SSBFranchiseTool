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

@interface SSBLineupsViewController ()

@end

@implementation SSBLineupsViewController

@synthesize yearSelectionButton = _yearSelectionButton;
@synthesize tableView = _tableView;
@synthesize numberColumn = _numberColumn;
@synthesize aColumn = _aColumn;
@synthesize pColumn = _pColumn;
@synthesize tColumn = _tColumn;

- (id)init {
    
    return [super initWithNibName:@"SSBLineupsView" bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
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
    NSMutableArray *aLineup = [[NSMutableArray alloc] init];
    
    SSBRestClient *client = [[SSBRestClient alloc] init];
    [client getLineupsWithBlock:^void(NSString *owner, NSInteger year) {}];
    

}


@end
