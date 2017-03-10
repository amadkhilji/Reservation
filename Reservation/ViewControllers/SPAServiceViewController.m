//
//  SPAServiceViewController.m
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/8/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import "SPAServiceViewController.h"
#import "ScheduleViewController.h"

#define CELL_ARROW_TAG  10

@interface SPAServiceViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *offersList;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;

@end

@implementation SPAServiceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"SPA SERVICE";
  
  UIImage *backIcon = [IonIcons imageWithIcon:ion_ios_arrow_left
                                    iconColor:[UIColor whiteColor]
                                     iconSize:34.0f
                                    imageSize:CGSizeMake(40.0f, 40.0f)];
  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
  [self.navigationItem setLeftBarButtonItem:barButton];
 
  _tableView.layer.masksToBounds = YES;
  _tableView.layer.cornerRadius = 6.0f;
  
  _reserveButton.layer.masksToBounds = YES;
  _reserveButton.layer.cornerRadius = 6.0f;
  
  _offersList = [NSMutableArray arrayWithArray:[[AppInfo sharedInfo] massageListWithOffers]];
  _pageControl.numberOfPages = _offersList.count;
  
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  [self loadOfferViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)loadOfferViews {
  
  dispatch_async(dispatch_get_main_queue(), ^{
    int index = 0;
    CGFloat height = _tableView.frame.origin.y + _tableView.frame.size.height + 30;
    CGSize size = _scrollView.frame.size;
    for (Massage *obj in _offersList) {
      UIImage *image = [UIImage imageNamed:obj.backgroundImage];
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*index, 0, size.width, size.height)];
      imageView.image = image;
      [_scrollView addSubview:imageView];
      [_scrollView sendSubviewToBack:imageView];
      index++;
    }
    _scrollView.contentSize = CGSizeMake(_offersList.count * size.width, height);
  });
}

- (IBAction)reserveAction:(id)sender {
  
  Massage *massageObj = [_offersList objectAtIndex:_pageControl.currentPage];
  [self openScheduleViewControllerForMassage:massageObj];
}

- (void)openScheduleViewControllerForMassage:(Massage *)massage {
 
  if (massage.isActive) {
    ScheduleViewController *scheduleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
    scheduleVC.massage = massage;
    [self.navigationController pushViewController:scheduleVC animated:YES];
  }
  else {
    NSString *message = [NSString stringWithFormat:@"%@ %@ is inactive. Go to MassageList.plist to activate it.", massage.title, massage.type];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      // do something on OK click.
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
  }
}

#pragma mark UITableViewDelegate/UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [AppInfo sharedInfo].massageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  Massage *massageObj = [[AppInfo sharedInfo].massageList objectAtIndex:indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", massageObj.title, massageObj.type];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Massage *massageObj = [[AppInfo sharedInfo].massageList objectAtIndex:indexPath.row];
  [self openScheduleViewControllerForMassage:massageObj];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
  CGFloat width = scrollView.frame.size.width;
  CGFloat offsetX = scrollView.contentOffset.x;
  CGFloat positionX = offsetX/width;
  int index = ((ceilf(positionX)-positionX) < 0.5) ? ceilf(positionX) : floorf(positionX);
  _pageControl.currentPage = index;
}

@end
