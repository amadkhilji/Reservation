//
//  Massage.m
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import "Massage.h"

@implementation Massage

-(instancetype)initWithData:(NSDictionary *)data {

  if (self = [super init]) {
    if ([data objectForKey:MASSAGE_ID_KEY]) {
      _massageID = [data objectForKey:MASSAGE_ID_KEY];
    }
    if ([data objectForKey:TITLE_KEY]) {
      _title = [data objectForKey:TITLE_KEY];
    }
    if ([data objectForKey:TYPE_KEY]) {
      _type = [data objectForKey:TYPE_KEY];
    }
    if ([data objectForKey:DESCRIPTION_KEY]) {
      _massageDescription = [data objectForKey:DESCRIPTION_KEY];
    }
    if ([data objectForKey:PRICE_KEY]) {
      _price = [[data objectForKey:PRICE_KEY] integerValue];
    }
    if ([data objectForKey:DURATION_IN_MINUTES_KEY]) {
      _durationInMinutes = [[data objectForKey:DURATION_IN_MINUTES_KEY] integerValue];
    }
    if ([data objectForKey:MAX_PARTY_SIZE_KEY]) {
      _maxPartySize = [[data objectForKey:MAX_PARTY_SIZE_KEY] integerValue];
    }
    if ([data objectForKey:DISCOUNT_IN_PERCENTAGE_KEY]) {
      _discountInPercentage = [[data objectForKey:DISCOUNT_IN_PERCENTAGE_KEY] floatValue];
      if (_discountInPercentage > 0.0f) {
        _isDiscountAvailable = YES;
      }
    }
    if ([data objectForKey:IS_ACTIVE]) {
      _isActive = [[data objectForKey:IS_ACTIVE] boolValue];
    }
    if ([data objectForKey:BACKGROUND_IMAGE_KEY]) {
      _backgroundImage = [data objectForKey:BACKGROUND_IMAGE_KEY];
    }
    if ([data objectForKey:ICON_KEY]) {
      _icon = [data objectForKey:ICON_KEY];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:DATE_FORMAT_LONG];
    if ([data objectForKey:START_DATE_KEY]) {
      _offerStartDate = [dateFormatter dateFromString:[data objectForKey:START_DATE_KEY]];
    }
    if ([data objectForKey:END_DATE_KEY]) {
      _offerEndDate = [dateFormatter dateFromString:[data objectForKey:END_DATE_KEY]];
    }
  }
  return self;
}

-(NSMutableDictionary *)massageData {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:DATE_FORMAT_LONG];
  
  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  [data setObject:(_massageID)?_massageID:@"" forKey:MASSAGE_ID_KEY];
  [data setObject:(_title)?_title:@"" forKey:TITLE_KEY];
  [data setObject:(_type)?_type:@"" forKey:TYPE_KEY];
  [data setObject:(_massageDescription)?_massageDescription:@"" forKey:DESCRIPTION_KEY];
  [data setObject:(_backgroundImage)?_backgroundImage:@"" forKey:BACKGROUND_IMAGE_KEY];
  [data setObject:(_icon)?_icon:@"" forKey:ICON_KEY];
  [data setObject:[NSNumber numberWithInteger:_price] forKey:PRICE_KEY];
  [data setObject:[NSNumber numberWithInteger:_durationInMinutes] forKey:DURATION_IN_MINUTES_KEY];
  [data setObject:[NSNumber numberWithInteger:_maxPartySize] forKey:MAX_PARTY_SIZE_KEY];
  [data setObject:[NSNumber numberWithFloat:_discountInPercentage] forKey:DISCOUNT_IN_PERCENTAGE_KEY];
  [data setObject:[NSNumber numberWithBool:_isActive] forKey:IS_ACTIVE];
  if (_offerStartDate) {
    [data setObject:[dateFormatter stringFromDate:_offerStartDate] forKey:START_DATE_KEY];
  }
  if (_offerEndDate) {
    [data setObject:[dateFormatter stringFromDate:_offerEndDate] forKey:END_DATE_KEY];
  }
  return data;
}

@end
