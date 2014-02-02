//
//  SSBFighterSalaryViewController.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/1/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSBFighterSalaryViewController : NSViewController <NSTableViewDelegate>

@property (weak) IBOutlet NSPopUpButton *yearSelectionButton;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableColumn *fighterColumn;
@property (weak) IBOutlet NSTableColumn *ownerColumn;
@property (weak) IBOutlet NSTableColumn *salaryColumn;

- (IBAction)loadSalaryInfo:(id)sender;

@end
