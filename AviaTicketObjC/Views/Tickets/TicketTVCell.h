//
//  TicketTVCell.h
//  AviaTicketObjC
//
//  Created by Nail Safin on 26.01.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"


@interface TicketTVCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

@end

