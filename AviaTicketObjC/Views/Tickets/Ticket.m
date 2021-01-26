//
//  Ticket.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 26.01.2021.
//

#import "Ticket.h"

@implementation Ticket

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _airline = [dictionary valueForKey: @"airline"];
        _expires = dateFromString([dictionary valueForKey:@"expires_at"]);
        _departure = dateFromString([dictionary valueForKey:@"departure_at"]);
        _flightNumber = [dictionary valueForKey:@"flight_number"];
        _price = [dictionary valueForKey:@"price"];
        _returndate = dateFromString([dictionary valueForKey:@"return_at"]);
        
    }
    
    return self;
}

NSDate *dateFromString(NSString *dateString) {
    if(!dateString) { return nil; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *correctStringDate = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    correctStringDate = [correctStringDate stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
    
    return [dateFormatter dateFromString:correctStringDate];
}



@end
