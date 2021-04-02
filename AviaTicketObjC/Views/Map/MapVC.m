//
//  MapVC.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 27.01.2021.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "LocationController.h"
#import "APIManager.h"
#import "MapPrice.h"
#import <CoreLocation/CoreLocation.h>


@interface MapVC () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationController *locationController;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"Pricing map";
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded) name:kDataManagerLoadDataDidConplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:) name:kLocationServiceDidUpdate object:nil];
    
    
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoaded {
    _locationController = [[LocationController alloc] init];
}

- (void)updateLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            [[APIManager sharedinstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
 
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self->_mapView addAnnotation: annotation];
        });
    }
}



@end
