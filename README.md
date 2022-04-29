https://github.com/optas/latent_3d_points/issues/21


    import tensorflow as tf
    print(tf.sysconfig.get_compile_flags(),'\n')
    print(tf.sysconfig.get_link_flags())

Running this gave the error: NotFoundError: undefined symbol: _ZTIN10tensorflow8OpKernelE

It seems to be essentially caused by my versions of CUDA and Tensorflow being newer than the one the author tested on (mine are 9.0 and 1.11.0), These helped me solve the problem: these answers, Tensorflow's guide, and this answer.

I could not use the solutions given in the above articles directly because for some reason my system (Linux Ubuntu 16.04 LTS) would give the error "No such file or directory" for ${TF_CFLAGS[@]} and ${TF_LFLAGS[@]}. It needs the space afer-L and -I. Here's how I fixed it:

    ['-I/usr/local/lib/python2.7/dist-packages/tensorflow/include', '-I/usr/local/lib/python2.7/dist-packages/tensorflow/include/external/nsync/public', '-D_GLIBCXX_USE_CXX11_ABI=1'] 

    ['-L/usr/local/lib/python2.7/dist-packages/tensorflow', '-ltensorflow_framework']
    

I manually replaced what was **-I $(tensorflow)** with the stuff from the first line, added the stuff from the second line to the g++ commands, and changed **-D_GLIBCXX_USE_CXX11_ABI=0** to **-D_GLIBCXX_USE_CXX11_ABI=1**.

makefile:

    nvcc=/usr/local/cuda-9.0/bin/nvcc
    cudalib=/usr/local/cuda-9.0/lib64
    nsync=/usr/local/lib/python2.7/dist-packages/tensorflow/include/external/nsync/public
    TF_INC=/usr/local/lib/python2.7/dist-packages/tensorflow/include
    TF_LIB=/usr/local/lib/python2.7/dist-packages/tensorflow/

    all: tf_approxmatch_so.so tf_approxmatch_g.cu.o tf_nndistance_so.so tf_nndistance_g.cu.o

    tf_approxmatch_so.so: tf_approxmatch_g.cu.o tf_approxmatch.cpp
      g++ -std=c++11 tf_approxmatch.cpp tf_approxmatch_g.cu.o -o tf_approxmatch_so.so -shared -fPIC -I $(TF_INC) -I $(nsync) -lcudart -L $(cudalib) -L $(TF_LIB) -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=1

    tf_approxmatch_g.cu.o: tf_approxmatch_g.cu
      $(nvcc) -std=c++11 -c -o tf_approxmatch_g.cu.o tf_approxmatch_g.cu -I $(TF_INC) -I $(nsync) -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -O2 -D_GLIBCXX_USE_CXX11_ABI=1

    tf_nndistance_so.so: tf_nndistance_g.cu.o tf_nndistance.cpp
      g++ -std=c++11 tf_nndistance.cpp tf_nndistance_g.cu.o -o tf_nndistance_so.so -shared -fPIC -I $(TF_INC) -I $(nsync) -lcudart -L $(cudalib) -L $(TF_LIB) -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=1

    tf_nndistance_g.cu.o: tf_nndistance_g.cu
      $(nvcc) -std=c++11 -c -o tf_nndistance_g.cu.o tf_nndistance_g.cu -I $(TF_INC) -I $(nsync) -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -O2 -D_GLIBCXX_USE_CXX11_ABI=1

    clean:
      rm tf_approxmatch_so.so
      rm tf_nndistance_so.so
      rm  *.cu.o 










---

https://github.com/charlesq34/pointnet-autoencoder/issues/12#issuecomment-692515488

    import tensorflow as tf
    print(tf.sysconfig.get_compile_flags(),'\n')
    print(tf.sysconfig.get_link_flags())


In my case, 
output:

    ['-I/home/sohee/anaconda3/envs/py3/lib/python3.6/site-packages/tensorflow/include', '-D_GLIBCXX_USE_CXX11_ABI=1'] 
    ['-L/home/sohee/anaconda3/envs/py3/lib/python3.6/site-packages/tensorflow', '-l:libtensorflow_framework.so.1']


make ```~/pointnet-autoencoder/tf_ops/tf_compile.sh```

    CUDA_ROOT=/usr/local/cuda-10.0
    TF_INC=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')
    TF_LIB=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')
    CXX11=-D_GLIBCXX_USE_CXX11_ABI=1
    ltensor=-l:libtensorflow_framework.so.1

    $CUDA_ROOT/bin/nvcc approxmatch/tf_approxmatch_g.cu -o approxmatch/tf_approxmatch_g.cu.o -c -O2 -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC

    # TF>=1.4.0
    g++ -std=c++11 approxmatch/tf_approxmatch.cpp approxmatch/tf_approxmatch_g.cu.o -o approxmatch/tf_approxmatch_so.so -shared -fPIC -I$TF_INC/ -I$TF_INC/external/nsync/public -L$TF_LIB $ltensor -I$CUDA_ROOT/include -lcudart -L$CUDA_ROOT/lib64/ -O2 $CXX11

    $CUDA_ROOT/bin/nvcc nn_distance/tf_nndistance_g.cu -o nn_distance/tf_nndistance_g.cu.o -c -O2 -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC

    g++ -std=c++11 nn_distance/tf_nndistance.cpp nn_distance/tf_nndistance_g.cu.o -o nn_distance/tf_nndistance_so.so -shared -fPIC -I$TF_INC/ -I$TF_INC/external/nsync/public -L$TF_LIB $ltensor -I$CUDA_ROOT/include -lcudart -L$CUDA_ROOT/lib64/ -O2 $CXX11

```$ bash tf_compile.sh```
