//
//  TabBarController.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 28.01.2021.
//

#import "TabBarController.h"
#import "MainVC.h"
#import "MapVC.h"

@interface TabBarController ()

@end

@implementation TabBarController


- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}

- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    MainVC *mainVC = [[MainVC alloc] init];
    mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage systemImageNamed:@"magnifyingglass.circle"] selectedImage:[UIImage systemImageNamed:@"magnifyingglass.circle.fill"]];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [controllers addObject:mainNC];
    
    MapVC *mapVC = [[MapVC alloc] init];
    mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage systemImageNamed:@"map"] selectedImage:[UIImage systemImageNamed:@"map.fill"]];
    UINavigationController *mapNC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [controllers addObject:mapNC];
    
    return controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
