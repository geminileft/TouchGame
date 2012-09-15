#include "TERenderTarget.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "TEUtilMatrix.h"
#include "TEManagerProfiler.h"

TERenderTarget::TERenderTarget(uint frameBuffer, bool rotate) : mFrameBuffer(frameBuffer), mShaderData(NULL), mRotate(rotate) {}

void TERenderTarget::setSize(TESize size) {
    float angle;
    float zDepth;
    float ratio;
    
    mFrameWidth = size.width;
    mFrameHeight = size.height;
    
    if (mRotate) {
        mFrameHeight = size.width;
        mFrameWidth = size.height;
    }
    
    zDepth = (float)mFrameHeight / 2;
    ratio = (float)mFrameWidth/(float)mFrameHeight;
    
    if (mRotate) {
        angle = -90.0f;
    } else {
        angle = 0.0f;
    }
    TEUtilMatrix::setFrustum(&mProjMatrix[0], ColumnMajor, -ratio, ratio, -1, 1, 1.0f, 1000.0f);
    float rotateMatrix[16];
    float depthMatrix[16];
    TEUtilMatrix::setIdentity(&rotateMatrix[0]);
    TEUtilMatrix::setRotateZ(&rotateMatrix[0], ColumnMajor, deg2rad(angle));
    TEUtilMatrix::setTranslate(&depthMatrix[0], ColumnMajor, 0.0f, 0.0f, -zDepth);
    TEUtilMatrix::multiply(&mViewMatrix[0], ColumnMajor, &depthMatrix[0], &rotateMatrix[0]);
    //TEUtilMatrix::multiply(&mViewMatrix[0], ColumnMajor, &rotateMatrix[0], &depthMatrix[0]);
}

uint TERenderTarget::getFrameBuffer() const {
    return mFrameBuffer;
}

float TERenderTarget::getFrameWidth() const {
    return mFrameWidth;
}

float TERenderTarget::getFrameHeight() const {
    return mFrameHeight;
}

void TERenderTarget::resetPrimatives() {
    mShaders.clear();
}

void TERenderTarget::activate() {
    glViewport(0, 0, mFrameWidth, mFrameHeight);
    glBindFramebuffer(GL_FRAMEBUFFER, mFrameBuffer);
}

float* TERenderTarget::getProjMatrix() {
    return mProjMatrix;
}

float* TERenderTarget::getViewMatrix() {
    return mViewMatrix;
}

void TERenderTarget::addPrimative(TERenderPrimative primative) {
    TEShaderType type = ShaderNone;
    std::vector<TERenderPrimative> primatives;
    
    if (primative.textureBuffer == NULL) {
        type = primative.extraType;
    } else {
        if (primative.extraData != NULL) {
            type = primative.extraType;
        } else {
            type = ShaderTexture;
        }
    }
    if (mShaders.count(type) > 0)
        primatives = mShaders[type];
    primatives.push_back(primative);
    mShaders[type] = primatives;
}

TEShaderData* TERenderTarget::getShaderData(uint &count) {
    TEShaderData data;
    std::vector<TERenderPrimative> prims;
    std::vector<TERenderPrimative>::iterator primIterator;
    
    if (mShaderData != NULL)
        free(mShaderData);
    count = mShaders.size();
    
    uint shaderCount = 0;
    uint renderables = 0;
    if (count > 0) {
        mShaderData = (TEShaderData*)malloc(sizeof(TEShaderData) * count);
        std::map<TEShaderType, std::vector<TERenderPrimative> >::iterator iterator;
        for (iterator = mShaders.begin(); iterator != mShaders.end(); iterator++) {
            data.type = (*iterator).first;
            prims = (*iterator).second;
            data.primativeCount = prims.size();
            data.primatives = (TERenderPrimative*)malloc(data.primativeCount * sizeof(TERenderPrimative));
            renderables = 0;
            for (primIterator = prims.begin(); primIterator != prims.end(); primIterator++) {
                data.primatives[renderables] = (*primIterator);
                ++renderables;
            }
            memcpy(&mShaderData[shaderCount], &data, sizeof(TEShaderData));
            ++shaderCount;
        }
    }
    return mShaderData;
}
