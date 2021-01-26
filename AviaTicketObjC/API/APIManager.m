//
//  APIManager.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 25.01.2021.
//

#import "APIManager.h"
#import "DataManager.h"

#define API_TOKEN @"1cb76ce477cf9a481e08ab464a7c53f9"
#define API_URL_IP_ADRESS @"https://api.ipify.org/?format=json"
#define API_URL_CHEAP @"https://api.travvelpayouts.com/v1/prices/cheap"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="

@implementation APIManager

+ (instancetype)sharedinstance {
    static APIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[APIManager alloc] init];
    });
    return instance;
}


- (void)cityForCurrentIP:(void (^)(City *city))completion {
    [self getIPAdress:^(NSString *ipAdress) {
        [self load:[NSString stringWithFormat:@"%@%@", API_URL_CITY_FROM_IP,ipAdress] withCompletion:^(id  _Nullable result) {
            NSDictionary *json = result;
            NSString *iata = [json valueForKey:@"iata"];
            if(iata) {
                City *city = [[DataManager sharedInstance] cityForIATA:iata];
                if(city) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(city);
                    });
                }
            }
            
        }];
    }];
}

-(void)getIPAdress:(void (^)(NSString *ipAdress))completion{
    [self load:API_URL_IP_ADRESS withCompletion:^(id _Nullable result) {
        NSDictionary *json = result;
        completion([json valueForKey:@"ip"]);
    }];
}

-(void)load:(NSString *)urlString withCompletion:(void (^) (id _Nullable result))completion {
[[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:urlString]
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
}]resume];
    
    
    
}



@end
