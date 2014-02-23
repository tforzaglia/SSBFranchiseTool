//
//  SSBRestClient.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSBFighter.h"
#import "SSBYear.h"

@interface SSBRestClient : NSObject

- (void)getOwnerSalariesWithBlock:(void (^)(NSArray *aSalaries, NSArray *tSalaries, NSArray *pSalaries))block;
- (void)getLineupsForYear:(NSString *)year withBlock:(void (^)(NSArray *lineups))block;
- (void)getFighterInfoByName:(NSString *)name WithBlock:(void (^)(SSBFighter *fighter))block;
- (void)getMatchResultsForYear:(NSString *)year withBlock:(void (^)(SSBYear *yearData))block;

@end
