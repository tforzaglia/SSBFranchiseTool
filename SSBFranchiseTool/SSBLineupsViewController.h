//
//  SSBLineupsViewController.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSBLineupsViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSPopUpButton *yearSelectionButton;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableColumn *numberColumn;
@property (weak) IBOutlet NSTableColumn *aColumn;
@property (weak) IBOutlet NSTableColumn *tColumn;
@property (weak) IBOutlet NSTableColumn *pColumn;

- (IBAction)loadLineup:(id)sender;

@end
