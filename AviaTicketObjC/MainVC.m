//
//  MainVC.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 21.01.2021.
//

#import "MainVC.h"
#import "DataManager.h"
@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataManager sharedInstance] loadData];
    
}


@end
