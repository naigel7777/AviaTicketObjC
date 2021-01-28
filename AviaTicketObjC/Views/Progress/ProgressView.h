//
//  ProgressView.h
//  AviaTicketObjC
//
//  Created by Nail Safin on 28.01.2021.
//

#import <UIKit/UIKit.h>



@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;

@end


