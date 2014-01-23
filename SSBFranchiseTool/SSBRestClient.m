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

- (void)getLineupForOwner:(NSString *)owner andYear:(NSString *)year withBlock:(void (^)(NSString *lineup))block {
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://localhost:8080/ssb-web/rest/owner/getLineup/%@/%@", year, owner];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Response Object: %@", responseObject);
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSString *lineup = [jsonDict objectForKey:@"lineup"];
        
        block(lineup);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
