//
//  MyReservationsViewController.m
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import "MyReservationsViewController.h"
#import "SPAServiceViewController.h"
#import "ReservationCell.h"

@interface MyReservationsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)addReservationAction:(id)sender;

@end

@implementation MyReservationsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"MY RESERVATIONS";
  
  UIImage *plusIcon = [IonIcons imageWithIcon:ion_plus
                                iconColor:[UIColor whiteColor]
                                 iconSize:28.0f
                                imageSize:CGSizeMake(40.0f, 40.0f)];
  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:plusIcon style:UIBarButtonItemStylePlain target:self action:@selector(addReservationAction:)];
  
  [self.navigationItem setRightBarButtonItem:barButton];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 10.0f)];
  _tableView.tableFooterView = paddingView;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addReservationAction:(id)sender {
 
  SPAServiceViewController *spaVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SPAServiceViewController"];
  [self.navigationController pushViewController:spaVC animated:YES];
}

#pragma mark UITableViewDelegate/UITableViewDataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 280.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [AppInfo sharedInfo].myReservationsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"Cell";
  ReservationCell *cell = (ReservationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  Reservation *reservation = [[AppInfo sharedInfo].myReservationsList objectAtIndex:indexPath.row];
  
  cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@", reservation.massage.title, reservation.massage.type];
  cell.descriptionLabel.text = reservation.massage.massageDescription;
  cell.partySizeLabel.text = [NSString stringWithFormat:@"PARTY SIZE - %li", reservation.partySize];
  cell.durationLabel.text = [AppInfo formattedTimeDurationForMinutes:reservation.massage.durationInMinutes];
  
  cell.dateLabel.text = [reservation formattedScheduledDateString];
  cell.timeLabel.text = [reservation formattedScheduledTimeString];
  
  return cell;
}

@end
