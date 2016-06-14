//
//  RSLaunchAdView.h
//  RSlaunchAdViewController
//
//  Created by 王保霖 on 16/6/14.
//  Copyright © 2016年 Ricky. All rights reserved.
//


#define RSmainHeight      [[UIScreen mainScreen] bounds].size.height
#define RSmainWidth       [[UIScreen mainScreen] bounds].size.width
#define RSDefauleDuration 6

#define RSDefauleCircleColor [UIColor redColor]
#define RSTimeButtonTitleColor [UIColor blackColor]
#define RSTimeButtonBackgroundColor [UIColor whiteColor]

typedef enum {

    RSAdSelectADItem,
    RSAdSelectSkipItem,
    RSAdTimeOutItem
    
}RSAdSelectItem;



#import <UIKit/UIKit.h>
@class RSLaunchAdView;

@protocol RSLaunchAdViewDelegate <NSObject>

@optional
//默认是全屏
-(CGRect)RSLaunchAdViewRect;
-(NSUInteger)RSLaunchAdViewShowDuration;//默认6秒
-(void)RSLaunchAdView:(RSLaunchAdView *)view didSelectItem:(RSAdSelectItem)item;

@end


@interface RSLaunchAdView : UIView<UITabBarDelegate>
@property(nonatomic,weak)id delegate;

-(instancetype)initWithWindow:(UIWindow *)window AdImageUrl:(NSString *)adUrl;

@end
