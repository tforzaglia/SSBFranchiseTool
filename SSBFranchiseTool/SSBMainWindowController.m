//
//  SSBMainWindowController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/11/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBFighterSalaryViewController.h"
#import "SSBLineupsViewController.h"
#import "SSBMainWindowController.h"
#import "SSBRulesViewController.h"
#import "SSBSalaryCapViewController.h"
#import "SSBYearViewController.h"

@implementation SSBMainWindowController

- (id)init {
    self = [super initWithWindowNibName:@"SSBMainWindow"];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window.contentView setAutoresizesSubviews:YES];
    [self.rulesToolbarItem setEnabled:YES];
    [self.salaryToolbarItem setEnabled:YES];
    [self.ownerSalaryCapToolbarItem setEnabled:YES];
    [self.lineupsToolbarItem setEnabled:YES];
    [self.yearsToolbarItem setEnabled:YES];
    [self showRulesView:self];
}

- (IBAction)showRulesView:(id)sender {
    self.window.contentView = self.rulesViewController.view;
}

- (IBAction)showFighterSalaryView:(id)sender {
    self.window.contentView = self.fighterSalaryViewController.view;
}

- (IBAction)showSalaryCapView:(id)sender {
    [self.salaryCapViewController fillSalaryTable];
    self.window.contentView = self.salaryCapViewController.view;
}

- (IBAction)showLineupsView:(id)sender {
    self.window.contentView = self.lineupsViewController.view;
}

- (IBAction)showYearView:(id)sender {
    self.window.contentView = self.yearViewController.view;
}

@end
