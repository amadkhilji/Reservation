//
//  Massage.h
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Massage : NSObject

@property(nonatomic, readonly) NSString *massageID, *title, *type, *massageDescription, *backgroundImage, *icon;
@property(nonatomic, readonly) NSInteger price, durationInMinutes;
@property(nonatomic, assign) NSInteger maxPartySize;
@property(nonatomic, readonly) CGFloat discountInPercentage;
@property(nonatomic, readonly) BOOL isActive, isDiscountAvailable;
@property(nonatomic, readonly) NSDate *offerStartDate, *offerEndDate;

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithData:(NSDictionary *)data NS_DESIGNATED_INITIALIZER;

-(NSMutableDictionary *)massageData;

@end
