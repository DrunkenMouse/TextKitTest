//
//  ADOutliningLayoutManager.m
//  TextKitTest
//
//  Created by 王奥东 on 16/12/28.
//  Copyright © 2016年 DrunkenMouse. All rights reserved.
//

#import "ADOutliningLayoutManager.h"

@implementation ADOutliningLayoutManager

-(void)drawUnderlineForGlyphRange:(NSRange)glyphRange underlineType:(NSUnderlineStyle)underlineVal baselineOffset:(CGFloat)baselineOffset lineFragmentRect:(CGRect)lineRect lineFragmentGlyphRange:(NSRange)lineGlyphRange containerOrigin:(CGPoint)containerOrigin {
    
    //第一个带下划线字形的左边框（== position）
    CGFloat firstPosition = [self locationForGlyphAtIndex:glyphRange.location].x;
    //第一个带下划线字形的右边框（== position + width）
    CGFloat lastPosition;
    
    //不进行下面的判断，会让所有字体都显示边框
    // 当链接不是行中的最后一个文本时，只使用下一个字形的位置
    if (NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange)) {
        lastPosition = [self locationForGlyphAtIndex:NSMaxRange(glyphRange)].x;
    }
    //否则得到实际使用的rect的结束
    else {
        lastPosition = [self lineFragmentUsedRectForGlyphAtIndex:NSMaxRange(glyphRange)-1 effectiveRange:NULL].size.width;
    }
    
    // 将线片段插入下划线区域
    lineRect.origin.x += firstPosition;
    lineRect.size.width = lastPosition - firstPosition;
 
    // 根据容器起点的偏移线
    lineRect.origin.x += containerOrigin.x;
    lineRect.origin.y += containerOrigin.y;
    
    // 将线对齐到像素边界
    lineRect = CGRectInset(CGRectIntegral(lineRect), .5, .5);
    [[UIColor greenColor] set];
    [[UIBezierPath bezierPathWithRect:lineRect] stroke];
    
    
}


@end
