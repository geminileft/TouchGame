#include "RenderImage.h"
#include "../../Engine/Engine/TERenderer.h"
#include "../../Engine/Engine/TEGameObject.h"
#include "../../Engine/Engine/TEEventListener.h"
#include "../../Engine/Engine/TEManagerTexture.h"
#include "../../Engine/Engine/TERenderTarget.h"
#include <QuartzCore/QuartzCore.h>
#include <UIKit/UIKit.h>

RenderImage::RenderImage(NSString* resourceName, TEPoint position, TESize size)
: TEComponentRender() {
    UIImage* image = [UIImage imageNamed:resourceName];
    mTextureName = TEManagerTexture::GLUtexImage2D([image CGImage], String([resourceName UTF8String]));
    
    const float leftX = -(float)size.width / 2;
	const float rightX = leftX + size.width;
	const float bottomY = -(float)size.height / 2;
	const float topY = bottomY + size.height;

    mVertexBuffer[0] = leftX;
	mVertexBuffer[1] = bottomY;
	mVertexBuffer[2] = rightX;
	mVertexBuffer[3] = bottomY;
	mVertexBuffer[4] = rightX;
	mVertexBuffer[5] = topY;
	mVertexBuffer[6] = leftX;
	mVertexBuffer[7] = topY;

    mTextureBuffer[0] = (position.x) / image.size.width;//left
	mTextureBuffer[1] = (position.y + size.height) / image.size.height;//top
	mTextureBuffer[2] = (position.x + size.width) / image.size.width;//right
	mTextureBuffer[3] = (position.y + size.height) / image.size.height;//top
	mTextureBuffer[4] = (position.x + size.width) / image.size.width;//right
	mTextureBuffer[5] = position.y / image.size.height;//bottom
	mTextureBuffer[6] = (position.x) / image.size.width;//left
	mTextureBuffer[7] = position.y / image.size.height;//bottom
}

void RenderImage::update() {}

void RenderImage::draw() {
    mRenderPrimative.textureName = mTextureName;
    mRenderPrimative.position.x = mParent->position.x;
    mRenderPrimative.position.y = mParent->position.y;
    mRenderPrimative.position.z = 0;
    mRenderPrimative.vertexCount = 4;
    mRenderPrimative.vertexBuffer = mVertexBuffer;
    mRenderPrimative.textureBuffer = mTextureBuffer;
    mRenderPrimative.extraData = getExtraData();
    mRenderPrimative.extraType = getExtraType();
    getRenderTarget()->addPrimative(mRenderPrimative);
}

void RenderImage::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};
