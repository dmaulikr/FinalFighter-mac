
#import "GameTutorialLayer.h"
#import "GameFont.h"
#import "WorldLayer.h"
#import "GameSoundPlayer.h"
#import "GamePlayer.h"
#import "GameEnemy.h"
#import "GameStats.h"

@implementation GameTutorialLayer
@synthesize worldLayer;

- (id)init
{
	self = [super init];

    CGSize screenSize = [CCDirector sharedDirector].winSize;

    label = [CCLabelBMFont labelWithString:@"" fntFile:GameFontDefault];
    label.anchorPoint = ccp(0, 0);
    label.scale = 0.6f;
    [self addChild:label z:20];

    plabel = [CCLabelBMFont labelWithString:@"" fntFile:GameFontDefault];
    plabel.anchorPoint = ccp(0, 0);
    plabel.scale = 0.6f;
    plabel.visible = NO;
    [self addChild:plabel z:20];

    olabel = [CCLabelBMFont labelWithString:@"" fntFile:GameFontSmall];
    olabel.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:olabel z:20];
    olabel.position = ccp(screenSize.width - 100.0f, 50.0f);

#ifndef PRODUCTION_BUILD
    //step = 10;
#endif
    
    [self update];
    [self schedule: @selector(checkObjectivesTick:) interval:0.2f];

    return self;
}

- (void)playerReturn
{
    if (waitForReturn) {
        [self next];
    }    
}

- (void)next
{
    step++;
    [self update];
}

- (void)resetPlayerStats
{
    GamePlayer *player = worldLayer.player;
    player.collectStats = YES;
    [player resetStats];
}

- (void)checkObjectivesTick:(ccTime)dt
{
    GamePlayer *player = worldLayer.player;

    switch (step) {
        case 1: {
            if (player.statMoveLeft > 1.0f || player.statMoveRight > 1.0f || player.statMoveUp > 1.0f || player.statMoveDown > 1.0f) {
                [self next];
            }
        }
        break;
                    
        case 5: {
            if ((healthPack1 && healthPack1.collectCount) || (healthPack2 && healthPack2.collectCount)) {
                [self next];            
            }
        }
        break;
            
        case 7: {
            if (player.statMoveTurret > 50.0f) {
                [self next];
            }
        }
        break;
        
        case 9: {
            if (player.statFire > 2.0f) {
                [self next];
            }
        }
        break;
        
        case 11: {
            if (enemy && enemy.deathCount >= 1) {
                [self next];            
            }
        }
        break;
        
        case 13: {
            if (player.statCollectGrenade > 0) {
                [self next];
            }
        }
        break;
        
        case 14: {
            if (enemy && enemy.deathCount >= 1) {
                [self next];
            }
        }
        break;

        case 16: {
            if (player.statCollectFlame > 0) {
                [self next];
            }
        }
        break;
        
        case 17: {
            if (enemy && enemy.deathCount >= 1) {
                [self next];
            }
        }
        break;

        case 19: {
            if (player.statCollectRocket > 0) {
                [self next];
            }
        }
        break;
        
        case 20: {
            if (enemy && enemy.deathCount >= 1) {
                [self next];
            }
        }
        break;

        case 23: {
            if (player.statCollectMine > 0) {
                [self next];
            }
        }
        break;
        
        case 24: {
            if (enemy && enemy.deathCount >= 1) {
                [self next];
            }
        }
        break;
    }
}

