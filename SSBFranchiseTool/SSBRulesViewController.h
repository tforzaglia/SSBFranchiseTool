//
//  SSBRulesViewController.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/10/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSBRulesViewController : NSViewController <NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableColumn *winColumn;
@property (weak) IBOutlet NSTableColumn *salaryChangeColumn;
@property (strong) NSMutableArray *winRowValues;
@property (strong) NSMutableArray *salaryChangeRowValues;

@end
