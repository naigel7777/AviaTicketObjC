//
//  TicketTVCell.m
//  AviaTicketObjC
//
//  Created by Nail Safin on 26.01.2021.
//

#import "TicketTVCell.h"

@interface TicketTVCell()

@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation TicketTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:_priceLabel];
        
        _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_airlineLogoView];
        
        _placeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _placeLabel.font = [UIFont systemFontOfSize: 15.0 weight:UIFontWeightLight];
        _placeLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_placeLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.font = [UIFont systemFontOfSize: 15.0 weight:UIFontWeightRegular];
        _dateLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_dateLabel];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40);
    _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 10, 10, 80, 80);
    _placeLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 20, 100.0, 20.0);
    _dateLabel.frame = CGRectMake(10, CGRectGetMaxY(_priceLabel.frame) + 5, self.contentView.frame.size.width - 20.0, 20.0);
    
}

- (void)setTicket:(Ticket *)ticket {
    
    _ticket = ticket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ rub.", ticket.price];
    _placeLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    _airlineLogoView.image = [UIImage imageNamed:@"111"];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
