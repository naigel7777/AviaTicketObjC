//
//  TicketsTVC.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 26.01.2021.
//

#import "TicketsTVC.h"
#import "TicketTVCell.h"

#define TicketCellReuseidetifire @"TicketCellIdentifire"

@interface TicketsTVC ()

@property (nonatomic, strong) NSArray *tickets;

@end

@implementation TicketsTVC

- (instancetype)initWithTickets:(NSArray *)tickets{
    self = [super init];
    if (self) {
        _tickets = tickets;
        self.title = NSLocalizedString(@"tickets_title", "");
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.tableView registerClass:[TicketTVCell class] forCellReuseIdentifier:TicketCellReuseidetifire];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _tickets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   TicketTVCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseidetifire forIndexPath:indexPath];
    cell.ticket = [_tickets objectAtIndex:indexPath.row];
 
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/





@end
