//
//  SSBMainWindowController.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/5/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBMainWindowController.h"
#import "SSBRulesViewController.h"

@implementation SSBMainWindowController

@synthesize rulesView = _rulesView;

- (id)init {
    
    self = [super initWithWindowNibName:@"SSBMainWindow"];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad {
    
    [super windowDidLoad];
    
    [_rulesView addSubview:[[[SSBRulesViewController alloc] init] view]];
    
}

@end
