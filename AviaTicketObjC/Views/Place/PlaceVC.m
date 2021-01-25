//
//  PlaceVC.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 22.01.2021.
//

#import "PlaceVC.h"
#define Reuseidentifire @"CellIdentifire"


@interface PlaceVC ()

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *placeTableView;
@property (nonatomic, strong) UISegmentedControl *placeSegmentControl;
@property (nonatomic, strong) NSArray *currentArray;

@end

@implementation PlaceVC

-(instancetype)initWithType:(PlaceType)type{
    self = [super init];
    if (self){
        _placeType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _placeTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _placeTableView.delegate = self;
    _placeTableView.dataSource = self;
    [self.view addSubview:_placeTableView];
    
    _placeSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities",@"Airports"]];
    [_placeSegmentControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _placeSegmentControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _placeSegmentControl;
    _placeSegmentControl.selectedSegmentIndex = 0;
    [self changeSource];
    if (_placeType == PlaceDeparture){
        self.title = @"From";
    } else {
        self.title = @"Where";
    }
}

-(void)changeSource{
    switch (_placeSegmentControl.selectedSegmentIndex) {
        case 0:
            _currentArray = [[DataManager sharedInstance]cities];
            break;
        case 1:
            _currentArray = [[DataManager sharedInstance]airports];
            break;
            
        default:
            break;
    }
    [self.placeTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Reuseidentifire];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Reuseidentifire];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (_placeSegmentControl.selectedSegmentIndex == 0) {
        City *city = [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    } else if (_placeSegmentControl.selectedSegmentIndex == 1) {
        Airport *airport = [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    
    
    return cell;
}



@end
