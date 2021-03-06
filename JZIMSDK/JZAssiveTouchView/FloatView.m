//
//  FloatView.m
//  FloatMenu
//
//  Created by Johnny on 14/9/6.
//  Copyright (c) 2014年 Johnny. All rights reserved.
//

#import "FloatView.h"
#import "UIView+MJExtension.h"
#import "AppDelegate.h"

#define  windowWidth ([UIScreen mainScreen].bounds.size.width)

#define  windowHight  ([UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM (NSUInteger, LocationTag)
{
    kLocationTag_top = 1,
    kLocationTag_left,
    kLocationTag_bottom,
    kLocationTag_right
};

static const NSTimeInterval kAnimationDuration = 0.25f;
static FloatView *__floatView = nil;

@interface FloatView ()
{
    UIWindow        *_boardWindow;               //底部window
    UIView          *_boardView;                 //底部view
    UIImageView     *_floatImageView;            //漂浮的menu按钮
    
    NSMutableArray  *_buttonArray;               //展开的button数组
    NSArray         *_buttonImgArray;            //图片背景
    NSArray         *_buttonTitleArray;
    
    BOOL            _showMenu;                   //menu是否展开
    BOOL            _showAnimation;              //animation动画展示
    BOOL            _showKeyBoard;               //键盘是否展开
    LocationTag     _locationTag;                //menu贴在哪个方向
    
    CGRect          _moveWindowRect;             //移动后window.frame
    CGRect          _showKeyBoardWindowRect;     //键盘展开后的window.frame
    CGSize          _keyBoardSize;               //键盘的尺寸
}
@end

@implementation FloatView

- (void)dealloc
{
    [self removeWindow];
}

- (void)removeWindow
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _buttonArray = nil;
    _buttonImgArray = nil;
//    _boardWindow = nil;
    [_boardView removeFromSuperview];
    _boardView = nil;

    [_floatImageView  removeFromSuperview];
    _floatImageView = nil;
}

- (id)initWithButtonImageNameArray:(NSArray*)imgNameArray titleArray:(NSArray *)titleArray
{
    self = [super init];
    if (self)
    {
        if (imgNameArray)
        {
            _buttonImgArray = imgNameArray;
        }
        if (titleArray)
        {
            _buttonTitleArray = titleArray;
        }
        _showMenu = NO;
        _showAnimation = NO;
        _showKeyBoard = NO;
        _buttonArray = [[NSMutableArray alloc]init];
        _locationTag = kLocationTag_left;
        
        //初始化背景window
//        _boardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _boardWindow = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
//        _boardWindow.backgroundColor = [UIColor clearColor];
//        _boardWindow.windowLevel = 3000;
//        _boardWindow.clipsToBounds = YES;
//        [_boardWindow makeKeyAndVisible];
        
        //初始化背景view
        _boardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _boardView.backgroundColor = [UIColor clearColor];
        [_boardWindow addSubview:_boardView];
        
        //初始化漂浮menu
        _floatImageView = [[UIImageView alloc]init];
        [self setImgaeNameWithMove:NO];
        [_floatImageView setUserInteractionEnabled:YES];
        [_floatImageView setFrame:CGRectMake(0, 0, 60, 60)];
        [_boardView addSubview:_floatImageView];
        
        //手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImgV:)];
        [_floatImageView addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgV:)];
        [_floatImageView addGestureRecognizer:tapGestureRecognizer];
        
        //键盘
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillHide:) name:UIKeyboardWillHideNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

#define degreesToRadian(x) (M_PI * (x) / 180.0)

- (void)transformWindowSubView
{
    for (UIView *view in _boardWindow.subviews)
    {
        CGAffineTransform transform = view.transform;
        transform = CGAffineTransformRotate(transform,  degreesToRadian(90));
        view.transform = transform;
    }
}

+ (FloatView *)defaultFloatViewWithButtonImageNameArray:(NSArray*)imgNameArray titleArray:(NSArray *)titleArray
{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        __floatView = [[FloatView alloc] initWithButtonImageNameArray:imgNameArray titleArray:titleArray];
    });
    return __floatView;
}

