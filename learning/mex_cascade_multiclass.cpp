#include "mex.h"
#include "../util/mex_utils.h"
#include <stdio.h>
#include <vector>
#include <algorithm>
#include <cmath>
#define INF FLT_MAX

using namespace std;

/********************* ctrl-c handling ***************/
// NEED TO COMPILE WITH -lut mex FLAG FOR THIS TO WORK.
#if defined (_WIN32)
    #include <windows.h>
#elif defined (__linux__)
    #include <unistd.h>
#endif

#ifdef __cplusplus 
    extern "C" bool utIsInterruptPending();
#else
    extern bool utIsInterruptPending();
#endif
/******************************************************/

pair<float, int> max_argmax(const vector<float>& v){
    float maxval = -INF;
    int argmax = -1;
    for(int i=0; i<v.size(); i++){
        if(v[i] > maxval){
            maxval = v[i];
            argmax = i;
        }
    }
    return pair<float,int>(maxval,argmax);
}

float dot(vector<float>& a, vector<float>& b){
    float v = 0;
    for(int i=0; i< a.size(); i++){
         v += a[i]*b[i];
    }
    return v;
}

void add(vector<float>& a, const vector<float>& b, float scalar){
    for(int i=0; i< a.size(); i++){
        a[i] += scalar*b[i];
    }
}

void mult(vector<float>& a, float scalar){
    for(int i=0; i< a.size(); i++){
        a[i] *= scalar;
    }
}

float norm2(vector<vector<float> >& W){
    float nw = 0;
    for(int i=0; i<W.size();i++){
        for(int j=0; j<W[0].size();j++){
            nw += W[i][j]*W[i][j];
        }
    }
    return nw;
}

float test(const vector<vector<float> >& examples, const vector<int>& labels, vector<vector<float> >& W, float alpha){
    
    float hloss = 0;
    int k = W.size();
    vector<float> scores(k,0.0);

    for(int t=0;t<examples.size(); t++){
        vector<float> example = examples[t];
        int lbl = labels[t];
        for(int i=0;i<k;i++){
            scores[i] = dot(W[i],example);
        }
        // get mean/max of positive scores
        float mean_score = 0;
        for(int i=0; i<k; i++){
            mean_score += scores[i];
        }
        mean_score = mean_score/((float)k);
        pair<float,int> tmp = max_argmax(scores);
        float max_score = tmp.first;
        float max_lbl = tmp.second;
        float gt_score = scores[lbl];
        
        float thresh = alpha*max_score + (1-alpha)*mean_score;
        float hlosst = thresh+1-gt_score;
        hloss += hlosst < 0 ? 0 : hlosst;
    }
    return hloss/examples.size();
}


mxArray* sgd(const vector<vector<float> >& examples, const vector<int>& labels,float alpha, int niters, float lambda){
    
    
    float t0 = 1.0;
   
    int k = *max_element(labels.begin(),labels.end())+1;
    int d = examples[0].size();
    int n = examples.size();
    
    float eta0 = 1000;
//     float lambda = 0.001;
    
    int w_history_counter = 0;
    mxArray* w_history = mxCreateCellMatrix(niters,1);
                
    //init W = 0:
    vector<vector<float> > W;
    for(int i=0;i<k;i++){
        W.push_back(vector<float>(d,0.0));
    }
    
    mexPrintf("W is %d x %d\n",W.size(), W[0].size());

    mexEvalString("tic");
    
    vector<float> scores(k,0.0);
    for(int t = 0; t < niters; t++){
        int randi = rand() % n;
        int lbl = labels[randi];
        vector<float> example = examples[randi];

        for(int i=0;i<k;i++){
          scores[i] = dot(W[i],example);
//           mexPrintf("scores[%d] = %f\n",i,scores[i]);
        }

//         if(t == 1) { return W; }
        
        // get mean/max of positive scores
        float mean_score = 0;
        for(int i=0; i<k; i++){
            mean_score += scores[i];
        }
        mean_score = mean_score/((float)k);
        pair<float,int> tmp = max_argmax(scores);
        float max_score = tmp.first;
        float max_lbl = tmp.second;
        float gt_score = scores[lbl];
        
        float thresh = alpha*max_score + (1-alpha)*mean_score;
 
//      mexPrintf("%f >? %f*%f + (1-%f)*%f\n",gt_score,alpha,max_score,alpha,mean_score);
        
        //regularize: W <-- (1-eta*lambda)*W)
        float eta_t = eta0/(1+lambda*eta0*t);
        
        float r = 1-eta_t*lambda;
//         mexPrintf("r = %f\n",r);
        for(int i=0; i<k; i++){
            mult(W[i],r);
        }
        if(gt_score <= thresh+1){
            // do an update, following equation (13) of journal paper
            add(W[lbl],example,eta_t);
            add(W[max_lbl],example,-alpha*eta_t);
            for(int i=0; i<k; i++){
                add(W[i],example,-(1-alpha)*eta_t/(1.0*k));
            }
        }
        
        // re-norm
        if(t % 100 == 0){
            float normw2 = norm2(W);
            if(normw2 > (1.0/lambda)){
                float s = 1.0/sqrt(lambda*normw2);
                for(int i=0; i<k; i++){
                    mult(W[i],s);
                }
            }
        }
        
        // status update
        if(t % (niters /  100) == 0){
            
            float normw2 = norm2(W);
            float hloss = test(examples,labels,W,alpha);
            float obj = 0.5*lambda*normw2 + hloss;
            
            mexPrintf("iter %.03e/%.01e, normw2 = %.03f, hloss = %.03f, obj = %0.03f, eta_t = %f\n",1.0*t,1.0*niters,normw2,hloss,obj,eta_t);
            mexEvalString("toc");
            mexEvalString("tic");
            
            mexEvalString("pause(0.00001)");            
            
        }
        
        
        // snapshot of current W to send back to user
        if(t % (niters /  100) == 0){
            mxSetCell(w_history, w_history_counter++,vectorToMxArray(W));
        }
        
        // CTRL-C check
        if((t % 100 == 0) && utIsInterruptPending()) {
            mexPrintf("Ctrl-C Detected. Quitting!\n\n");
            return w_history;
        }
     
//         
//         for(int j=0; j<d;j++){
//             for(int i=0; i<k;i++){
//                 mexPrintf("%.03f ",W[i][j]);
//             }
//             mexPrintf("\n");
//         }

    }
    return w_history;
}

void mexFunction(int nlhs, mxArray *out[], int nrhs, const mxArray *in[]){
    srand(0);
    
    if(nrhs != 5){
        mexErrMsgTxt("need 5 arguments: (X, y, alpha, # iters, lambda), all double");
    }
        
    
    vector<vector<float> > examples = mxarrayToVector(in[0]);
    vector<float> labelsf = mxarrayToVector(in[1])[0];
    vector<int> labels;
    double alpha = mxGetPr(in[2])[0];
    double niters = mxGetPr(in[3])[0];
    float lambda = mxGetPr(in[4])[0];
    


    mexPrintf("X is %d x %d\n",examples.size(), examples[0].size());
    
    //convert to C-based indexing, and integer labels
    for(int i = 0; i<labelsf.size(); i++){ 
        labels.push_back(labelsf[i]-1); 
//         mexPrintf("labels[%d] = %d\n",i,labels[i]);
    }
    

    // parse examples
	out[0] = sgd(examples, labels,(float)alpha,(int)niters,(float)lambda);
// 	out[0] = vectorToMxArray(W);
}


