//
//  ADLinkDetectingTextStorage.m
//  TextKitTest
//
//  Created by 王奥东 on 16/12/28.
//  Copyright © 2016年 DrunkenMouse. All rights reserved.
//

#import "ADLinkDetectingTextStorage.h"

@implementation ADLinkDetectingTextStorage
{
    NSTextStorage *_imp;
}

- (id)init
{
    if (self= [super init]) {
        _imp = [NSTextStorage new];
    }
    
    return self;
}


#pragma mark - Reading Text

- (NSString *)string
{
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_imp attributesAtIndex:location effectiveRange:range];
}


#pragma mark - Text Editing

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    // Normal replace
    [_imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
    
    // 设置匹配类型为Link(联系、环节)
    //数据检测
    static NSDataDetector *linkDetector;
    linkDetector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:NULL];
    
    //清除range的文本颜色
    NSRange paragaphRange = [self.string paragraphRangeForRange: NSMakeRange(range.location, str.length)];
    [self removeAttribute:NSLinkAttributeName range:paragaphRange];
    [self removeAttribute:NSBackgroundColorAttributeName range:paragaphRange];
    [self removeAttribute:NSUnderlineStyleAttributeName range:paragaphRange];
    
    //发现range中的全部iWords
    [linkDetector enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [self addAttribute:NSLinkAttributeName value:result.URL range:result.range];
        [self addAttribute:NSBackgroundColorAttributeName value:[[UIColor purpleColor] colorWithAlphaComponent:0.2] range:result.range];
        [self addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:result.range];
    }];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}
@end
