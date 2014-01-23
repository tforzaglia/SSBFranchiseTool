//
//  SSBRestClient.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 1/19/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSBRestClient : NSObject

- (void)getLineupForOwner:(NSString *)owner andYear:(NSString *)year withBlock:(void (^)(NSString *lineup))block;

@end
