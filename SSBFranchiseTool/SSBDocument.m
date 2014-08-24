//
//  SSBDocument.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 12/31/13.
//  Copyright (c) 2013 Thomas Forzaglia. All rights reserved.
//

#import "SSBDocument.h"
#import "SSBMainWindowController.h"

@interface SSBDocument()

@property (nonatomic, strong) SSBMainWindowController *mainWindow;

@end

@implementation SSBDocument

- (id)init {
    self = [super init];
    if (self) {
        self.mainWindow = [[SSBMainWindowController alloc] initWithWindowNibName:@"SSBMainWindow"];
    }
    return self;
}

- (void)makeWindowControllers {
    [self addWindowController:self.mainWindow];
}

- (NSString *)displayName {
    if (![self fileURL]) {
        return @"Super Smash Bros.";
    }
    
    return [super displayName];
}

- (NSString *)windowNibName {
    return @"SSBDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

@end
