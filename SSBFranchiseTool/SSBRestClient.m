//
//  SSBRestClient.m
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import "SSBRestClient.h"
#import "AFHTTPRequestOperationManager.h"

@implementation SSBRestClient

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

@end
