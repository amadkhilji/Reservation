//
//  Reservation.m
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import "Reservation.h"

@implementation Reservation

-(instancetype)initWithData:(NSDictionary *)data {
  
  if (self = [super init]) {
    if ([data objectForKey:MASSAGE_ID_KEY]) {
      // Assuming massage list will always be available in our singleton. We are loading it from the
      // "MassageList.plist" for now (can load from server upon app launch).
      Massage *obj = [[AppInfo sharedInfo] massageForID:[data objectForKey:MASSAGE_ID_KEY]];
      _massage = [[Massage alloc] initWithData:[obj massageData]];
    }
    else if ([data objectForKey:MASSAGE_KEY]) {
      Massage *obj = [data objectForKey:MASSAGE_KEY];
      _massage = [[Massage alloc] initWithData:[obj massageData]];
    }
    if ([data objectForKey:PARTY_SIZE_KEY]) {
      _partySize = [[data objectForKey:PARTY_SIZE_KEY] integerValue];
    }
    if ([data objectForKey:SCHEDULED_DATE_KEY]) {
      id obj = [data objectForKey:SCHEDULED_DATE_KEY];
      if ([obj isKindOfClass:[NSDate class]]) {
        _scheduledDate = obj;
      }
      else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:DATE_FORMAT_LONG];
        _scheduledDate = [dateFormatter dateFromString:[data objectForKey:SCHEDULED_DATE_KEY]];
      }
    }
  }
  return self;
}

-(NSDictionary *)reservationData {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:DATE_FORMAT_LONG];
  
  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  [data setObject:(_massage.massageID)?_massage.massageID:@"" forKey:MASSAGE_ID_KEY];
  [data setObject:[NSNumber numberWithInteger:_partySize] forKey:PARTY_SIZE_KEY];
  if (_scheduledDate) {
    [data setObject:[dateFormatter stringFromDate:_scheduledDate] forKey:SCHEDULED_DATE_KEY];
  }
  return data;
}

-(NSString *)formattedScheduledDateString {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
  return [dateFormatter stringFromDate:_scheduledDate];
}

-(NSString *)formattedScheduledTimeString {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"hh:mm a"];
  return [dateFormatter stringFromDate:_scheduledDate];
}

@end
