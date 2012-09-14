#ifndef TERENDERERLINES
#define TERENDERERLINES

#include "TERendererProgram.h"

class TERenderTarget;

class TERendererLines : public TERendererProgram {
    
public:
    TERendererLines();
    TERendererLines(String vertexSource, String fragmentSource);
    
    virtual void run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount);
};

#endif
