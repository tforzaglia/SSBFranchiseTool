//
//  SSBFighter.h
//  SSBFranchiseTool
//
//  Created by Thomas Forzaglia on 2/2/14.
//  Copyright (c) 2014 Thomas Forzaglia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSBFighter : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger careerWins;
@property (nonatomic) NSInteger matchesPlayed;
@property (nonatomic, copy) NSString *isRestricted;
@property (nonatomic) NSInteger restrictedYear;
@property (nonatomic, copy) NSArray *ownersThroughTheYears;
@property (nonatomic, copy) NSArray *winsThroughTheYears;
@property (nonatomic, copy) NSArray *salariesThroughTheYears;

@end
