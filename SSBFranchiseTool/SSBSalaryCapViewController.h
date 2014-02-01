//
//  SSBSalaryCapViewController.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/25/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSBSalaryCapViewController : NSViewController <NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableColumn *yearColumn;
@property (weak) IBOutlet NSTableColumn *aColumn;
@property (weak) IBOutlet NSTableColumn *tColumn;
@property (weak) IBOutlet NSTableColumn *pColumn;

- (void)fillSalaryTable;

@end
