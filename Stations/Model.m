//
//  Model.m
//  Stations
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "Model.h"
#import "TownStation.h"

@interface Model ()

@property (nonatomic, strong) NSDictionary *allData;
@property (nonatomic, strong) NSArray *stationsFrom;
@property (nonatomic, strong) NSArray *stationsTo;

@end

@implementation Model

+ (instancetype)sharedInstance {
    
    static dispatch_once_t pred;
    static Model *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[Model alloc] init];
        shared.allData = @{};
    });
    
    return shared;
}


- (NSArray *)getStationsType:(DestinationState)state{
    NSArray *result;
    if(state){
        result = self.stationsTo;
    } else {
        result = self.stationsFrom;
    }
    return result;
}

-(void)checkAndGetFile{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"allStations" ofType:@"json"];
    NSError *error = nil;
    if (filePath == nil) { // Not: if (error) { ...
        NSLog(@"Error reading file: %@", error.localizedDescription);
        return;
    }
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    if (!jsonData) {
        NSLog(@"File couldn't be read!");
        return;
    }
    self.allData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *from = [self.allData objectForKey:@"citiesFrom"];
    NSMutableArray *stFrom = [NSMutableArray array];
    for(NSDictionary *city in from){
        [stFrom addObject:[[TownStation alloc] initWithInfo:city]];
    }
    self.stationsFrom = stFrom;
    NSArray *to = [self.allData objectForKey:@"citiesTo"];
    NSMutableArray *stTo = [NSMutableArray array];
    for(NSDictionary *city in to){
        [stTo addObject:[[TownStation alloc] initWithInfo:city]];
    }
    self.stationsTo = stTo;
    
}


-(NSArray *)searchForText:(NSString *)searchWord withDestinationState:(DestinationState)state{
    if([searchWord isEqualToString:@""]){
        return [self getStationsType:state];
    }
    
    NSArray *searchIn = @[];
    NSMutableArray *searchResult = [NSMutableArray array];
    if (state) {
        searchIn = self.stationsTo;
    } else {
        searchIn = self.stationsFrom;
    }
    for (TownStation* item in searchIn){
        NSMutableArray *newStations = [NSMutableArray array];
        for (NSDictionary * station in item.stations) {
            if ([[station objectForKey:@"stationTitle"] rangeOfString:searchWord].location != NSNotFound){
                [newStations addObject:station];
            }
        }
        if(newStations.count > 0){ //create new TownStation object for search
            [searchResult addObject:[[TownStation alloc] initWithName:item.name andStation:newStations]];
        }
    }
        return searchResult;

}



@end
