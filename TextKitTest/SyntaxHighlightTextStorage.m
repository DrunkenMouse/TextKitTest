//
//  SyntaxHighlightTextStorage.m
//  TextKitTest
//
//  Created by 王奥东 on 16/12/28.
//  Copyright © 2016年 DrunkenMouse. All rights reserved.
//

#import "SyntaxHighlightTextStorage.h"

@implementation SyntaxHighlightTextStorage {
     NSMutableAttributedString *_backingStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string {
    return [_backingStore string];
}


//removeAttribute调用时调用
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    
    
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}


//初始化字符串时调用此方法来初始化
-(void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    
    [self beginEditing];
    
    [_backingStore replaceCharactersInRange:range withString:str];
    
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];//通知并记录最近的更改,不调用就不会显示更改内容
    
    [self endEditing];
    
    
    
}
//removeAttribute调用时调用
-(void)setAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];//长度并未变换，只是替换了颜色
    [self endEditing];
}
//processEditing在layout manager中文本修改时发送通知，它通常也是处理一些文本修改逻辑的好地方
-(void)processEditing {
    [super processEditing];
    
    //不可直接赋值，否则会报错
    static NSRegularExpression *expression;
    expression = [NSRegularExpression regularExpressionWithPattern:@"(\\*\\w+(\\s\\w+)*\\*)\\s" options:0 error:NULL];
    
    NSRange paragahRange = [self.string paragraphRangeForRange:self.editedRange];
    
    [self removeAttribute:NSForegroundColorAttributeName range:paragahRange];//会调用attributesAtIndex与setAttribute
    
    [expression enumerateMatchesInString:self.string options:0 range:paragahRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:result.range];
    }];
}

@end
