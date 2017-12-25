# GLBS: Group Lasso-Based Band Selection for Hyperspectral Image Classification.
Created by Wentao Bao at Wuhan University.

### Introduction
**GLBS** is an algorithm for band selection and multi-label landcover classification. It is the first that introduces the group lasso algorithm for the band selection problem of multilabel land-cover classification for HSIs. The paper of proposed algorithm (see [GLBS paper](http://ieeexplore.ieee.org/document/8113687/)) has been submited to IEEE Geoscience and Remote Sensing Letters (GRSL).

We have visualized the main results of GLBS on Indian Pines dataset as shown in following picture. GLBS is compared with an unsupervised algorithm [E-FDPC](http://ieeexplore.ieee.org/document/7161371), and two supervised algorithms, [SBMLR](http://www.sciencedirect.com/science/article/pii/S0303243411001371) and [RSBS](http://ieeexplore.ieee.org/abstract/document/7104131).

![](https://raw.githubusercontent.com/Cogito2012/GLBS/master/paper/spectrum_glbs.jpg "Ranking sequences of 80 selected bands")

### License
GLBS is release under the [Apache License 2.0](https://github.com/Cogito2012/GLBS/tree/master/LICENSE). This code is only for academic usage.

### Citing GLBS
If you find GLBS useful in your research, please consider citing:

    @article{GLBS2017, 
        author={D. Yang and W. Bao}, 
        journal={IEEE Geoscience and Remote Sensing Letters}, 
        title={Group Lasso-Based Band Selection for Hyperspectral Image Classification}, 
        year={2017}, 
        volume={14}, 
        number={12}, 
        pages={2438-2442}, 
        month={Dec}
    }

### Contents
1. [Requirements](#requirements)
2. [Preparation](#data-preparation)
3. [Simple Demo](#simple-demo)
4. [Training and Test](#training-and-test)

### Requirements
The code has been tested on Windows 10 (x64) system with MATLAB2013a and MATLAB2016b. To make fully use of our code, you need to prepare these toolkits for MATLAB.
 - **glmnet**. We used [glmnet MATLAB toolkit](http://web.stanford.edu/~hastie/glmnet_matlab) to implement group-lasso algorithm provided by Trevor Hastie at Stanford University. Just unzip glmnet_matlab.zip into MATLAB toolkit directory and add its path to MATLAB.
 - **libsvm**. We used the most widely recognized [libsvm-3.21](https://www.csie.ntu.edu.tw/~cjlin/libsvm) MATLAB interfaces to train Support Vector Machine (SVM) classifier based on GLBS for hyperspectral image classification.

You can also access these toolkits in [Google Drive](https://drive.google.com/drive/folders/1JvXwo2s0BhV9_NMptre4UwY0Rc7Rrz3E) or [Baidu Netdisk](https://pan.baidu.com/s/1kVioSf1)
 
### Data Preparation
We implement our proposed GLBS on two representative hyperspectral image dataset, i.e. Indian Pines, Botswana. You can access them and other datasets with MATLAB data format in [GIC Group](http://www.ehu.eus/ccwintco/index.php?title=Hyperspectral_Remote_Sensing_Scenes). 

In order to run the training and test codes, we have provided code script to generate stardard training and test sets. Just clone this repo and switch MATLAB working directory to data folder in GLBS master (`<ProjectRoot>/data/`), then run the script `script_generate_clsdata.m` after modifying some configurations.

You can also access the source datasets and our prepared datasets by the script in [Google Drive](https://drive.google.com/drive/folders/1SOwxlY6RBkrKAFz2Xfb1SlaF07w2G_Fv) or [Baidu Netdisk](https://pan.baidu.com/s/1kUG48Vt)

### Simple Demo
Just switch to the path `<ProjectRoot>/GLBS/` as MATLAB working directory, then modify the `root_dir` in `script_demo.m` and run the script. Results are recorded in log file at `<ProjectRoot>/results/sequences/`.

### Training and Test
We have provided the training and test scripts for both GLBS algorithm and its reimplementation on SVM or kNN classifier. Just follow instructions in the head of script files at `<ProjectRoot>/GLBS/`. You can also access the trained models and test results in [Google Drive](https://drive.google.com/drive/folders/1_xAvtp2xMIbT1tPP0ftmIrEO_WiPytDj) or [Baidu Netdisk](https://pan.baidu.com/s/1pLLwwh9).

Since group-lasso based model incorporates iterative search for the best coefficient parameter, which is denoted as \lambda described in equation (6) in our paper, we implemented the 10-folds Cross-Validation methods with glmnet for GLBS. Corresponding code scripts are provided in `<ProjectRoot>/GLBSCV`, and you can also access the trained models and test results in [Google Drive](https://drive.google.com/drive/folders/1pZMgdnUhKk2etHr1jBLyXFcu_4O1cgKr) or [Baidu Netdisk](https://pan.baidu.com/s/1boIgKzH)




