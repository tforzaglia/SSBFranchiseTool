//
//  SSBRestClient.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSBRestClient : NSObject

- (void)getLineupsForYear:(NSString *)year withBlock:(void (^)(NSArray *lineups))block;

@end