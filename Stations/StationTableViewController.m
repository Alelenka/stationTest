//
//  StationTableViewController.m
//  Stations
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "StationTableViewController.h"
#import "Model.h"
#import "TownStation.h"

@interface StationTableViewController () <UISearchBarDelegate>
@property (nonatomic, strong) NSArray *tableData;

@end

@implementation StationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.destinationState){
        self.navigationItem.title = @"Станции отправления";
    } else {
        self.navigationItem.title = @"Станции прибытия";
    }
    self.tableData = @[];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.tableData = [[Model sharedInstance] getStationsType:self.destinationState];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TownStation *townSt = [self.tableData objectAtIndex:section];
    NSArray *stations = townSt.stations;
    return [stations count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    TownStation *townSt = [self.tableData objectAtIndex:section];
    return townSt.name;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stationCell" forIndexPath:indexPath];
    TownStation *townSt = [self.tableData objectAtIndex:indexPath.section];
    NSArray *stations = townSt.stations;
    NSDictionary *station = [stations objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[station objectForKey:@"stationTitle"]];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate passItem:cell.textLabel.text andState:self.destinationState];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    TownStation *townSt = [self.tableData objectAtIndex:indexPath.section];
    NSArray *stations = townSt.stations;
    NSDictionary *station = [stations objectAtIndex:indexPath.row];
    [[[UIAlertView alloc] initWithTitle: @"О станции"
                          message: [NSString stringWithFormat: @"%@\n\n %@ %@ %@",[station objectForKey:@"stationTitle"],[station objectForKey:@"cityTitle"],[station objectForKey:@"regionTitle"],[station objectForKey:@"countryTitle"]]
                          delegate: self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
}


@end
