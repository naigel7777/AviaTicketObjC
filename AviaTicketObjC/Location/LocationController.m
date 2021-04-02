//
//  LocationController.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 26.01.2021.
//

#import "LocationController.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationController()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation * currentLocation;

@end



@implementation LocationController

-(instancetype)init{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OHH NOOO!" message:@"Can't find your location" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
       
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if(!_currentLocation) {
        _currentLocation = [locations firstObject];
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdate object:_currentLocation];
    }
}


@end
