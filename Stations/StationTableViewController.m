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
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSThread *thread;

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
    if(self.tableData.count == 0){
        return 1;
    }
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.tableData.count == 0){
        return 1;
    }
    TownStation *townSt = [self.tableData objectAtIndex:section];
    NSArray *stations = townSt.stations;
    return [stations count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(self.tableData.count == 0){
        return @"";
    }
    TownStation *townSt = [self.tableData objectAtIndex:section];
    return townSt.name;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.tableData.count == 0){
        return 0.0;
    }
    return 30.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.tableData.count == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nothingFound" forIndexPath:indexPath];
        return cell;
    }
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

#pragma mark - UISearchBarDelegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self onCancelSearch:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self onSearchTextChanged:searchText];
}


- (void)onCancelSearch:(id)sender {
    BOOL needResearch = self.searchBar.text.length == 0;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    if (needResearch || self.tableData.count == 0) { //if search or search result empty
        self.tableData = [[NSMutableArray alloc] init];
        [self onSearchTextChanged:nil];
    }
}


- (void)onSearchTextChanged:(id)sender {
//    [self.activityIndicator startAnimating];
    
    [self.thread cancel];
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(search:) object:self.searchBar.text];
    [self.thread start];
}

- (void)search:(NSString *)text {
    NSArray *data = [[NSMutableArray alloc] init];
    data = [[Model sharedInstance] searchForText:text withDestinationState:self.destinationState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableData = data;
        [self.tableView reloadData];
//        [self.activityIndicator stopAnimating];
    });
}

//- (void)keyboardWillShow:(NSTimeInterval)duration keyboardFrame:(NSValue *)keyboardFrame {
//        //    [self.keyboardHelper show];
//    
//    CGRect rect = [keyboardFrame CGRectValue];
//    
//    self.tableBottomConstraint.constant = rect.size.height - self.tabBarController.tabBar.height;
//    [self.view setNeedsUpdateConstraints];
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         [self.view layoutIfNeeded];
//                     }];
//}
//
//- (void)keyboardWillHide:(NSTimeInterval)duration {
//    self.tableBottomConstraint.constant = 0;
//    [self.view setNeedsUpdateConstraints];
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         [self.view layoutIfNeeded];
//                     }completion:^(BOOL finished) {
//                         if(self.iAmiPad){
//                             [self selectRow];
//                         }
//                     }];
//    
//    if (self.searchBar.text.length == 0) {
//        [self onCancelSearch:nil];
//    }
//}



@end
