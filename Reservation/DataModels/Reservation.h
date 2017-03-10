//
//  Reservation.h
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reservation : NSObject

@property(nonatomic, readonly) NSInteger partySize;
@property(nonatomic, readonly) NSDate *scheduledDate;
@property(nonatomic, readonly) Massage *massage;

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithData:(NSDictionary *)data NS_DESIGNATED_INITIALIZER;

-(NSDictionary *)reservationData;
-(NSString *)formattedScheduledDateString;
-(NSString *)formattedScheduledTimeString;

@end
