//
//  SSBRestClient.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBRestClient.h"
#import "AFHTTPRequestOperationManager.h"
#import "SSBFighter.h"
#import "SSBYear.h"

@implementation SSBRestClient

#pragma mark Getter Rest Calls

- (void)getLineupsForYear:(NSString *)year withBlock:(void (^)(NSArray *lineups))block {
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://localhost:8080/ssb-web/rest/owner/getLineup/%@", year];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSString *aLineup = [jsonDict objectForKey:@"alineup"];
        NSString *tLineup = [jsonDict objectForKey:@"tlineup"];
        NSString *pLineup = [jsonDict objectForKey:@"plineup"];
        
        NSMutableArray *mutableLineups = [[NSMutableArray alloc] init];
        [mutableLineups addObject:aLineup];
        [mutableLineups addObject:tLineup];
        [mutableLineups addObject:pLineup];
        
        NSArray *lineups = [mutableLineups copy];
        
        block(lineups);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getOwnerSalariesWithBlock:(void (^)(NSArray *, NSArray *, NSArray *))block {
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://localhost:8080/ssb-web/rest/owner/getAllSalary"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSArray *aTotalSalary = [jsonDict objectForKey:@"aTotalSalary"];
        NSArray *aSalaryRemaining = [jsonDict objectForKey:@"aSalaryRemaining"];
        NSArray *tTotalSalary = [jsonDict objectForKey:@"tTotalSalary"];
        NSArray *tSalaryRemaining = [jsonDict objectForKey:@"tSalaryRemaining"];
        NSArray *pTotalSalary = [jsonDict objectForKey:@"pTotalSalary"];
        NSArray *pSalaryRemaining = [jsonDict objectForKey:@"pSalaryRemaining"];
        
        NSArray *aArray = [[NSArray alloc] initWithObjects:aTotalSalary, aSalaryRemaining, nil];
        NSArray *tArray = [[NSArray alloc] initWithObjects:tTotalSalary, tSalaryRemaining, nil];
        NSArray *pArray = [[NSArray alloc] initWithObjects:pTotalSalary, pSalaryRemaining, nil];
        
        block(aArray, tArray, pArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getFighterInfoByName:(NSString *)name withBlock:(void (^)(SSBFighter *fighter))block {
    
    NSString *encodedName = [name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSString *url = [[NSString alloc] initWithFormat:@"http://localhost:8080/ssb-web/rest/fighter/get/%@", encodedName];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        SSBFighter *fighter = [[SSBFighter alloc] init];
        [fighter setName:[jsonDict objectForKey:@"name"]];
        [fighter setCareerWins:[[jsonDict objectForKey:@"careerWins"] integerValue]];
        [fighter setMatchesPlayed:[[jsonDict objectForKey:@"matchesPlayed"] integerValue]];
        [fighter setIsRestricted:[jsonDict objectForKey:@"isRestricted"]];
        [fighter setRestrictedYear:[[jsonDict objectForKey:@"restrictedYear"] integerValue]];
        [fighter setOwnersThroughTheYears:[jsonDict objectForKey:@"ownersThroughTheYears"]];
        [fighter setWinsThroughTheYears:[jsonDict objectForKey:@"winsThroughTheYears"]];
        [fighter setSalariesThroughTheYears:[jsonDict objectForKey:@"salariesThroughTheYears"]];
        
        block(fighter);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getMatchResultsForYear:(NSString *)year withBlock:(void (^)(SSBYear *))block {
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://localhost:8080/ssb-web/rest/year/get/%@", year];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        SSBYear *yearObject = [[SSBYear alloc] init];
        [yearObject setMatches:[jsonDict objectForKey:@"matches"]];
        [yearObject setFighterWinners:[jsonDict objectForKey:@"fighterWinners"]];
        [yearObject setOwnerWinners:[jsonDict objectForKey:@"ownerWinners"]];
        
        block(yearObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark Update Rest Calls

- (void)updateSalary:(NSString *)salary forFighter:(NSString *)fighterName andYear:(NSString *)year withBlock:(void (^)(NSError *))block {
    
    NSString *encodedName = [fighterName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *url = [[NSString alloc] initWithFormat:@"http://localhost:8080/ssb-web/rest/fighter/updateSalary/%@/%@/%@/", year, encodedName, salary];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response Object: %@", responseObject);
        block(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(error);
        NSLog(@"Error: %@", error);
    }];
}

@end
