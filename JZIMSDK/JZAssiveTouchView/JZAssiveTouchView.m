//
//  JZAssiveTouchView.m
//  JZIMSDK
//
//  Created by king jack on 15/9/21.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZAssiveTouchView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation JZAssiveTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame imageName:(NSString *)name
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];

        _imageView = [[UIImageView alloc]initWithFrame:(CGRect){0, 0,frame.size.width, frame.size.height}];
        _imageView.image = [UIImage imageNamed:name];
        _imageView.alpha = 0.3;
        [self addSubview:_imageView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)imageNameNormal imageHighlight:(NSString *)imageHighlight target:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageNameNormal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageHighlight] forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)locationChange:(UIPanGestureRecognizer*)p
{
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeColor) object:nil];
        _imageView.alpha = 0.8;
    }
    else if (p.state == UIGestureRecognizerStateEnded)
    {
        [self performSelector:@selector(changeColor) withObject:nil afterDelay:4.0];
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        if(panPoint.x <= SCREENFRAME_SIZE_WIDTH/2)
        {
            if(panPoint.y <= HEIGHT+HEIGHT/2 && panPoint.x >= WIDTH)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, HEIGHT/2);
                }];
            }
            else if(panPoint.y >= SCREENFRAME_SIZE_HEIGHT-HEIGHT/2-HEIGHT && panPoint.x >= WIDTH)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, SCREENFRAME_SIZE_HEIGHT-HEIGHT/2);
                }];
            }
            else if (panPoint.x < WIDTH/2+15 && panPoint.y > SCREENFRAME_SIZE_HEIGHT-HEIGHT/2)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(WIDTH/2, SCREENFRAME_SIZE_HEIGHT-HEIGHT/2);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y < HEIGHT/2 ? HEIGHT/2 :panPoint.y;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(WIDTH/2, pointy);
                }];
            }
        }
        else if(panPoint.x > SCREENFRAME_SIZE_WIDTH/2)
        {
            if(panPoint.y <= HEIGHT+HEIGHT/2 && panPoint.x < SCREENFRAME_SIZE_WIDTH-WIDTH )
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, HEIGHT/2);
                }];
            }
            else if(panPoint.y >= SCREENFRAME_SIZE_HEIGHT-HEIGHT-HEIGHT/2 && panPoint.x < SCREENFRAME_SIZE_WIDTH-WIDTH)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, SCREENFRAME_SIZE_HEIGHT-HEIGHT/2);
                }];
            }
            else if (panPoint.x > SCREENFRAME_SIZE_WIDTH-WIDTH && panPoint.y < HEIGHT/2)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(SCREENFRAME_SIZE_WIDTH-WIDTH/2, HEIGHT/2);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y > SCREENFRAME_SIZE_HEIGHT-HEIGHT/2 ? SCREENFRAME_SIZE_HEIGHT-HEIGHT/2 :panPoint.y;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(SCREENFRAME_SIZE_WIDTH-WIDTH/2, pointy);
                }];
            }
        }
    }
}

- (void)setWindowStatus
{
    if (!self.isShowMenu)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 100, SCREENFRAME_SIZE_WIDTH, 60);
            _imageView.hidden = YES;
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 100, 60, 60);
            _imageView.hidden = NO;
        }];
        
    }
    self.isShowMenu = !self.isShowMenu;
}

-(void)click:(UITapGestureRecognizer*)t
{
    _imageView.alpha = 0.8;
    if ([self.delegate respondsToSelector:@selector(assistiveTocuhs:)])
    {
        [self.delegate assistiveTocuhs:self.isShowMenu];
    }
    [self performSelector:@selector(changeColor) withObject:nil afterDelay:4.0];

    [self setWindowStatus];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString *className = NSStringFromClass([touch.view class]);
    
    if ([className isEqualToString:@"UITableViewCellContentView"]
        || [className isEqualToString:@"UINavigationBar"])
    {
        return NO;
    }
    return  YES;
}

-(void)changeColor
{
    [UIView animateWithDuration:2.0 animations:^{
        _imageView.alpha = 0.3;
    }];
}



@end
