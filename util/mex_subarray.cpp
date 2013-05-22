#include "mex.h"

void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[])
{
     if(nrhs != 2) {
        mexPrintf("in[0] = double(X), in[1] = double(box)\n");
        return;
    }

    double* X = (double*)mxGetPr(in[0]);
    double* box = (double*)mxGetPr(in[1]);
    const int* dims = mxGetDimensions(in[0]);
    int h = dims[0];
    int w = dims[1];
    int x1=box[0]-1;
    int x2=box[2]-1;
    int y1=box[1]-1;
    int y2=box[3]-1;
    
    int bh = y2-y1+1;
    int bw = x2-x1+1;
    
    out[0] = mxCreateDoubleMatrix(bh,bw,mxREAL);
    double* outptr = mxGetPr(out[0]);
    
    int ty = 0;
    int tx = 0;
    for(int x = 0; x < bw; x++){
        for(int y = 0; y< bh; y++){
            
            tx = x+x1;
            ty = y+y1;
            
            //if (tx >= w || ty >= h || tx < 0 || ty < 0)
            //    continue;
            
            // Do intelligent padding:
            tx = tx < w ? tx : w-1;
            ty = ty < h ? ty : h-1;
            tx = tx >= 0 ? tx : 0;
            ty = ty >= 0 ? ty : 0;
            
//             if(y+y1 != ty)
//                 mexPrintf("[%d,%d] / (tx,ty): (%d,%d) --> (%d,%d)\n",x,y,x+x1,y+y1,tx,ty);
            
            outptr[x*bh+y] = X[tx*h + ty];
        }
    }
    
    return;
}