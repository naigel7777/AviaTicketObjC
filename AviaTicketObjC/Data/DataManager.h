//
//  DataManager.h
//  AviaTicketObjC
//
//  Created by Nail Safin on 21.01.2021.
//

#import <Foundation/Foundation.h>
#import "Country.h"
#import "City.h"
#import "Airport.h"
#define kDataManagerLoadDataDidConplete @"DataManagerLoadDataDidConplete"

typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

typedef struct SearchRequest{
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destination;
    __unsafe_unretained NSDate *departureDate;
    __unsafe_unretained NSDate *returnDate;
    
} SearchRequest;

@interface DataManager : NSObject

+(instancetype)sharedInstance;

-(void)loadData;
-(City *)cityForIATA:(NSString *)iata;

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

@end


