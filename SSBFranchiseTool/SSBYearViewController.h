//
//  SSBYearViewController.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/15/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSBYearViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSPopUpButton *yearSelectionButton;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableColumn *matchNumberColumn;
@property (weak) IBOutlet NSTableColumn *fighterColumn;
@property (weak) IBOutlet NSTableColumn *ownerColumn;

- (IBAction)loadYearData:(id)sender;

@end
