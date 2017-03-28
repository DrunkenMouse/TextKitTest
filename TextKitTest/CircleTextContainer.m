//
//  CircleTextContainer.m
//  TextKitTest
//
//  Created by 王奥东 on 16/12/28.
//  Copyright © 2016年 DrunkenMouse. All rights reserved.
//

#import "CircleTextContainer.h"

@implementation CircleTextContainer



//创建后会自己在后台运行，也就是主线程度的执行结束后才会执行此方法
//通过此方法设置圆形的范围
-(CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect atIndex:(NSUInteger)characterIndex writingDirection:(NSWritingDirection)baseWritingDirection remainingRect:(CGRect *)remainingRect {
    
    
    
    CGRect rect = [super lineFragmentRectForProposedRect:proposedRect atIndex:characterIndex writingDirection:baseWritingDirection remainingRect:remainingRect];
    
    CGSize size = [self size];
    CGFloat radius = fmin(size.width, size.height)/2.0;
    CGFloat ypos = fabs((proposedRect.origin.y + proposedRect.size.height / 2.0) - radius);
    CGFloat width = (ypos < radius)?2.0 * sqrt(radius*radius - ypos *ypos):0.0;
    CGRect circleRect = CGRectMake(radius - width/2.0+5, proposedRect.origin.y, width, proposedRect.size.height);
    //返回r1与r2的交叉
    return CGRectIntersection(rect, circleRect);
}



@end
