//
//  MapPrice.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 26.01.2021.
//

#import "MapPrice.h"
#import "DataManager.h"

@interface MapPrice()



@end


@implementation MapPrice

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin{
    self = [super init];
    if (self) {
        _destination = [[DataManager sharedInstance]cityForIATA:[dictionary valueForKey:@"destination"]];
        _origin = origin;
        _departure = [self dateFromString:[dictionary valueForKey:@"depart_date"]];
        _returDate = [self dateFromString:[dictionary valueForKey:@"return_date"]];
        _numberOfChanges = [[dictionary valueForKey:@"number_of_changes"] integerValue];
        _value = [[dictionary valueForKey:@"value"]integerValue];
        _distance = [[dictionary valueForKey:@"distance"]integerValue];
        _actual = [[dictionary valueForKey:@"actual"]boolValue];
        
        
    }
    return  self;
}
-(NSDate * _Nullable)dateFromString:(NSString *)dateString {
    if(!dateString) { return nil; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyy-MM-dd";
    
    return [dateFormatter dateFromString: dateString];
}


@end
