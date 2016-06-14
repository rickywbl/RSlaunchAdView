//
//  RSLaunchAdView.m
//  RSlaunchAdViewController
//
//  Created by 王保霖 on 16/6/14.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "RSLaunchAdView.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>

@interface RSLaunchAdView(){
    
    NSUInteger duration;
}

@property(nonatomic,strong)UIImageView * adImageView;
@property(nonatomic,strong)UIWindow * window;
@property(nonatomic,strong)UIButton *timeButton;
@property(nonatomic,strong) CAShapeLayer * shapelayer;
@end

@implementation RSLaunchAdView


-(UIImageView *)adImageView{
    
    if(_adImageView == nil){
        
        _adImageView = [[UIImageView alloc]init];
        _adImageView.userInteractionEnabled = YES;
        [self addSubview: self.adImageView];
 
    }
    
    return _adImageView;
}

-(UIButton *)timeButton{
    
    if(_timeButton == nil){
        
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_timeButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_timeButton setTitleColor:RSTimeButtonTitleColor forState:UIControlStateNormal];
        _timeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _timeButton.backgroundColor = RSTimeButtonBackgroundColor;

        _timeButton.layer.cornerRadius = 15;
        _timeButton.clipsToBounds = YES;
        _timeButton.frame = CGRectMake(CGRectGetWidth(self.adImageView.frame) - 40,20, 30, 30);
        [_timeButton addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _timeButton;
}

-(void)skipAction:(UIButton *)sender{
    
    
    if([self.delegate respondsToSelector:@selector(RSLaunchAdView:didSelectItem:)]){
    
        [self.delegate RSLaunchAdView:self didSelectItem:RSAdSelectSkipItem];
    }

    [self RemoveAD];

}

-(void)RemoveAD{

    [UIView animateWithDuration:1 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        [self removeFromSuperview];
        [self.shapelayer removeAllAnimations];
        
    }];
}



-(instancetype)initWithWindow:(UIWindow *)window AdImageUrl:(NSString *)adUrl{

    
    if(self = [super init]){
    
        self.window = window;
        
        [window makeKeyAndVisible];
        

        CGSize ViewSize = self.window.bounds.size;
        self.frame = CGRectMake(0, 0, RSmainWidth, RSmainHeight);
        
        
        NSString *viewOrientation = @"Portrait";
        
        NSString *launchImageName = nil;

        //设置背景和启动图一致
        
        NSArray *launchArr =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchImages"];
        
        for (NSDictionary* dict in launchArr)
            
        {
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, ViewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
                
            {
                launchImageName = dict[@"UILaunchImageName"];
            }
            
        }
        UIImage * launchImage = [UIImage imageNamed:launchImageName];
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:launchImage]];
        

        //设置广告图片
        
        self.adImageView.frame = CGRectMake(0, 0, RSmainWidth, RSmainHeight);
        
        //设置倒计时按钮
        
        [self.adImageView addSubview:self.timeButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adSelectAction)];
        
        [self.adImageView addGestureRecognizer:tap];
        
        
        
        self.shapelayer = [CAShapeLayer layer];

        UIBezierPath *BezierPath = [UIBezierPath bezierPathWithOvalInRect:self.timeButton.bounds];
        self.shapelayer.lineWidth = 2;
        self.shapelayer.strokeColor = RSDefauleCircleColor.CGColor;
        self.shapelayer.fillColor = [UIColor clearColor].CGColor;
        self.shapelayer.path = BezierPath.CGPath;
        [self.timeButton.layer addSublayer:self.shapelayer];
        

        
        
        //下载广告图片
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:[NSURL URLWithString:adUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
  
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
            if(image){
            
                    self.adImageView.image = image;
            }
        
        }];
        
        [self.window addSubview:self];
 
    }

    return  self;
}

-(void)adSelectAction{

    if([self.delegate respondsToSelector:@selector(RSLaunchAdView:didSelectItem:)]){
        
        [self.delegate RSLaunchAdView:self didSelectItem:RSAdSelectADItem];
    }
    
}


-(void)layoutSubviews{

    if([self.delegate respondsToSelector:@selector(RSLaunchAdViewRect)]){
        
        self.adImageView.frame = [self.delegate RSLaunchAdViewRect];
    }
    
    _timeButton.frame = CGRectMake(CGRectGetWidth(self.adImageView.frame) - 40,20, 30, 30);
    
    [self animation];
    
    
}


-(void)animation{

    //设置动画
    CABasicAnimation *pathAnimaton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    if([self.delegate respondsToSelector:@selector(RSLaunchAdViewShowDuration)]){
        
        duration = [self.delegate RSLaunchAdViewShowDuration];
    }else{
        
        duration = RSDefauleDuration;
    }
    
    pathAnimaton.duration = duration;
    pathAnimaton.fromValue = @(0.0f);
    pathAnimaton.toValue = @(1.0f);
    
    pathAnimaton.delegate = self;
    
    [pathAnimaton setValue:@"progressAnimation" forKey:@"animatonName"];
    
    [self.shapelayer addAnimation:pathAnimaton forKey:nil];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if([[anim valueForKey:@"animatonName"] isEqualToString:@"progressAnimation"]){
    
        [self RemoveAD];
        if([self.delegate respondsToSelector:@selector(RSLaunchAdView:didSelectItem:)]){
            
            [self.delegate RSLaunchAdView:self didSelectItem:RSAdTimeOutItem];
        }
    }
    
    
}

@end
