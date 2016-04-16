//
//  Model.h
//  Stations
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, DestinationState) {
    DestinationStateFrom,
    DestinationStateTo
};

@interface Model : NSObject

+ (instancetype)sharedInstance;
- (NSArray *)getStationsType:(DestinationState)state;
- (void)checkAndGetFile;
- (NSArray *)searchForText:(NSString *)searchWord withDestinationState:(DestinationState)state;

@end
