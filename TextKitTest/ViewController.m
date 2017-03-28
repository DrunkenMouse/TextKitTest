//
//  ViewController.m
//  TextKitTest
//
//  Created by 王奥东 on 16/12/28.
//  Copyright © 2016年 DrunkenMouse. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"//排除路径
#import "SyntaxHighlightTextStorage.h"//正则识别
#import "CircleTextContainer.h"//文字圆形显示
//邮箱与网址识别
#import "ADLinkDetectingTextStorage.h"
#import "ADOutliningLayoutManager.h"

#define kstring @"如上图所示，它们的关系是 1 对 N 的关系。就是那样：一个 Text Storage 可以拥有多个 Layout Manager，一个 Layout Manager 也可以拥有多个 Text Container。这些多重性带来了多容器布局的特性"

#define KStrings @" ~Shopping List~ *Cheese* _Biscuits_ -Sausages- IMPORTANT  @庄洁元   #话题#   http://www.baidu.com"

#define ksize self.view.bounds.size

@interface ViewController ()<NSLayoutManagerDelegate>
///多种字体
@property (strong, nonatomic) IBOutlet UILabel *label;
///排除路径
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet CircleView *circleView;
///多容器
@property (strong, nonatomic) IBOutlet UITextView *originTestView;
@property (strong, nonatomic) IBOutlet UIView *thirdView;
@property (strong, nonatomic) IBOutlet UIView *otherView;
///正则表达式识别"*"
@property (strong, nonatomic) SyntaxHighlightTextStorage *textStorage;
@property (strong, nonatomic) IBOutlet UITextView *regluaxTextView;
///圆环显示字符串
@property (strong, nonatomic) IBOutlet UITextView *circleTextContainer;
///邮箱与网址识别
@property (strong, nonatomic) IBOutlet UITextView *emailText;


@end

@implementation ViewController {
    // 文本存储必须强烈保持，只有文本视图保留默认存储。
    ADLinkDetectingTextStorage * _emailTextStorage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //邮箱与网址识别
    [self regularEmailHttp];
    //圆环显示字符串
    [self circleTextView];
    //正则表达式识别"*"
    [self regularString];
    //多容器
    [self moreContainer];
    //排除路径
    [self textViewExclusionPaths];
    //多种字体
    [self moreText];
    
}

#pragma mark - 邮箱与网址识别
-(void)regularEmailHttp{
    // Create componentes(组件)
    _emailTextStorage = [ADLinkDetectingTextStorage new];
    
    //布局管理负责画边框
    ADOutliningLayoutManager *layoutManager = [ADOutliningLayoutManager new];
    [_emailTextStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    [layoutManager addTextContainer:textContainer];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:_emailText.frame textContainer:textContainer];
    textView.backgroundColor = _emailText.backgroundColor;
    _emailText = textView;
    [self.view addSubview:_emailText];
    
    //    // Set delegate
    layoutManager.delegate = self;
    
    //    // Load layout text
    NSString *emailString = @"http://stackoverflow.com , tomorrow consectetur adipiscing http://stackoverflow.com/questions/tagged/objective-c?sort=featured&pageSize=15 elit.\n 123456789@162.com ";
    //文件存储否则匹配显示并调用画线
    [_emailTextStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:emailString];
}

//用于判断画线是否断点
-(BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByWordBeforeCharacterAtIndex:(NSUInteger)charIndex {
    
    NSRange range;
    NSURL *linkURL = [layoutManager.textStorage attribute:NSLinkAttributeName atIndex:charIndex effectiveRange:&range];
    // 除非绝对需要，否则不要断开链接中的行
    if (linkURL && charIndex > range.location && charIndex <= NSMaxRange(range)) {
        return NO;
    }else {
        return YES;
    }
    
}


//返回以glyphIndex结尾的行之后的间距。
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    
    return glyphIndex/100;
}

//返回以glyphIndex结尾的行之后的段落间距。
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{

    return 5;
}
#pragma mark - 圆环显示字符串
-(void)circleTextView {
 
    
    NSString *string = @"IT WAS the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way- in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.There were a king with a large jaw and a queen with a plain face, on the throne of England;";
    //创建一个可变段落，设置边缘调整属性
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setAlignment:NSTextAlignmentJustified];
    
    //文本存储有一个布局管理者，布局管理者有一个文本容器
    //文本存储设置文本相关属性，布局管理者获取文本容器，文本容器设置排除路径
    NSTextStorage *text = [[NSTextStorage alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}];
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [text addLayoutManager:layoutManager];
    
    
    CGRect textViewFrame = _circleTextContainer.frame;
    //文字显示范围在CircleTextContainer.m文件的方法中
    CircleTextContainer *textContainer = [[CircleTextContainer alloc] initWithSize:textViewFrame.size];
    
    [layoutManager addTextContainer:textContainer];
    
    [textContainer setExclusionPaths:@[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(40, 40, 30, 30)]]];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:_circleTextContainer.frame textContainer:textContainer];
    textView.backgroundColor = _circleTextContainer.backgroundColor;
    textView.allowsEditingTextAttributes = YES;
    textView.scrollEnabled = NO;
    textView.editable = NO;
    _circleTextContainer = textView;
    
    
    [self.view addSubview:_circleTextContainer];
    
}

