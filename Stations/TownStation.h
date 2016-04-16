//
//  TownStation.h
//  Stations
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TownStation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *stations;

-(instancetype)initWithInfo:(NSDictionary *)info;

@end
