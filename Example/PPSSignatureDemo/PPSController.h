//
//  PPSController.h
//  PPSSignatureDemo
//
//  Created by maojj on 4/23/15.
//  Copyright (c) 2015 Jason Harwig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureViewQuartz.h"
#import "SignatureViewQuartzQuadratic.h"
#import "TTHandDrawView.h"

@interface PPSController : UIViewController
@property (strong, nonatomic) IBOutlet SignatureViewQuartz *singnatureView;
@property (strong, nonatomic) IBOutlet TTHandDrawView *handdraw;
@property (strong, nonatomic) IBOutlet SignatureViewQuartzQuadratic *singView2;

@end
