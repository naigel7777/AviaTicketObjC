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
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) UISearchController *searchController;

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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchResultsUpdater = self;
    _searchArray = [NSArray new];
    

    _placeTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _placeTableView.delegate = self;
    _placeTableView.dataSource = self;
    self.navigationItem.searchController = _searchController;
    [self.view addSubview:_placeTableView];
    
    _placeSegmentControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"cities_segment", ""),NSLocalizedString(@"airports_segment", "")]];
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

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
        _searchArray = [_currentArray filteredArrayUsingPredicate: predicate];
        [_placeTableView reloadData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchController.isActive && [_searchArray count] > 0) {
        return [_searchArray count];
    }
    return [_currentArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Reuseidentifire];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Reuseidentifire];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (_placeSegmentControl.selectedSegmentIndex == 0) {
        City *city = (_searchController.isActive && [_searchArray count] > 0) ? [_searchArray objectAtIndex:indexPath.row] : [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    } else if (_placeSegmentControl.selectedSegmentIndex == 1) {
        Airport *airport = (_searchController.isActive && [_searchArray count] > 0) ? [_searchArray objectAtIndex:indexPath.row] : [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int)_placeSegmentControl.selectedSegmentIndex) + 1;
    if (_searchController.isActive && [_searchArray count] > 0) {
        [self.delegate selectPlace:[_searchArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
        _searchController.active = NO;
    } else {
        [self.delegate selectPlace:[_currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
