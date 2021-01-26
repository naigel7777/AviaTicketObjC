//
//  APIManager.h
//  AviaTicketObjC
//
//  Created by Nail Safin on 25.01.2021.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface APIManager : NSObject


+ (instancetype)sharedinstance;
- (void)cityForCurrentIP:(void (^)(City *city))completion;
-(void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
@end

