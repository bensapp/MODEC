Ben Sapp
bensapp@cis.upenn.edu
September 5, 2012

This is a 'lite' version of the Berkeley poselets detector, from
http://www.cs.berkeley.edu/~lbourdev/poselets/
specific version
http://www.cs.berkeley.edu/~lbourdev/poselets/poselets_h3d_code2.june17_2011.tar.gz

It has several speedups while maintaining exact numerical equivalancy.  This results in the given test image being processed in ~3 seconds instead of ~11 seconds in the 'faster_detection=true' mode.  
In addition, any non-essential functions and files were removed.

Speed Improvements:
- mex'd version of the KL divergence computation to compute Q-scores
- reuse this computed KL divergence for the linkage step, instead of recomputing 
- turned on config.USE_MEX_HOG by default, and recompiled  compute_hog_mex.mexa64 so it works

Results on test.jpg provided, running demo_poselets.m:

*before*
Computing pyramid HOG (hint: You can cache this)... Done in 1.99 secs.
Detecting poselets... Done in 1.04 secs.
Big Q...Done in 3.83 secs.
Clustering poselets... Done in 3.36 secs.
Predicting bounding boxes... Done in 0.34 secs.
Total time: 10.566993 secs

*after*
Computing pyramid HOG (hint: You can cache this)... Done in 0.74 secs.
Detecting poselets... Done in 1.02 secs.
Big Q...Done in 0.15 secs.
Clustering poselets... Done in 0.64 secs.
Predicting bounding boxes... Done in 0.28 secs.
Total time: 2.830089 secs


--------- README from original poselets work:

This folder contains self-sufficient Matlab code to demonstrate the H3D dataset and detection using poselets.
For H3D demo please run demo_annotation_tools.m
For poselet demo please run demo_poselets.

The code is distributed with non-commercial license. Please see the associated license file.
For questions or comments please email Lubomir Bourdev at lubomir.bourdev@gmail.com

