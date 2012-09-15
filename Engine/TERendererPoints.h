#ifndef TERENDERERPOINTS
#define TERENDERERPOINTS

#include "TERendererProgram.h"

class TERenderTarget;

class TERendererPoints : public TERendererProgram {
    
public:
    TERendererPoints();
    TERendererPoints(String vertexSource, String fragmentSource);
    
    virtual void run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount);
};

#endif
