//
//  TownStation.m
//  Stations
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "TownStation.h"

@implementation TownStation

-(instancetype)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if(self){
        self.name = [NSString stringWithFormat:@"%@ %@",[info objectForKey:@"countryTitle"], [info objectForKey:@"cityTitle"]];
        self.stations = [info objectForKey:@"stations"];
    }
    return self;
}

@end
