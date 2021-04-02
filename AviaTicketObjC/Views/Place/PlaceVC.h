//
//  PlaceVC.h
//  AviaTicketObjC
//
//  Created by Nail Safin on 22.01.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

typedef enum PlaceType{
    PlaceArrival,
    PlaceDeparture
}PlaceType;

@protocol PlaceVCDelegate<NSObject>

-(void) selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;

@end

@interface PlaceVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<PlaceVCDelegate>delegate;

-(instancetype)initWithType:(PlaceType)type;

@end


