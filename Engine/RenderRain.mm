#include "RenderRain.h"
#include "TERenderer.h"
#include "TEGameObject.h"
#include "TEEventListener.h"
#include "TERenderTarget.h"
#include "TEManagerTime.h"

RenderRain::RenderRain(uint drops) : TEComponentRender(), mDropCount(drops) {
    initialize();
    for (int i = 0;i < mDropCount; ++i) {
        mRenderPrimatives[i].vertexBuffer = NULL;
    }
}

void RenderRain::update() {
    for (int i = 0;i < mDropCount; ++i) {
        if (mRainDrops[i].mTicksToAlive > 0) {
            --mRainDrops[i].mTicksToAlive;
        } else {
            mRainDrops[i].mY += floor(mRainDrops[i].mDirection.y * mRainDrops[i].getSpeed());
            if (mRainDrops[i].mY < -160.0f) {
                mRainDrops[i].reset();
                mRenderPrimatives[i].color = mRainDrops[i].getColor();
            }
            float length = mRainDrops[i].mLength;
            mRenderPrimatives[i].position.x = mParent->position.x + length / 2;
            mRenderPrimatives[i].position.y = mParent->position.y;

            int memSize = 4 * sizeof(float);
            if (mRenderPrimatives[i].vertexBuffer) {
                free(mRenderPrimatives[i].vertexBuffer);
            }
            mRenderPrimatives[i].vertexCount = 2;
            mRenderPrimatives[i].vertexBuffer = (float*)malloc(memSize);
            float vertices[] = {
                mRainDrops[i].mX
                , mParent->position.y + length / 2 + mRainDrops[i].mY
                , mRainDrops[i].mX
                , mParent->position.y - length / 2 + mRainDrops[i].mY
            };
            memcpy(mRenderPrimatives[i].vertexBuffer, vertices, memSize);
            mRenderPrimatives[i].extraType = ShaderLines;
            getRenderTarget()->addPrimative(mRenderPrimatives[i]);
        }
    }
}

void RenderRain::draw() {
}

void RenderRain::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};

RenderRain::~RenderRain() {
    free(mRainDrops);
    free(mRenderPrimatives);
}

void RenderRain::initialize() {
    mRainDrops = (RainDrop*)malloc(mDropCount * sizeof(RainDrop));
    mRenderPrimatives = (TERenderPrimative*)malloc(mDropCount * sizeof(TERenderPrimative));
    srand(TEManagerTime::currentTime());
    for (int i = 0;i < mDropCount; ++i) {
        RainDrop drop;
        drop.reset();
        mRainDrops[i] = drop;
        mRenderPrimatives[i].textureBuffer = NULL;
        mRenderPrimatives[i].extraData = NULL;
        mRenderPrimatives[i].colorData = NULL;
        mRenderPrimatives[i].vertexCount = 0;
        mRenderPrimatives[i].color = drop.getColor();
    }
}
