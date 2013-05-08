#include "mex.h"

void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[])
{
     if(nrhs != 3) {
        mexPrintf("in[0] = double(X), in[1] = double(shift = [shifty shiftx], in[2] = fillval)\n");
        return;
    }

    double* X = (double*)mxGetPr(in[0]);
    double* shift = (double*)mxGetPr(in[1]);
    double fillval= ((double*)mxGetPr(in[2]))[0];
    const int* dims = mxGetDimensions(in[0]);
    int h = dims[0];
    int w = dims[1];
    int shiftx= (int)shift[1];
    int shifty= (int)shift[0];
    
    out[0] = mxCreateDoubleMatrix(h,w,mxREAL);
    double* outptr = mxGetPr(out[0]);
    

    int startx = shiftx < 0 ? 0 : shiftx;
    int endx = (w+shiftx) >= w ? w : (w+shiftx);
    int starty = shifty < 0 ? 0 : shifty;
    int endy = (h+shifty) >= h ? h : (h+shifty);
    
    int sstartx = shiftx<0 ? -shiftx : 0;
    int sstarty = shifty<0 ? -shifty : 0;
    
    // fill up with default value:
    for(int k = 0; k < w*h; k++){outptr[k] = fillval;};
    
    // loop over target (tx,ty) simultaneously with source (sx,sy)  
//     mexPrintf("xlim = [%d,%d]\n",startx,endx);
//     mexPrintf("ylim = [%d,%d]\n",starty,endy);
    for(int ty = starty, sy = sstarty; ty < endy; ty++,sy++){
        for(int tx = startx, sx = sstartx; tx < endx; tx++,sx++){
            outptr[tx*h+ty] = X[sx*h + sy];
        }
    }
    
    return;
}