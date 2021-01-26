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
@property (nonatomic, strong) NSMutableArray *airportsArray;

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
        self->_countriesArray = [self createObjectFromArray:countriesJsonArray withType:DataSourceTypeCountry];
        
        NSArray *citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        self->_citiesArray = [self createObjectFromArray:citiesJsonArray withType:DataSourceTypeCity];
        
        NSArray *airportsJsonArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        self->_airportsArray = [self createObjectFromArray:airportsJsonArray withType:DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidConplete object:nil];
        });
        NSLog(@"Data Loaded");
    });
}

-(NSArray *)arrayFromFileName:(NSString *)fileName ofType:(NSString *)type{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

-(NSMutableArray *)createObjectFromArray:(NSArray *)array withType:(DataSourceType)type{
    
    NSMutableArray * res = [NSMutableArray new];
    
    for (NSDictionary *jsonObjc in array){
        if (type == DataSourceTypeCountry) {
            Country *country = [[Country alloc] initWithDictionary:jsonObjc];
            [res addObject:country];
        }
        else if (type == DataSourceTypeCity){
            City *city = [[City alloc] initWithDictionary:jsonObjc];
            [res addObject:city];
        }
        else if (type == DataSourceTypeAirport){
            Airport *airport = [[Airport alloc] initWithDictionary: jsonObjc];
            [res addObject:airport];
        }
    }
    
    
    
    return res;
    
}

-(NSArray *)countries{
    return _countriesArray;
}

-(NSArray *)cities{
    return _citiesArray;
}

-(NSArray *)airports{
    return _airportsArray;
}

-(City *)cityForIATA:(NSString *)iata {
    if (iata) {
        for (City *city in _citiesArray) {
            if ([city.code isEqualToString:iata]) {
                return city;
            }
        }
    }
    
    
    return nil;
}

@end
