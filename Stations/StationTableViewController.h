//
//  StationTableViewController.h
//  Stations
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


@protocol StationTableViewControllerDelegate <NSObject>
- (void)passItem:(NSString *)item andState:(DestinationState)state;
@end

@interface StationTableViewController : UITableViewController

@property (nonatomic, weak) id <StationTableViewControllerDelegate> delegate;
@property (nonatomic) DestinationState destinationState;

@end
