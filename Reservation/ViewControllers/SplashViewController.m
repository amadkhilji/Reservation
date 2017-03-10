//
//  SplashViewController.m
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import "SplashViewController.h"
#import "MyReservationsViewController.h"

@interface SplashViewController ()

-(void)openMyReservationsViewController;

@end

@implementation SplashViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [AppInfo configureAppTheme];
  [self performSelector:@selector(openMyReservationsViewController) withObject:nil afterDelay:1.5];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)openMyReservationsViewController {

  MyReservationsViewController *reservationsVC =
  [[UIStoryboard storyboardWithName:@"Main"
                             bundle:[NSBundle mainBundle]]
   instantiateViewControllerWithIdentifier:@"MyReservationsViewController"];
  
  __block UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:reservationsVC];
  
  // Its safe if the block retains self, because the block is not retained by self itself. Hence
  // there will be no retain cycle and no need for a weakSelf.
  dispatch_async(dispatch_get_main_queue(), ^{
    [self presentViewController:navigationController animated:YES completion:nil];
  });
}

@end
