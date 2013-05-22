MODEC
=========

Multimodal Decomposable Model for Human Pose Estimation

Ben Sapp and Ben Taskar, CVPR 2013 

http://www.seas.upenn.edu/~bensapp/cvpr13-modec.pdf

      @inproceedings{modec13,
        title={Multimodal Decomposable Models for Human Pose Estimation},
        author={Sapp, Benjamin and Taskar, Ben},
        booktitle={In Proc. CVPR},
        year={2013},
      }

This code provides an end-to-end implementation of the MODEC model trained for upper body human pose estimation---from pixels to joints.

Please go to http://vision.grasp.upenn.edu/cgi-bin/index.php?n=VideoLearning.MODEC for more details.

Usage
--------------
* Run `demo_MODEC.m` to load up an example image, detect a torso, predict joints and display output information.
* Run `eval_dataset.m` to replicate the curves in the [paper].  You will need to download the [FLIC dataset] for this to work.
* Run `train_MODEC.m` to learn a new model from scratch.

Questions / Concerns / Congratulations
-
bensapp @  google . com

License
-

MIT

  [paper]: http://www.seas.upenn.edu/~bensapp/cvpr13-modec.pdf
  [FLIC dataset]: http://vision.grasp.upenn.edu/cgi-bin/index.php?n=VideoLearning.FLIC
