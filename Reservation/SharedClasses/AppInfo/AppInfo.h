//
//  AppInfo.h
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

@import Foundation;

@interface AppInfo : NSObject {
    
}

@property (nonatomic, readonly) NSMutableArray  *myReservationsList, *massageList;

+(AppInfo*)sharedInfo;
+(void)configureAppTheme;
+(NSString*)reservationsDirectoryPath;
+(NSString *)formattedTimeDurationForMinutes:(NSInteger)minutes;

-(void)loadResources;
-(void)saveResources;
// Just in case if we want to delete everything from disk.
-(void)deleteResources;

// Adding reservation in sorted order based on scheduled date.
-(void)addReservation:(Reservation *)reservation;
-(Massage *)massageForID:(NSString *)massageID;
-(NSArray *)massageListWithOffers;
-(NSArray *)massageListWithoutOffers;

@end
