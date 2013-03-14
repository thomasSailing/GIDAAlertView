//
//  GIDASearchAlert.m 2011/10/28 to 2013/02/27
//  GIDAAlertView.m since 2013/02/27
//  TestAlert
//
//  Created by Alejandro Paredes on 10/28/11.
//
// Following methods are inspired in Yoshiki Vázquez Baeza work on previous versions
// of GIDAAlertView.
// - (id)initWithMessage:(NSString *)someMessage andAlertImage:(UIImage *)someImage;
// - (id) initWithSpinnerAndMessage:(NSString *)message;
// - (void)presentAlertFor:(float)seconds;
// - (void)presentAlertWithSpinnerAndHideAfterSelector:(SEL)selector from:(id)sender;
//

#import "GIDAAlertView.h"

@interface GIDAAlertView() {
    BOOL withSpinnerOrImage;
    UIProgressView *progressView;
    float progress;
    NSTimer *timer;
    double timeSeconds;
}
@property (nonatomic, retain) UIColor *alertColor;
@property (nonatomic, retain) NSTimer *timer;

- (void) drawRoundedRect:(CGRect)rrect
               inContext:(CGContextRef)context
              withRadius:(CGFloat)radius;

@end

@implementation GIDAAlertView
@synthesize textField;
@synthesize theMessage;
@synthesize timer = _timer;

-(id)initWithProgressBarAndMessage:(NSString *)message andTime:(NSInteger)seconds {
    self = [super initWithTitle:@"\n\n\n\n\n" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        progress = -0.1;
        timeSeconds = seconds/10;
        withSpinnerOrImage = YES;
        //progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        //  [progressView setProgress:0];
        /*   [self addObserver:self forKeyPath:@"progress" options:NSKeyValueChangeNewKey context:nil];*/
        //   [progressView setFrame:CGRectMake(100, 35, 80, 80)];
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bar.png"]];
        [iv setFrame:CGRectMake(100, 35, 0, 80)];
        [self addSubview:iv];
        //        [self addSubview:progressView];
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 115, 160, 50)];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel setText:message];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTextColor:[UIColor whiteColor]];
        [messageLabel setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:20]];
        [messageLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:messageLabel];
        [messageLabel release];
        [iv release];
    }
    return  self;
}
-(void)moveProgress {
    if (progress <= 1.0) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bar.png"]];
        [iv setFrame:CGRectMake(100, 35, 8+progress*80, 80)];
        [self addSubview:iv];
        progress += 0.1;
        [iv release];
        // [progressView setProgress:progress];
    } else {
#ifdef DEBUG
        NSLog(@"INVALIDATE");
#endif
        [_timer invalidate];
        _timer = nil;
        [self dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)presentProgressBar {
    [self show];
    _timer = [NSTimer timerWithTimeInterval:timeSeconds target:self selector:@selector(moveProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
-(id)initWithMessage:(NSString *)message andAlertImage:(UIImage *)image {
    self = [super initWithTitle:@"\n\n\n\n\n" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        withSpinnerOrImage = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(100, 35, 80, 80)];
        [self addSubview:imageView];
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 115, 160, 50)];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel setText:message];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTextColor:[UIColor whiteColor]];
        [messageLabel setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:20]];
        [messageLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:messageLabel];
        [messageLabel release];
        [imageView release];
    }
    return  self;
}

-(id) initWithSpinnerAndMessage:(NSString *)message {
    self = [super initWithTitle:@"\n\n\n\n\n" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        withSpinnerOrImage = YES;
        UIActivityIndicatorView *theSpinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [theSpinner setFrame:CGRectMake(100, 35, 80, 80)];
        
        [theSpinner startAnimating];
        [self addSubview:theSpinner];
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 115, 160, 50)];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel setText:message];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTextColor:[UIColor whiteColor]];
        [messageLabel setFont:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:20]];
        [messageLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:messageLabel];
        [messageLabel release];
        [theSpinner release];
    }
    return self;
}
- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle {
    while ([prompt sizeWithFont:[UIFont systemFontOfSize:18.0]].width > 240.0) {
        prompt = [NSString stringWithFormat:@"%@...", [prompt substringToIndex:[prompt length] - 4]];
    }
    
    if (self = [super initWithTitle:prompt message:@"\n" delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:acceptTitle, nil]) {
        withSpinnerOrImage = NO;
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)];
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setTextAlignment:NSTextAlignmentCenter];
        [theTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
        
        _alertColor = [UIColor blackColor];
        
        // if not >= 4.0
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if (![sysVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedDescending) {
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0);
            [self setTransform:translate];
        }
    }
    return self;
}


