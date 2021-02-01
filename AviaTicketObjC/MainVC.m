//
//  MainVC.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 21.01.2021.
//

#import "MainVC.h"
#import "DataManager.h"
#import "PlaceVC.h"
#import "APIManager.h"
#import "TicketsTVC.h"
#import "MapVC.h"
#import "ProgressView.h"

@interface MainVC ()<PlaceVCDelegate>

@property (nonatomic, strong) UIView *placeContainer;
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UIDatePicker *fromDate;
@property (nonatomic, strong) NSDate *fromDatePicker;
@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataManager sharedInstance] loadData];
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:NSLocalizedString(@"beach", "")]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.prefersLargeTitles = YES;
 //   self.navigationController.navigationBar.backgroundColor = [UIColor systemBlueColor];
//    self.title = @"Search";
  
    _placeContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 140, [UIScreen mainScreen].bounds.size.width - 40, 170)];
    _placeContainer.backgroundColor = [[UIColor systemBlueColor]colorWithAlphaComponent:0.3];
    _placeContainer.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor];
    _placeContainer.layer.shadowOffset = CGSizeZero;
    _placeContainer.layer.shadowRadius = 20;
    _placeContainer.layer.shadowOpacity = 1.0;
    _placeContainer.layer.cornerRadius = 6.0;
    
    
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:NSLocalizedString(@"from_field", "") forState:UIControlStateNormal];
    _departureButton.tintColor = [UIColor blueColor];
    _departureButton.frame = CGRectMake(30, 20, [UIScreen mainScreen].bounds.size.width - 100.0, 60);
    _departureButton.layer.cornerRadius = 4.0;
    _departureButton.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
    [_departureButton addTarget:self action:@selector(placeButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainer addSubview:_departureButton];
    
    _fromDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_departureButton.frame) + 20, [UIScreen mainScreen].bounds.size.width - 100.0, 60)];
    _fromDate.datePickerMode = UIDatePickerModeDate;
    _fromDate.minimumDate = [NSDate date];
    [_fromDate addTarget:self action:@selector(dateChoosen:) forControlEvents:UIControlEventValueChanged];
    _fromDatePicker = [_fromDate date];
    [self.placeContainer addSubview:_fromDate];
    
//    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_arrivalButton setTitle:NSLocalizedString(@"where_field", "") forState:UIControlStateNormal];
//    _arrivalButton.tintColor = [UIColor blueColor];
//    _arrivalButton.frame = CGRectMake(30, CGRectGetMaxY(_departureButton.frame) + 20, [UIScreen mainScreen].bounds.size.width - 100.0, 60);
//    _arrivalButton.layer.cornerRadius = 4.0;
//    _arrivalButton.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
//    [_arrivalButton addTarget:self action:@selector(placeButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.placeContainer addSubview:_arrivalButton];
//
    [self.view addSubview:_placeContainer];
//
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:NSLocalizedString(@"main_search", "") forState:UIControlStateNormal];
    _searchButton.tintColor = [UIColor blackColor];
    _searchButton.frame = CGRectMake(30, CGRectGetMaxY(_placeContainer.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60);
    _searchButton.layer.cornerRadius = 4.0;
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    _searchButton.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.8];
    [_searchButton addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
    
    _mapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_mapButton setTitle:@"Search on Map" forState:UIControlStateNormal];
    _mapButton.tintColor = [UIColor whiteColor];
    _mapButton.frame = CGRectMake(30, CGRectGetMaxY(_searchButton.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60);
    _mapButton.layer.cornerRadius = 4.0;
    _mapButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    _mapButton.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.8];
    [_mapButton addTarget:self action:@selector(mapButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mapButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded) name:kDataManagerLoadDataDidConplete object:nil];
}


-(void)searchButtonTapped:(UIButton *)sender {
    if (_searchRequest.origin && _searchRequest.destination) {
        [[ProgressView sharedInstance] show:^{
            [[APIManager sharedinstance] ticketsWithRequest:self->_searchRequest withCompletion:^(NSArray *tickets) {
                [[ProgressView sharedInstance] dismiss:^{
                    if (tickets.count > 0) {
                        TicketsTVC *ticketsViewController = [[TicketsTVC alloc] initWithTickets:tickets];
                        [self.navigationController showViewController:ticketsViewController sender:self];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", "") message:NSLocalizedString(@"tickets_not_found", "") preferredStyle: UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"close", "") style:(UIAlertActionStyleDefault) handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
            }];
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", "") message:NSLocalizedString(@"not_set_place_arrival_or_departure", "") preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"close", "") style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)dateChoosen:(UIDatePicker *)sender {
   
    NSLog(@"chosen date");
    NSLog(@"%@",sender.date);
    NSLog(@"%@",_fromDatePicker);
        
  
}

-(void)mapButtonTapped:(UIButton *)sender {
   
            MapVC *mapVC = [[MapVC alloc] init];
            [self.navigationController showViewController:mapVC sender:self];
        
  
}


-(void) dataLoaded {
    [[APIManager sharedinstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceDeparture forButton:self->_departureButton];
    }];
}

-(void)placeButtonTaped:(UIButton *)sender{
    PlaceVC *placeVC;
    if([sender isEqual:_departureButton]){
        placeVC = [[PlaceVC alloc]initWithType:PlaceDeparture];
    } else {
        placeVC = [[PlaceVC alloc]initWithType:PlaceArrival];
    }
    placeVC.delegate = self;
    [self.navigationController pushViewController:placeVC animated:YES];
    
    
}


-(void) selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType{
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton:(placeType == PlaceDeparture ? _departureButton : _arrivalButton)];
}

-(void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button{
    NSString *title;
    NSString *iata;
    
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.code;
    }
    
    if (placeType == PlaceDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destination = iata;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
}

@end
