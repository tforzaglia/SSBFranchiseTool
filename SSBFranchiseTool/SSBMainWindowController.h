//
//  SSBMainWindowController.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/11/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SSBRulesViewController;
@class SSBLineupsViewController;

@interface SSBMainWindowController : NSWindowController

@property (weak) IBOutlet NSToolbar *toolbar;
@property (weak) IBOutlet NSToolbarItem *rulesToolbarItem;
@property (weak) IBOutlet NSToolbarItem *salaryToolbarItem;
@property (weak) IBOutlet NSToolbarItem *ownerSalaryCapToolbarItem;
@property (weak) IBOutlet NSToolbarItem *lineupsToolbarItem;
@property (weak) IBOutlet NSToolbarItem *yearsToolbarItem;

@property (weak) IBOutlet SSBRulesViewController *rulesViewController;
@property (weak) IBOutlet SSBLineupsViewController *lineupsViewController;

- (IBAction)showRulesView:(id)sender;
- (IBAction)showLineupsView:(id)sender;

@end