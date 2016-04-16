//
//  MainViewController.m
//  Stations
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StationTableViewController.h"

@interface MainViewController () <StationTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fromWhereLable;
@property (weak, nonatomic) IBOutlet UIButton *chooseFromWhereButton;
@property (weak, nonatomic) IBOutlet UILabel *toWhereLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseWhereButton;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.chooseFromWhereButton.layer.cornerRadius = 10;
    self.chooseFromWhereButton.layer.borderWidth = 1;
    self.chooseFromWhereButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.chooseWhereButton.layer.cornerRadius = 10;
    self.chooseWhereButton.layer.borderWidth = 1;
    self.chooseWhereButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.datePicker addTarget:self action:@selector(getSelection:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowStationScreen"]) {
        StationTableViewController *detailsVC;
        detailsVC = ((StationTableViewController *)segue.destinationViewController);
        detailsVC.delegate = self;
        detailsVC.destinationState = [sender intValue];
    }
}

#pragma mark - Actions

-(void)getSelection:(id)sender{
    NSDate *pickerDate = [self.datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E dd MMMM HH:mm"];
    self.whenLabel.text = [NSString stringWithFormat:@"Отправление: %@", [formatter stringFromDate:pickerDate]];
}

- (IBAction)chooseFromWhere:(id)sender {
    [self performSegueWithIdentifier:@"ShowStationScreen" sender:[NSNumber numberWithInt:0]];
}

- (IBAction)chooseWhere:(id)sender {
    [self performSegueWithIdentifier:@"ShowStationScreen" sender:[NSNumber numberWithInt:1]];
}

#pragma StationTableViewControllerDelegate

-(void)passItem:(NSString *)item andState:(DestinationState)state{
    if(state){
        self.toWhereLabel.text = item;
    }else{
        self.fromWhereLable.text = item;
    }
}


@end
