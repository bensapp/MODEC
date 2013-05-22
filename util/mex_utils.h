#pragma once
#include "mex.h"
#include <vector>
using namespace std;

// Converts a Matlab matrix to an stl vector
mxArray* vectorToMxArray(vector<vector<float> > &x) {
    int nRows = x.size();  // i.e., number of rows
    
    if(nRows == 0) {
        mxArray* m = mxCreateDoubleMatrix(0, 0, mxREAL);
        return m;
    }
    
    int nCols = x[0].size();
    
    mxArray* m = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    for (int i=0; i < nRows; i++) {
        for (int j=0; j < nCols; j++) {
            mxGetPr(m)[j*nRows + i] = x[i][j];
        }
    }
    
    return m;
}

// Converts a Matlab matrix to an stl vector
mxArray* vectorToMxArray(vector<vector<double> > &x) {
    int nRows = x.size();  // i.e., number of rows
    
    if(nRows == 0) {
        mxArray* m = mxCreateDoubleMatrix(0, 0, mxREAL);
        return m;
    }
    
    int nCols = x[0].size();
    
    mxArray* m = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    for (int i=0; i < nRows; i++) {
        for (int j=0; j < nCols; j++) {
            mxGetPr(m)[j*nRows + i] = x[i][j];
        }
    }
    
    return m;
}

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

// Converts a Matlab matrix to an stl vector
vector<vector<float> > mxarrayToVector(const mxArray* m) {
    const int* dims = mxGetDimensions(m);

    int nRows = dims[0];
    int nCols = dims[1];

    //one vector per row of m
    vector<vector<float> > out;
    for (int i=0; i < nRows; i++) {
        out.push_back(vector<float>(nCols,0.0));
        for (int j=0; j < nCols; j++) {
            out[i][j] = (float)mxGetPr(m)[j*nRows + i];
        }
    }
    
    return out;
}
