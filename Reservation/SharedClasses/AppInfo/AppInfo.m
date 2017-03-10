//
//  AppInfo.m
//  ThugLife
//
//  Created by SSASOFT on 2/12/15.
//  Copyright (c) 2015 SSASoft. All rights reserved.
//

#import "AppInfo.h"

@interface AppInfo ()

-(void)loadMassageList;
-(void)loadMyReservationsList;
-(void)saveMyReservationsList;

@end

@implementation AppInfo

+(AppInfo*)sharedInfo {
  
  static AppInfo *singletonInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    singletonInstance = [[AppInfo alloc] init];
  });
    
  return singletonInstance;
}

-(id)init {
    
  if (self = [super init]) {
    _myReservationsList = [[NSMutableArray alloc] init];
    _massageList = [[NSMutableArray alloc] init];
  }
  
  return self;
}

#pragma mark
#pragma mark Private Methods

-(void)loadMassageList {
    
  NSArray *list = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:MASSAGE_PLIST ofType:@"plist"]];
  if (list && [list isKindOfClass:[NSArray class]]) {
    [_massageList removeAllObjects];
    for (NSDictionary *obj in list) {
      Massage *massage = [[Massage alloc] initWithData:obj];
      [_massageList addObject:massage];
    }
  }
}

-(void)loadMyReservationsList {
    
  NSString *directoryPath = [AppInfo reservationsDirectoryPath];
  if (directoryPath) {
    NSString *filePath = [directoryPath stringByAppendingPathComponent:RESERVATIONS_FILE];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
      NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
      NSArray *list = [NSArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil]];
      if (list) {
        [_myReservationsList removeAllObjects];
        for (NSDictionary *obj in list) {
          Reservation *reservation = [[Reservation alloc] initWithData:obj];
          // Just sorting.
          [self addReservation:reservation];
        }
      }
    }
  }
}

-(void)saveMyReservationsList {
    
  NSString *directoryPath = [AppInfo reservationsDirectoryPath];
  if (directoryPath) {
    NSString *filePath = [directoryPath stringByAppendingPathComponent:RESERVATIONS_FILE];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
      [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSMutableArray *list = [NSMutableArray array];
    for (Reservation *obj in _myReservationsList) {
      NSDictionary *data = [obj reservationData];
      [list addObject:data];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:NSJSONWritingPrettyPrinted error:nil];
    // Data protection should be ON in the apple developer portal for this App Id.
    [jsonData writeToFile:filePath options:NSDataWritingFileProtectionComplete error:nil];
  }
}

-(void)loadResources {
    
  [self loadMassageList];
  [self loadMyReservationsList];
}

-(void)saveResources {

  [self saveMyReservationsList];
}

-(void)deleteResources {
 
  NSString *directoryPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:MY_RESERVATIONS_DIRECTORY];
  if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
    [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:nil];
  }
}

// Adding reservation in sorted order based on scheduled date.
-(void)addReservation:(Reservation *)reservation {
  
  BOOL flag = NO;
  for (int i=0; i<_myReservationsList.count && !flag; i++) {
    Reservation *obj = [_myReservationsList objectAtIndex:i];
    if ([obj.scheduledDate compare:reservation.scheduledDate] == NSOrderedDescending) {
      [_myReservationsList insertObject:reservation atIndex:i];
      flag = YES;
    }
  }
  if (!flag) {
    [_myReservationsList addObject:reservation];
  }
}

-(Massage *)massageForID:(NSString *)massageID {
  Massage *massage = nil;
  if (massageID) {
    for (Massage *obj in _massageList) {
      if ([obj.massageID isEqualToString:massageID]) {
        massage = obj;
        break;
      }
    }
  }
  return massage;
}

-(NSArray *)massageListWithOffers {

  NSMutableArray *list = [NSMutableArray array];
  for (Massage *obj in _massageList) {
    if (obj.isDiscountAvailable) {
      [list addObject:obj];
    }
  }
  return list;
}

-(NSArray *)massageListWithoutOffers {
  
  NSMutableArray *list = [NSMutableArray array];
  for (Massage *obj in _massageList) {
    if (!obj.isDiscountAvailable) {
      [list addObject:obj];
    }
  }
  return list;
}

#pragma mark
#pragma mark Static Methods

+(void)configureAppTheme {
    
  NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue" size:18.0],
                                             NSFontAttributeName, nil];
  [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
  [[UINavigationBar appearance] setBarTintColor:LIGHT_BLUE_COLOR];
  [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]]
   setTitleTextAttributes:navbarTitleTextAttributes
   forState:UIControlStateNormal];
}

+(NSString*)reservationsDirectoryPath {
  
  NSString *directoryPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:MY_RESERVATIONS_DIRECTORY];
  if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:[NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey] error:nil];
  }
  else {
    [[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey] ofItemAtPath:directoryPath error:nil];
  }
  return directoryPath;
}

+(NSString *)formattedTimeDurationForMinutes:(NSInteger)minutes {
  
  NSMutableString *formattedString = [NSMutableString string];
  NSInteger hours = minutes/60;
  if (hours < 1) {
    [formattedString appendFormat:@"%liM", minutes];
  }
  else {
    [formattedString appendFormat:@"%liH", hours];
    NSInteger mins = minutes%60;
    if (mins > 0) {
      [formattedString appendFormat:@" %liM", mins];
    }
  }
  return formattedString;
}

@end
