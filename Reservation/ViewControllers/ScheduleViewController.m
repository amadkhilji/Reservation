//
//  ScheduleViewController.m
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/8/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import "ScheduleViewController.h"
#import "DayCell.h"
#import "TimeCell.h"

@interface ScheduleViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *partySizeTF;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIPickerView *partySizePickerView;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *dayCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (strong, nonatomic) NSDate *currentDate;
@property (assign, nonatomic) NSInteger numberOfRemainingDaysInMonth;
@property (assign, nonatomic) NSInteger selectedDayIndex;
@property (assign, nonatomic) NSInteger selectedTimeIndex;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"SCHEDULE";
  
  UIImage *backIcon = [IonIcons imageWithIcon:ion_ios_arrow_left
                                    iconColor:[UIColor whiteColor]
                                     iconSize:34.0f
                                    imageSize:CGSizeMake(40.0f, 40.0f)];
  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
  [self.navigationItem setLeftBarButtonItem:barButton];
  
  _currentDate = [NSDate date];
  NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
  NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_currentDate];
  NSInteger day = [calendar components:NSCalendarUnitDay fromDate:_currentDate].day;
  _numberOfRemainingDaysInMonth = (range.length - day) + 1;
  
  _selectedDayIndex = -1;
  _selectedTimeIndex = -1;
  
  [self loadMassageData];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGFloat height = _timeCollectionView.frame.origin.y + _timeCollectionView.frame.size.height + 20;
  if (_scrollView.frame.size.height < height) {
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height);
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)loadMassageData {
  
  _iconImage.image = [UIImage imageNamed:_massage.icon];
  _titleLabel.text = _massage.title;
  _typeLabel.text = _massage.type;
  _priceLabel.text = [NSString stringWithFormat:@"$%.2f", (float)_massage.price];
  _descriptionLabel.text = _massage.massageDescription;
  _durationLabel.text = [AppInfo formattedTimeDurationForMinutes:_massage.durationInMinutes];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MMMM"];
  _monthLabel.text = [dateFormatter stringFromDate:_currentDate];
  
  _reserveButton.enabled = NO;
  _reserveButton.alpha = 0.5;
}

- (NSDate *)dateAtIndex:(NSInteger)index {
  
  NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
  dayComponent.day = index;
  
  NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
  NSDate *date = [calendar dateByAddingComponents:dayComponent toDate:_currentDate options:0];
  
  return date;
}

- (NSString *)timeStringAtIndex:(NSInteger)index {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"hh:mm a"];
  NSDate *date = [dateFormatter dateFromString:@"09:00 AM"];
  NSTimeInterval timeIntervalInSeconds = _massage.durationInMinutes * 60;
  date = [date dateByAddingTimeInterval:(index * timeIntervalInSeconds)];
  
  NSString *timeString = [dateFormatter stringFromDate:date];
  
  return timeString;
}

- (IBAction)cancelPartySizeAction:(id)sender {
  
  [_partySizeTF resignFirstResponder];
}

- (IBAction)donePartySizeAction:(id)sender {
  
  [_partySizeTF resignFirstResponder];
  
  NSInteger selectedRow = [_partySizePickerView selectedRowInComponent:0];
  _partySizeTF.text = [NSString stringWithFormat:@"%li", selectedRow+1];
}

- (IBAction)scheduleReservationAction:(id)sender {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:DATE_FORMAT_SHORT];
  
  NSDate *date = [self dateAtIndex:_selectedDayIndex];
  NSString *dateString = [dateFormatter stringFromDate:date];
  NSString *timeString = [self timeStringAtIndex:_selectedTimeIndex];
  dateString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
  [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ hh:mm a", DATE_FORMAT_SHORT]];
  date = [dateFormatter dateFromString:dateString];
  
  NSMutableDictionary *reservationData = [NSMutableDictionary dictionary];
  [reservationData setObject:date forKey:SCHEDULED_DATE_KEY];
  [reservationData setObject:_partySizeTF.text forKey:PARTY_SIZE_KEY];
  [reservationData setObject:_massage forKey:MASSAGE_KEY];
  
  Reservation *reservation = [[Reservation alloc] initWithData:reservationData];
  [[AppInfo sharedInfo] addReservation:reservation];
  [[AppInfo sharedInfo] saveResources];
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewCalendarAction:(id)sender {
  
  NSURL *url = [NSURL URLWithString:@"calshow://"];
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url];
  }
}

#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
  [_partySizePickerView selectRow:[textField.text integerValue]-1 inComponent:0 animated:NO];
  
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  
  textField.inputAccessoryView = _toolbar;
  textField.inputView = _partySizePickerView;
}

#pragma mark UIPickerViewDelegate/UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 12;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  return [NSString stringWithFormat:@"%li", row+1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  _partySizeTF.text = [NSString stringWithFormat:@"%li", row+1];
}

#pragma mark UICollectionViewDelegate/UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  if (collectionView == _dayCollectionView) {
    return _numberOfRemainingDaysInMonth;
  }
  else {
    // Calculating number of reservation times we can have during a 12 hour/day time period. 
    return ((12*60)/_massage.durationInMinutes);
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  if (collectionView == _dayCollectionView) {
    static NSString *dayCellIdentifier = @"DayCell";
    DayCell *cell = (DayCell *)[collectionView dequeueReusableCellWithReuseIdentifier:dayCellIdentifier forIndexPath:indexPath];
    
    NSDate *date = [self dateAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger day = [calendar components:NSCalendarUnitDay fromDate:date].day;
    
    cell.dayLabel.text = [dateFormatter stringFromDate:date];
    cell.dateLabel.text = [NSString stringWithFormat:@"%li", day];
    
    return cell;
  }
  else {
    static NSString *dayCellIdentifier = @"TimeCell";
    TimeCell *cell = (TimeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:dayCellIdentifier forIndexPath:indexPath];
    
    NSString *timeString = [self timeStringAtIndex:indexPath.row];
    cell.timeLabel.text = timeString;
    
    return cell;
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  if (collectionView == _dayCollectionView) {
    _selectedDayIndex = indexPath.row;
  }
  else {
    _selectedTimeIndex = indexPath.row;
  }
  
  if (_selectedTimeIndex >= 0 && _selectedDayIndex >= 0) {
    _reserveButton.alpha = 1.0;
    _reserveButton.enabled = YES;
  }
}

#pragma mark UICollectionViewDelegateFlowLayout Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  return (collectionView == _dayCollectionView) ? CGSizeMake(64, 84) : CGSizeMake(120, 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  
  return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  
  return 10.0;
}

@end
