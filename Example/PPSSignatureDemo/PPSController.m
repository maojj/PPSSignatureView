//
//  PPSController.m
//  PPSSignatureDemo
//
//  Created by maojj on 4/23/15.
//  Copyright (c) 2015 Jason Harwig. All rights reserved.
//

#import "PPSController.h"

@implementation PPSController

- (IBAction)clearButtonPressed:(id)sender {
    [_singnatureView erase];
    [_singView2 erase];
    [_handdraw clear];
}

@end
