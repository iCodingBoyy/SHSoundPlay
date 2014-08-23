//
//  SHSoundPlay.h
//  MCSoundBoard
//
//  Created by 马远征 on 14-8-23.
//  Copyright (c) 2014年 MobileCreators. All rights reserved.
//

// 本代码使用Baglan Dosmagambetov的MCSoundBoard，请尊重原作者的知识产权。

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



@interface SHSoundPlay : NSObject
+ (AVAudioPlayer *)audioPlayerForKey:(id)key;

+ (void)addSoundAtPath:(NSString*)filePath forKey:(id)key;
+ (void)addAudioAtPath:(NSString*)filePath forKey:(id)key;

+ (void)removeSoundForKey:(id)key;
+ (void)removeAudioForKey:(id)key;

+ (void)playSoundForKey:(id)key;
+ (void)playAudioForKey:(id)key;

+ (void)stopAudioForKey:(id)key;
+ (void)pauseAudioForKey:(id)key;

+ (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval;
+ (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
+ (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
@end
