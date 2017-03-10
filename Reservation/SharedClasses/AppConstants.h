//
//  AppConstants.h
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#ifndef Reservation_AppConstants_h
#define Reservation_AppConstants_h

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define LIGHT_BLUE_COLOR  [UIColor colorWithRed:97.0f/255.0f green:179.0f/255.0f blue:235.0f/255.0f alpha:1.0f]
#define BLUE_COLOR        [UIColor colorWithRed:2.0/255.0f green:107.0/255.0f blue:197.0/255.0f alpha:1.0f]

#define APP_NAME                    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

#define MY_RESERVATIONS_DIRECTORY   @"MyReservationsDirectory"
#define RESERVATIONS_FILE           @"MyReservationsDataFile.dat"
#define MASSAGE_PLIST               @"MassageList"
#define MASSAGE_KEY                 @"massage"
#define MASSAGE_ID_KEY              @"massageID"
#define TITLE_KEY                   @"title"
#define TYPE_KEY                    @"type"
#define DESCRIPTION_KEY             @"description"
#define PRICE_KEY                   @"price"
#define DURATION_IN_MINUTES_KEY     @"durationInMinutes"
#define MAX_PARTY_SIZE_KEY          @"maxPartySize"
#define PARTY_SIZE_KEY              @"partySize"
#define DISCOUNT_IN_PERCENTAGE_KEY  @"discountInPercentage"
#define START_DATE_KEY              @"offerStartDate"
#define END_DATE_KEY                @"offerEndDate"
#define SCHEDULED_DATE_KEY          @"scheduledDate"
#define IS_ACTIVE                   @"isActive"
#define BACKGROUND_IMAGE_KEY        @"backgroundImage"
#define ICON_KEY                    @"icon"

#define DATE_FORMAT_LONG            @"yyyy-MM-dd'T'HH:mm:ssZ"
#define DATE_FORMAT_SHORT           @"MM/dd/yyyy"
#define TIME_FORMAT_12_HOURS        @"hh:mm a"

#endif
