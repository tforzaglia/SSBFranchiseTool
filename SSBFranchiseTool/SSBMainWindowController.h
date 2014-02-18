//
//  SSBMainWindowController.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/11/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SSBRulesViewController;
@class SSBSalaryCapViewController;
@class SSBLineupsViewController;
@class SSBFighterSalaryViewController;
@class SSBYearViewController;

@interface SSBMainWindowController : NSWindowController

@property (weak) IBOutlet NSToolbar *toolbar;
@property (weak) IBOutlet NSToolbarItem *rulesToolbarItem;
@property (weak) IBOutlet NSToolbarItem *salaryToolbarItem;
@property (weak) IBOutlet NSToolbarItem *ownerSalaryCapToolbarItem;
@property (weak) IBOutlet NSToolbarItem *lineupsToolbarItem;
@property (weak) IBOutlet NSToolbarItem *yearsToolbarItem;

@property (weak) IBOutlet SSBRulesViewController *rulesViewController;
@property (weak) IBOutlet SSBFighterSalaryViewController *fighterSalaryViewController;
@property (weak) IBOutlet SSBSalaryCapViewController *salaryCapViewController;
@property (weak) IBOutlet SSBLineupsViewController *lineupsViewController;
@property (weak) IBOutlet SSBYearViewController *yearViewController;

- (IBAction)showRulesView:(id)sender;
- (IBAction)showFighterSalaryView:(id)sender;
- (IBAction)showSalaryCapView:(id)sender;
- (IBAction)showLineupsView:(id)sender;
- (IBAction)showYearView:(id)sender;

@end