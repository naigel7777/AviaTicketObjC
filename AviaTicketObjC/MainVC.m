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

@interface MainVC ()<PlaceVCDelegate>

@property (nonatomic, strong) UIView *placeContainer;
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataManager sharedInstance] loadData];
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"321"]];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor systemBlueColor];
    self.title = @"Search";
  
    _placeContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 140, [UIScreen mainScreen].bounds.size.width - 40, 170)];
    _placeContainer.backgroundColor = [[UIColor magentaColor]colorWithAlphaComponent:0.3];
    _placeContainer.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor];
    _placeContainer.layer.shadowOffset = CGSizeZero;
    _placeContainer.layer.shadowRadius = 20;
    _placeContainer.layer.shadowOpacity = 1.0;
    _placeContainer.layer.cornerRadius = 6.0;
    
    
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:@"From" forState:UIControlStateNormal];
    _departureButton.tintColor = [UIColor blueColor];
    _departureButton.frame = CGRectMake(30, 20, [UIScreen mainScreen].bounds.size.width - 100.0, 60);
    _departureButton.layer.cornerRadius = 4.0;
    _departureButton.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
    [_departureButton addTarget:self action:@selector(placeButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainer addSubview:_departureButton];
    
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle:@"Where" forState:UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor blueColor];
    _arrivalButton.frame = CGRectMake(30, CGRectGetMaxY(_departureButton.frame) + 20, [UIScreen mainScreen].bounds.size.width - 100.0, 60);
    _arrivalButton.layer.cornerRadius = 4.0;
    _arrivalButton.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
    [_arrivalButton addTarget:self action:@selector(placeButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainer addSubview:_arrivalButton];
    
    [self.view addSubview:_placeContainer];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
    _searchButton.tintColor = [UIColor blackColor];
    _searchButton.frame = CGRectMake(30, CGRectGetMaxY(_placeContainer.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60);
    _searchButton.layer.cornerRadius = 4.0;
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    _searchButton.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.8];
    [_searchButton addTarget:self action:@selector(SearchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded) name:kDataManagerLoadDataDidConplete object:nil];
}


-(void)searchButtonTapped:(UIButton *) sender {
    [[APIManager sharedinstance] ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
        if (tickets.count > 0) {
            TicketsTVC *ticketsVC = [[TicketsTVC alloc] initWithTickets:tickets];
            [self.navigationController showViewController:ticketsVC sender:self];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OHH NOOO!" message:@"No tickets for chosen destination, try again" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
    
    
    
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