- (id)initWithOutTextAreaPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle andTextMessage:(NSString *)textMessage {
    while ([prompt sizeWithFont:[UIFont systemFontOfSize:18.0]].width > 240.0) {
        prompt = [NSString stringWithFormat:@"%@...", [prompt substringToIndex:[prompt length] - 4]];
    }
    
    if (self = [super initWithTitle:prompt message:@"\n" delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:acceptTitle, nil]) {
        withSpinnerOrImage = NO;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:textMessage];
        [self addSubview:label];
        theMessage = label;
        [label release];
        
        _alertColor = [UIColor blackColor];
        
        // if not >= 4.0
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if (![sysVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedDescending) {
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0);
            [self setTransform:translate];
        }
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _alertColor = [color retain];
}

- (void)show {
    [textField becomeFirstResponder];
    [super show];
}

- (NSString *)enteredText {
    return textField.text;
}

- (void)dealloc {
    [textField release];
    [super dealloc];
}

- (void) layoutSubviews {
	for (UIView *sub in [self subviews])
	{
		if([sub class] == [UIImageView class] && sub.tag == 0)
		{
			[sub removeFromSuperview];
			break;
		}
	}
}

- (void)drawRect:(CGRect)rect
{
#ifdef DEBUG
    NSLog(@"%f  %f  %f  %f",rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
#endif
    if (withSpinnerOrImage) {
        rect.origin.x = (rect.size.width - 180)/2;
        rect.size.width = rect.size.height = 180;
    }
#ifdef DEBUG
    NSLog(@"%f  %f  %f  %f",rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
#endif
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextClearRect(context, rect);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetLineWidth(context, 0.0);
	CGContextSetAlpha(context, 0.8);
	CGContextSetLineWidth(context, 2.0);
    UIColor *fillColor = _alertColor;
    UIColor *borderColor = nil;
    if (withSpinnerOrImage) {
        borderColor = [UIColor clearColor];
    } else {
        borderColor = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8];
    }
    
	CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    
	CGFloat backOffset = 2;
	CGRect backRect = CGRectMake(rect.origin.x + backOffset,
                                 rect.origin.y + backOffset,
                                 rect.size.width - backOffset*2,
                                 rect.size.height - backOffset*2);
    
	[self drawRoundedRect:backRect inContext:context withRadius:8];
	CGContextDrawPath(context, kCGPathFillStroke);
    
	CGRect clipRect = CGRectMake(backRect.origin.x + backOffset-1,
                                 backRect.origin.y + backOffset-1,
                                 backRect.size.width - (backOffset-1)*2,
                                 backRect.size.height - (backOffset-1)*2);
    
	[self drawRoundedRect:clipRect inContext:context withRadius:8];
	CGContextClip (context);
    
	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35, 1.0, 1.0, 1.0, 0.06 };
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace,
                                                        components, locations, num_locations);
    
	CGRect ovalRect = CGRectMake(-130, -115, (rect.size.width*2),
                                 rect.size.width/2);
    
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.size.height/5);
    
	CGContextSetAlpha(context, 0.8);
	CGContextAddEllipseInRect(context, ovalRect);
	CGContextClip (context);
    if (!withSpinnerOrImage) {
        CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
    }
    
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace);
}

- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef) context
              withRadius:(CGFloat) radius
{
	CGContextBeginPath (context);
    
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect),
    maxx = CGRectGetMaxX(rect);
    
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect),
    maxy = CGRectGetMaxY(rect);
    
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}
-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}
-(void)presentAlertWithSpinnerAndHideAfterSelector:(SEL)selector from:(id)sender withObject:(id)object {
    [self show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [sender performSelector:selector withObject:object];
        
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self dismissWithClickedButtonIndex:0 animated:YES];
                       });
    });
}

-(void)presentAlertFor:(float)seconds {
    [self show];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (id)initWithProgressBarAndMessage:(NSString *)message andURL:(NSURL *)url {
    NSLog(@"GIDAAlertView -(id)initWithProgressBarAndMessage:andURL: NEEDS CONSTRUCTION");
    return nil;
}
@end
