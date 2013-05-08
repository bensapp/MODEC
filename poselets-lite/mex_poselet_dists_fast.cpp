#include "mex.h"
#define INF 1E+36

inline int isnan(float t){ return (t != t); }
inline float max(float t1, float t2){ return (t1 > t2 ? t1 : t2); }
inline float min(float t1, float t2){ return (t1 < t2 ? t1 : t2); }

void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[])
{
     if(nrhs != 8) {
        mexPrintf("call with (mu_x,mu_y,sigma_x,sigma_y,rectx1,recty1,rectx2,recty2)\n");
        return;
    }

    float* mu_x = (float*)mxGetPr(in[0]);
    float* mu_y = (float*)mxGetPr(in[1]);
    float* sigma_x = (float*)mxGetPr(in[2]);
    float* sigma_y = (float*)mxGetPr(in[3]);
    
    float* rectx1 = (float*)mxGetPr(in[4]);
    float* recty1 = (float*)mxGetPr(in[5]);
    float* rectx2 = (float*)mxGetPr(in[6]);
    float* recty2 = (float*)mxGetPr(in[7]);
    
    const int* dims = mxGetDimensions(in[0]);
    int n_d = dims[0]; // should be 20; i.e. number of keypoints
    int n = dims[1]; // # of poselet hits
    
    
    out[0] = mxCreateDoubleMatrix(n,n,mxREAL);
    double* outptr = mxGetPr(out[0]);
    
    
    for(int i=0; i < n; i++){
        for(int j=i+1; j<n; j++){
//             mexPrintf("[%d,%d], no overlap IF x: %f < %f and y: %f < %f\n",i+1,j+1,max(rectx1[i],rectx1[j]), min(rectx2[i],rectx2[j]),max(recty1[i],recty1[j]),min(recty2[i],recty2[j]));

            //rectangle overlap check:
            if (!(max(rectx1[i],rectx1[j]) < min(rectx2[i],rectx2[j]) && max(recty1[i],recty1[j]) < min(recty2[i],recty2[j]))){
                outptr[j*n+i] = INF;
                continue;
            }
            
            float dk = 0.0;
            int dkc = 0;
            for(int k=0; k<n_d; k++){
                
                int indi = i*n_d+k;
                int indj = j*n_d+k;
                
                float meandiff2_x = mu_x[indi]-mu_x[indj];
                meandiff2_x = meandiff2_x*meandiff2_x;
                float dkx = (sigma_x[indi]+meandiff2_x)/sigma_x[indj] + (sigma_x[indj]+meandiff2_x)/sigma_x[indi] - 2;
                if(isnan(dkx)) { continue; }
                
                float meandiff2_y = mu_y[indi]-mu_y[indj];
                meandiff2_y = meandiff2_y*meandiff2_y;
                float dky = (sigma_y[indi]+meandiff2_y)/sigma_y[indj] + (sigma_y[indj]+meandiff2_y)/sigma_y[indi] - 2;
//                 mexPrintf("dky[%02d] = %f\n",k,dky);

                if(isnan(dky)) { continue; }
                
                dk += (dkx+dky)/2.0;
                dkc++;
            }

            outptr[j*n+i] = dk/((float)dkc);

        }
    }

    
    
    return;
}