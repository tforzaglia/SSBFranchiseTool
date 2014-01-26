//
//  SSBMainWindowController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/11/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBMainWindowController.h"
#import "SSBRulesViewController.h"
#import "SSBLineupsViewController.h"
#import "SSBSalaryCapViewController.h"

@interface SSBMainWindowController ()

@end

@implementation SSBMainWindowController

@synthesize rulesToolbarItem = _rulesToolbarItem;
@synthesize salaryToolbarItem = _salaryToolbarItem;
@synthesize ownerSalaryCapToolbarItem = _ownerSalaryCapToolbarItem;
@synthesize lineupsToolbarItem = _lineupsToolbarItem;
@synthesize yearsToolbarItem = _yearsToolbarItem;

@synthesize rulesViewController = _rulesViewController;
@synthesize salaryCapViewController = _salaryCapViewController;
@synthesize lineupsViewController = _lineupsViewController;

- (id)init {
    
    self = [super initWithWindowNibName:@"SSBMainWindow"];
    return self;
}

- (void)windowDidLoad {
    
    [super windowDidLoad];
    [self.window.contentView setAutoresizesSubviews:YES];
    [_rulesToolbarItem setEnabled:YES];
    [_salaryToolbarItem setEnabled:YES];
    [_ownerSalaryCapToolbarItem setEnabled:YES];
    [_lineupsToolbarItem setEnabled:YES];
    [_yearsToolbarItem setEnabled:YES];
    
    [self showRulesView:self];
}

- (IBAction)showRulesView:(id)sender {
    
    self.window.contentView = _rulesViewController.view;
}

- (IBAction)showSalaryCapView:(id)sender {
    
    self.window.contentView = _salaryCapViewController.view;
}

- (IBAction)showLineupsView:(id)sender {
    
    self.window.contentView = _lineupsViewController.view;
}

@end
