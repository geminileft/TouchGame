#ifndef RENDERRAIN
#define RENDERRAIN

#include "TEComponentRender.h"
#include "TETypes.h"

#define MAX_RAINDROP_SPEED 3.0f
#define MIN_SIZE 0.75f
#define SPEED_INTERVAL 50.0f
#define MIN_SPEED 1.0f

struct RainDrop {
    float mX;
    float mY;
    float mZ;
    float mSpeedFactor;
    uint mTicksToAlive;
    TEVec3 mDirection;
    float mLength;

    void reset() {
        long rd = rand();
        float xMod = abs(rd) % 480;
        mX = xMod - 240;
        mY = 160 + (rd % 26);
        mZ = 0;
        float speedAdd = rd % (int)MAX_RAINDROP_SPEED;
        mSpeedFactor = MIN_SPEED + speedAdd;
        mDirection.x = 0;
        mDirection.y = -1;
        mTicksToAlive = rd % 450;
        mLength = (3.5f / (float)(1 + ((int)rd % 50))) + (MIN_SIZE / 2.0f);
    }

    float getSpeed() {
        float rd = (1.0f + (abs(rand()) % 10)) * 0.1f;
        
        return mSpeedFactor + rd;
    }
    
    TEColor4 getColor() {
        float a = mSpeedFactor == 0 ? 0 : (mSpeedFactor * (1.0f / MAX_RAINDROP_SPEED));
        return TEColor4Make(1.0f, 1.0f, 1.0f, a);
    }
    
    float getAlpha() {
        float a = mSpeedFactor == 0 ? 0 : (mSpeedFactor * (1.0f / MAX_RAINDROP_SPEED));
        if (a == 1.0f) {
            NSLog(@"1.0f alpha");
        }
        return a;
    }
    
};

typedef struct RainDrop RainDrop;

class TEUtilTexture;

class RenderRain : public TEComponentRender {
private:
    TERenderPrimative* mRenderPrimatives;
    uint mDropCount;
    RainDrop* mRainDrops;

    void initialize();

public:
    RenderRain(uint drops);
    ~RenderRain();
    virtual void update();
    virtual void draw();
	void moveToTopListener();
};
#endif