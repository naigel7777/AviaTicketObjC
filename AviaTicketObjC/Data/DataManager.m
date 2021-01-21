//
//  DataManager.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 21.01.2021.
//

#import "DataManager.h"
#import "Country.h"
#import "City.h"
#import "Airport.h"


@interface DataManager()

@property (nonatomic, strong) NSMutableArray *countriesArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *airportArray;

@end


@implementation DataManager

+(instancetype)sharedInstance{
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    return instance;
}

-(void)loadData{
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJsonArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        _countriesArray = [self createPbjectFromArray:countriesJsonArray withType:DataSourceTypeCountry];
    })
}

@end