#pragma mark - GestureRecognizer
#pragma mark UIPanGestureRecognizer
- (void)panImgV:(UIPanGestureRecognizer*)panGestureRecognizer
{
    //判断是否展开
    if (_showMenu)return;
    
    UIView * moveView = panGestureRecognizer.view.superview;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
        {
            CGPoint translation = [panGestureRecognizer translationInView:moveView.superview];
            [moveView setCenter:(CGPoint){moveView.center.x + translation.x, moveView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:moveView.superview];
            [self setImgaeNameWithMove:YES];
        }
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            if (_boardView.frame.origin.y + _boardView.frame.size.height > windowHight - _keyBoardSize.height)
            {
                if (_showKeyBoard)
                {
                    if (moveView.frame.origin.x < 0)
                    {
                        [moveView setCenter:(CGPoint){moveView.frame.size.width/2,windowHight - _keyBoardSize.height - _boardView.frame.size.height/2}];
                    }
                    else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth)
                    {
                        [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,windowHight - _keyBoardSize.height - _boardView.frame.size.height/2}];
                    }
                    else
                    {
                        [moveView setCenter:(CGPoint){moveView.center.x,windowHight - _keyBoardSize.height - _boardView.frame.size.height/2}];
                    }
                    _showKeyBoardWindowRect = CGRectMake(_boardView.frame.origin.x, windowHight - moveView.frame.size.height, 60, 60);
                    _locationTag = kLocationTag_bottom;
                }
                else
                {
                    [self moveEndWithMoveView:moveView];
                    _showKeyBoardWindowRect = _boardView.frame;
                }
            }
            else
            {
                [self moveEndWithMoveView:moveView];
                _showKeyBoardWindowRect = _boardView.frame;
            }
            [self setImgaeNameWithMove:NO];
        }
    }];
}

- (void)moveEndWithMoveView:(UIView*)moveView
{
    if (moveView.mj_y <= 40)
    {
        if (moveView.mj_x < 0)
        {
            [moveView setCenter:(CGPoint){moveView.mj_w/2,moveView.mj_h/2}];
            _locationTag = kLocationTag_left;
        }
        else if (moveView.mj_x + moveView.mj_w > windowWidth)
        {
            [moveView setCenter:(CGPoint){windowWidth - moveView.mj_w/2,moveView.mj_h/2}];
            _locationTag = kLocationTag_right;
        }
        else
        {
            [moveView setCenter:(CGPoint){moveView.center.x,moveView.mj_h/2}];
            _locationTag = kLocationTag_top;
        }
    }
    else if (moveView.mj_y + moveView.mj_h >= windowHight - 40)
    {
        if (moveView.frame.origin.x < 0)
        {
            [moveView setCenter:(CGPoint){moveView.mj_w/2,windowHight - moveView.mj_h/2}];
            _locationTag = kLocationTag_left;
        }
        else if (moveView.mj_x + moveView.mj_w > windowWidth)
        {
            [moveView setCenter:(CGPoint){windowWidth - moveView.mj_w/2,windowHight - moveView.mj_h/2}];
            _locationTag = kLocationTag_right;
        }
        else
        {
            [moveView setCenter:(CGPoint){moveView.center.x,windowHight - moveView.mj_h/2}];
            _locationTag = kLocationTag_bottom;
        }
    }
    else
    {
        if (moveView.frame.origin.x + moveView.mj_w/2 < windowWidth/2)
        {
            if (moveView.frame.origin.x !=0) {
                [moveView setCenter:(CGPoint){moveView.mj_w/2,moveView.center.y}];
            }
            _locationTag = kLocationTag_left;
        }
        else
        {
            if (moveView.mj_x + moveView.mj_w != windowWidth) {
                [moveView setCenter:(CGPoint){windowWidth - moveView.mj_w/2,moveView.center.y}];
            }
            _locationTag = kLocationTag_right;
        }
    }
}

#pragma mark UITapGestureRecognizer

- (void)tapImgV:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (!_showAnimation)
    {
        if (_showMenu)
        {
            [self hideMenu];
        }else
        {
            [self showMenu];
        }
    }
    _showMenu = !_showMenu;
}

- (void)windowTaped:(UITapGestureRecognizer *)gesture
{
    [self hideMenu];
    _showMenu = !_showMenu;
}