- (void)update
{
    NSString *oldText = text;
    BOOL oldWaitForReturn = waitForReturn;
    BOOL oldWellDone = wellDone;

    switch (step) {
        case 0: {
            text = @"Welcome to FinalFighter Tutorial";
            waitForReturn = YES;
        }
        break;
        
        case 1: {
            [self resetPlayerStats];
            text = @"Move your tank with the keys [WASD] (or [ZQSD] depending on your keyboard layout)\nor the cursor keys!";
            waitForReturn = NO;
        }
        break;
        
        case 2: {
            wellDone = YES;
            waitForReturn = YES;
        }
        break;
        
        case 3: {
            [self next];
            return;
        }
        break;
        
        case 4: {
            [self next];
            return;
        }
        break;
        
        case 5: {
            text = @"Now collect one of the health packs located on the stairs, to restore your energy!";
            waitForReturn = NO;
            healthPack1 = [[GameItem alloc] initWithPosition:ccp(425.0f, 770.0f) type:kItemRepair layer:worldLayer];
            healthPack2 = [[GameItem alloc] initWithPosition:ccp(597.0f, 770.0f) type:kItemRepair layer:worldLayer];
        }
        break;
        
        case 6: {
            wellDone = YES;
            waitForReturn = YES;
        }
        break;

        case 7: {
            if (healthPack1) {
                [healthPack1 destroy];
                healthPack1 = nil;
            }
            if (healthPack2) {
                [healthPack2 destroy];
                healthPack2 = nil;
            }
            
            [self resetPlayerStats];
            text = @"You can move your tank's turret with your mouse or touchpad.\nTry it! Move your turret around.";
            waitForReturn = NO;
        }
        break;
        
        case 8: {
            wellDone = YES;
            waitForReturn = YES;
        }
        break;
        
        case 9: {
            [self resetPlayerStats];
            text = @"You have one standard weapon: The MACHINE GUN with unlimited bullets.\nPress down your first mouse button to fire!";
            waitForReturn = NO;           
        }
        break;
        
        case 10: {
            wellDone = YES;
            waitForReturn = YES;
        }
        break;
        
        case 11: {
            [self resetPlayerStats];
            text = @"Now destroy this enemy near the stairs with your machine gun!";
            waitForReturn = NO;

            GameStartCoords *coords = [[GameStartCoords alloc] initWithCoords:500.0f y:700.0f rotate:0];
            enemy = [[GameEnemy alloc] initWithLayer:worldLayer tank:5];
            [enemy resetWithStartCoords:coords];
            enemy.inactive = YES;
            enemy.health = 30;
            [coords release];
        }
        break;
        
        case 12: {
            wellDone = YES;
            waitForReturn = YES;
        }
        break;
        
        case 13: {
            [self resetPlayerStats];
            text = @"Now collect the GRENADES located on the stairs!";
            waitForReturn = NO;

            weaponItem = [[GameItem alloc] initWithPosition:ccp(510.0f, 770.0f) type:kItemWeaponGrenade layer:worldLayer];
        }
        break;
        
        case 14: {
            [worldLayer.player.armory consumeItem:kItemWeaponGrenade];
            [worldLayer.player.armory consumeItem:kItemWeaponGrenade];
            [worldLayer.player.armory consumeItem:kItemWeaponGrenade];
            GameWeapon *w = [worldLayer.player.armory getWeapon:kWeaponGrenade];
            [worldLayer.hudLayer setWeapon:w];
            
            [self resetPlayerStats];
            text = @"Good, now use your new weapon to destroy the black tank!";
            waitForReturn = NO;
        
            GameStartCoords *coords = [[GameStartCoords alloc] initWithCoords:500.0f y:700.0f rotate:0];
            enemy = [[GameEnemy alloc] initWithLayer:worldLayer tank:5];
            [enemy resetWithStartCoords:coords];
            enemy.inactive = YES;
            enemy.health = 30;
            [coords release];
        }
        break;

        case 15: {
            if (weaponItem) {
                [weaponItem destroy];
                weaponItem = nil;
            }

            wellDone = YES;
            waitForReturn = YES;
        }
        break;

        case 16: {
            [self resetPlayerStats];
            text = @"Now collect the FLAME THROWER located on the stairs!";
            waitForReturn = NO;
            
            weaponItem = [[GameItem alloc] initWithPosition:ccp(510.0f, 770.0f) type:kItemWeaponFlame layer:worldLayer];
        }
        break;

        case 17: {
            GameWeapon *w = [worldLayer.player.armory getWeapon:kWeaponGrenade];
            [w reset];

            [worldLayer.player.armory consumeItem:kItemWeaponFlame];
            [worldLayer.player.armory consumeItem:kItemWeaponFlame];
            [worldLayer.player.armory consumeItem:kItemWeaponFlame];
            GameWeapon *w2 = [worldLayer.player.armory getWeapon:kWeaponFlame];
            [worldLayer.hudLayer setWeapon:w2];
            
            [self resetPlayerStats];
            text = @"Good, now use your new weapon to destroy the black tank!";
            waitForReturn = NO;
            
            GameStartCoords *coords = [[GameStartCoords alloc] initWithCoords:500.0f y:700.0f rotate:0];
            enemy = [[GameEnemy alloc] initWithLayer:worldLayer tank:5];
            [enemy resetWithStartCoords:coords];
            enemy.inactive = YES;
            enemy.health = 30;
            [coords release];
        }
        break;
            
        case 18: {
            if (weaponItem) {
                [weaponItem destroy];
                weaponItem = nil;
            }
            
            wellDone = YES;
            waitForReturn = YES;
        }
        break;

        case 19: {
            [self resetPlayerStats];
            text = @"Now collect the ROCKET LAUNCHER located on the stairs!";
            waitForReturn = NO;
            
            weaponItem = [[GameItem alloc] initWithPosition:ccp(510.0f, 770.0f) type:kItemWeaponRocket layer:worldLayer];
        }
        break;
            
        case 20: {
            GameWeapon *w = [worldLayer.player.armory getWeapon:kWeaponFlame];
            [w reset];
            
            [worldLayer.player.armory consumeItem:kItemWeaponRocket];
            [worldLayer.player.armory consumeItem:kItemWeaponRocket];
            [worldLayer.player.armory consumeItem:kItemWeaponRocket];
            GameWeapon *w3 = [worldLayer.player.armory getWeapon:kWeaponRocket];
            [worldLayer.hudLayer setWeapon:w3];
            
            [self resetPlayerStats];
            text = @"Good, now use your new weapon to destroy the black tank!";
            waitForReturn = NO;
            
            GameStartCoords *coords = [[GameStartCoords alloc] initWithCoords:500.0f y:700.0f rotate:0];
            enemy = [[GameEnemy alloc] initWithLayer:worldLayer tank:5];
            [enemy resetWithStartCoords:coords];
            enemy.inactive = YES;
            enemy.health = 30;
            [coords release];
        }
        break;

        case 21: {
            if (weaponItem) {
                [weaponItem destroy];
                weaponItem = nil;
            }
            
            wellDone = YES;
            waitForReturn = YES;
        }
        break;
        
        case 22: {
            text = @"You can switch weapons with the number keys 1 to 5, or Q for previous\nweapon and E for next weapon. You can also use your scroll wheel to switch weapons.";
            wellDone = NO;
            waitForReturn = YES;
        }
        break;

        case 23: {
            [self resetPlayerStats];
            text = @"Now collect the MINES located on the stairs!";
            waitForReturn = NO;
            
            weaponItem = [[GameItem alloc] initWithPosition:ccp(510.0f, 770.0f) type:kItemWeaponMine layer:worldLayer];
        }
        break;
        
        case 24: {
            GameWeapon *w = [worldLayer.player.armory getWeapon:kWeaponRocket];
            [w reset];
            
            [worldLayer.player.armory consumeItem:kItemWeaponMine];
            [worldLayer.player.armory consumeItem:kItemWeaponMine];
            [worldLayer.player.armory consumeItem:kItemWeaponMine];
            GameWeapon *w3 = [worldLayer.player.armory getWeapon:kWeaponMine];
            [worldLayer.hudLayer setWeapon:w3];
            
            [self resetPlayerStats];
            text = @"Now try to destroy the black tank by placing mines!";
            waitForReturn = NO;
            
            GameStartCoords *coords = [[GameStartCoords alloc] initWithCoords:500.0f y:700.0f rotate:0];
            enemy = [[GameEnemy alloc] initWithLayer:worldLayer tank:5];
            [enemy resetWithStartCoords:coords];
            enemy.friendly = YES;
            enemy.health = 30;
            [coords release];
        }
        break;
        
        case 25: {
            if (weaponItem) {
                [weaponItem destroy];
                weaponItem = nil;
            }

            [[GameStats getInstance] incInt:@"victoryCount"];
            [[GameStats getInstance] incInt:@"finishTutorial"];
            [[GameStats getInstance] synchronize];
            [worldLayer.challenge markAsDone:0];

            [self resetPlayerStats];
            text = @"";
            wellDone = NO;
            waitForReturn = YES;
            
            CGSize screenSize = [CCDirector sharedDirector].winSize;
            
            CCLabelBMFont *l;
            l = [CCLabelBMFont labelWithString:@"Congratulations!" fntFile:GameFontBig];
            l.opacity = 200.0f;
            l.anchorPoint = ccp(0, 1.0f);
            l.anchorPoint = ccp(0.5f, 0.5f);
            l.position = ccp(screenSize.width / 2.0f, screenSize.height / 2.0f + 50.0f);
            [worldLayer.hudLayer addChild:l z:20];
            
            CCLabelBMFont *l2;
            l2 = [CCLabelBMFont labelWithString:@"You've completed the tutorial.\n You are now ready for battle!" fntFile:GameFontDefault];
            l2.opacity = 200.0f;
            l2.anchorPoint = ccp(0, 1.0f);
            l2.anchorPoint = ccp(0.5f, 0.5f);
            l2.position = ccp(screenSize.width / 2.0f, screenSize.height / 2.0f - 50.0f);
            l2.alignment = kCCTextAlignmentCenter;
            [worldLayer.hudLayer addChild:l2 z:20];
        }
        break;

        case 26: {
            [[CCDirector sharedDirector] popScene];
        }
        break;

        default:
            return;
    }
    
    BOOL hasChanges = waitForReturn != oldWaitForReturn || ![text isEqualToString:oldText];

    if (hasChanges) {
        [[GameSoundPlayer getInstance] play:GameSoundTutorialNext];
    }
    
    if (![text isEqualToString:oldText]) {
        label.string = text;
        label.position = ccp(100.0f, 50.0f);
        [label runAction:[CCFadeIn actionWithDuration:1]];
    }
    
    if (waitForReturn != oldWaitForReturn || wellDone != oldWellDone) {
        if (waitForReturn) {
            if (wellDone) {
                plabel.string = @"Well done! Press SPACEBAR to continue.";
            } else {
                plabel.string = @"Press SPACEBAR to continue.";
            }
            plabel.visible = YES;
            plabel.position = ccp(100.0f, 25.0f);
            [plabel runAction:[CCFadeIn actionWithDuration:1]];
        } else {
            plabel.visible = NO;
        }
    }
}

@end
