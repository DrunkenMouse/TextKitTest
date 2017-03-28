//
//  CircleView.m
//  TextKitTest
//
//  Created by 王奥东 on 16/12/28.
//  Copyright © 2016年 DrunkenMouse. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (void)drawRect:(CGRect)rect {
   	[self.tintColor setFill];
    [[UIBezierPath bezierPathWithOvalInRect: self.bounds] fill];
}


@end