#pragma mark - ShowMenu
- (void)showMenu
{
    _moveWindowRect = _boardView.frame;
    
//    _boardView.frame = SCREENFRAME;
//    
//    _boardView.frame = _moveWindowRect;
    
    [self shakeMenu:_boardView];
    
    for (NSInteger i = ([_buttonImgArray count] - 1); i>= 0; i--)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:_moveWindowRect];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:_buttonImgArray[i]] forState:UIControlStateNormal];
        [button setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_boardWindow insertSubview:button belowSubview:_boardView];
        [_buttonArray addObject:button];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [UIView animateWithDuration:kAnimationDuration animations:^{
        for (int i = 0; i < [_buttonArray count]; i++)
        {
            UIButton * button = _buttonArray[i];
            switch (_locationTag)
            {
                case 1:
                    //top
                    [button setFrame:CGRectMake(_moveWindowRect.origin.x,60 + 5 + 5 * i + 60 * i, 60, 60)];
                    break;
                case 2:
                    //left
                    [button setFrame:CGRectMake(60 + 5 + 5 * i + 60 * i,_moveWindowRect.origin.y, 60, 60)];
                    break;
                case 3:
                    //bottom
                    if (_showKeyBoard)
                    {
                        [button setFrame:CGRectMake(_moveWindowRect.origin.x,windowHight - _keyBoardSize.height - 60 - 60 - 5 - (5 * i + 60 * i), 60, 60)];
                    }
                    else
                    {
                        [button setFrame:CGRectMake(_moveWindowRect.origin.x,windowHight - 60 - 60 - 5 - (5 * i + 60 * i), 60, 60)];
                    }
                    
                    break;
                case 4:
                    //right
                    [button setFrame:CGRectMake(windowWidth - 60 - 60 - 5 - (5 * i + 60 * i),_moveWindowRect.origin.y, 60, 60)];
                    break;
                default:
                    break;
            }
            [self setButtonPostionWithOrientation:_locationTag button:button];
        }
        _showAnimation = YES;
    }
                     completion:^(BOOL finished)
     {
        UITapGestureRecognizer *windowTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(windowTaped:)];
        [_boardWindow addGestureRecognizer:windowTap];
        _showMenu = YES;
        _showAnimation = NO;
    }];
}

- (void)setButtonPostionWithOrientation:(LocationTag)isLeftOrRight button:(UIButton *)button
{
    if (isLeftOrRight == 1 || isLeftOrRight == 3)
    {
        [button setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 10)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -80)];
    }
    else
    {
        [button setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 10)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(100, 0, 0, 0)];
    }
}

#pragma mark - HideMenu
- (void)hideMenu
{
    [self shakeMenu:_boardView];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        for (int i = 0; i < [_buttonArray count]; i++)
        {
            UIButton * button = _buttonArray[i];
            [button setFrame:CGRectMake(_moveWindowRect.origin.x,_moveWindowRect.origin.y, 60, 60)];
        }
        _showAnimation = YES;
    } completion:^(BOOL finished)
     {
        for (int i = 0; i<[_buttonArray count]; i++)
        {
            UIButton * button = _buttonArray[i];
            [button removeFromSuperview];
        }
        _boardView.frame = _moveWindowRect;
//        _boardView.frame = CGRectMake(0, 0, 60, 60);
        [_buttonArray removeAllObjects];
        [_boardWindow removeGestureRecognizer:[[_boardWindow gestureRecognizers] lastObject]];
        _showMenu = NO;
        _showAnimation = NO;
    }];
}

#pragma mark - 抖动
- (void)shakeMenu:(UIView *)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    [animation setValue:@"toViewValue" forKey:@"toViewKey"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.1];
    [animation setRepeatCount:1];
    [lbl addAnimation:animation forKey:nil];
}

#pragma mark - 移动和停止menu图片
- (void)setImgaeNameWithMove:(BOOL)isMove
{
    if (isMove)
    {
        [_floatImageView setImage:[UIImage imageNamed:@"assemblytouchHighlight"]];
    }
    else
    {
        [_floatImageView setImage:[UIImage imageNamed:@"assemblytouchNormal"]];
    }
}

#pragma mark - Action
-(void)buttonAction:(UIButton*)sender
{
    [self windowTaped:nil];
    
    if([self.delegate respondsToSelector:@selector(floatButtonClick:)])
    {
        [self.delegate floatButtonClick:sender];
    }
}

#pragma mark - KeyBoard Notification
-(void)keyboardFrameWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _keyBoardSize = kbSize;
    _showKeyBoard = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if (_boardWindow.frame.origin.y + _boardWindow.frame.size.height > windowHight - kbSize.height) {
            [_boardWindow setFrame:CGRectMake(_boardWindow.frame.origin.x, windowHight - kbSize.height - _boardWindow.frame.size.height, 60, 60)];
        }
    }];
}

-(void)keyboardFrameWillHide:(NSNotification *)notification
{
    _showKeyBoard = NO;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [_boardWindow setFrame:_showKeyBoardWindowRect];
    }];
}
@end
