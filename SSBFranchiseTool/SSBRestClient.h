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
- (void)getFighterInfoByName:(NSString *)name withBlock:(void (^)(SSBFighter *fighter))block;
- (void)getMatchResultsForYear:(NSString *)year withBlock:(void (^)(SSBYear *yearData))block;

- (void)updateSalary:(NSString *)salary forFighter:(NSString *)fighterName andYear:(NSString *)year withBlock:(void (^)(NSError *))block;
- (void)updateOwner:(NSString *)owner forFighter:(NSString *)fighterName andYear:(NSString *)year withBlock:(void (^)(NSError *))block;
- (void)updateRestrictedStatus:(NSString *)isRestricted forFighter:(NSString *)fighterName withBlock:(void (^)(NSError *))block;
- (void)updateRestrictedYear:(NSInteger)restrictedYear forFighter:(NSString *)fighterName withBlock:(void (^)(NSError *))block;
- (void)updateWinningFIghter:(NSString *)winningFighter forMatch:(NSInteger)matchNumber andYear:(NSString *)year withBlock:(void (^)(NSError *))block;
- (void)updateWinningOwner:(NSString *)winningOwner forMatch:(NSInteger)matchNumber andYear:(NSString *)year withBlock:(void (^)(NSError *))block;

@end