#pragma mark - 正则表达式识别"*"
-(void)regularString{
    _regluaxTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _textStorage = [SyntaxHighlightTextStorage new];
    [_textStorage addLayoutManager:_regluaxTextView.layoutManager];
    
    [_textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:@"在从 Interface 文件中载入时，可以像这样将它插入文本视图,然后加 *星号* 的字就会高亮出来了"];
}

#pragma mark - 多容器
-(void)moreContainer {
    // Load text
    NSTextStorage *sharedTextStorage = self.originTestView.textStorage;
    [sharedTextStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:kstring];
    
    // 将一个新的 Layout Manager 附加到上面的 Text Storage 上
    NSLayoutManager *otherLayoutManager = [NSLayoutManager new];
    [sharedTextStorage addLayoutManager:otherLayoutManager];
    
    
    //将一个新的 NSTextContainer 附加到上面的 Layout Manager 上
    NSTextContainer *thirdTextContainer = [NSTextContainer new];
    [otherLayoutManager addTextContainer:thirdTextContainer];
    //根据容器生成新的TextView并添加到View
    UITextView *thirdTextView = [[UITextView alloc] initWithFrame:self.thirdView.bounds textContainer:thirdTextContainer];
    thirdTextView.backgroundColor = self.thirdView.backgroundColor;
    thirdTextView.scrollEnabled = NO;
    [self.thirdView addSubview:thirdTextView];
    
    //将一个新的 NSTextContainer 附加到上面的 Layout Manager 上
    NSTextContainer *otherTextContainer = [NSTextContainer new];
    [otherLayoutManager addTextContainer:otherTextContainer];
    //根据容器生成新的TextView并添加到View
    UITextView *otherTextView = [[UITextView alloc] initWithFrame:self.otherView.bounds textContainer:otherTextContainer];
    otherTextView.backgroundColor = self.otherView.backgroundColor;
    otherTextView.scrollEnabled = NO;
    
    [self.otherView addSubview:otherTextView];

}

#pragma mark - 排除路径
-(void)textViewExclusionPaths {
    NSString *str = @"iOS 上的 NSTextContainer 提供了exclusionPaths，它允许开发者设置一个 NSBezierPath 数组来指定不可填充文本的区域,以下是转换方法,将它的 bounds（self.circleView.bounds）转换到 Text View 的坐标系统:";
    
    
    [self.textView.textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:str];
    
    _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    
    
    // 将rect从view中转换到当前视图中，返回在当前视图中的rect
    CGRect ovalFrame = [self.textView convertRect:self.circleView.bounds fromView:self.circleView];
    
    NSLog(@"%f,%f",ovalFrame.origin.x,ovalFrame.origin.y);
    //self.textView.textContainerInset
    //在文本视图的内容区域中插入文本容器的布局区域
    
    self.textView.textContainer.exclusionPaths = @[[UIBezierPath bezierPathWithOvalInRect:ovalFrame]];
}



#pragma mark - 多种字体
-(void)moreText {
    NSString *str = @"bold,little color,hello";
    //NSMutableAttributedString的初始化
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:attrs];
    
    
    //little color
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[str rangeOfString:@"little color"]];
    
    
    //Hello  字体类型:Papyrus
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Papyrus" size:36] range:NSMakeRange(18, 5)];
    
    //little
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:[str rangeOfString:@"little"]];
    
    //NSMutableAttributedString移除属性 little
    //    [attributedString removeAttribute:NSFontAttributeName range:[str rangeOfString:@"little"]];
    
    //bold
    NSDictionary *attrs2 = @{NSStrokeWidthAttributeName:@-5,NSStrokeColorAttributeName:[UIColor greenColor],NSFontAttributeName:[UIFont systemFontOfSize:36],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
    
    [attributedString setAttributes:attrs2 range:NSMakeRange(0, 4)];
    
    self.label.attributedText = attributedString;
    
}


@end
