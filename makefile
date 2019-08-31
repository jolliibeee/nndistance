nvcc=/usr/local/cuda-9.0/bin/nvcc
cudalib=/usr/local/cuda-9.0/lib64
nsync=/home/sohee/anaconda3/envs/python3/lib/python3.6/site-packages/tensorflow/include/external/nsync/public
#TF_INC= $(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')
#TF_LIB= $(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')
TF_INC=/home/sohee/anaconda3/envs/python3/lib/python3.6/site-packages/tensorflow/include
TF_LIB=/home/sohee/anaconda3/envs/python3/lib/python3.6/site-packages/tensorflow
tensorflow=/home/sohee/anaconda3/envs/python3/lib/python3.6/site-packages/tensorflow/include

all: tf_approxmatch_so.so tf_approxmatch_g.cu.o tf_nndistance_so.so tf_nndistance_g.cu.o

tf_approxmatch_so.so: tf_approxmatch_g.cu.o tf_approxmatch.cpp
	g++ -std=c++11 tf_approxmatch.cpp tf_approxmatch_g.cu.o -o tf_approxmatch_so.so -shared -fPIC -I $(tensorflow) -lcudart -L $(cudalib) -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -L$(TF_LIB) -ltensorflow_framework


tf_approxmatch_g.cu.o: tf_approxmatch_g.cu
	$(nvcc) -D_GLIBCXX_USE_CXX11_ABI=0 -std=c++11 -c -o tf_approxmatch_g.cu.o tf_approxmatch_g.cu -I $(tensorflow) -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -O2


tf_nndistance_so.so: tf_nndistance_g.cu.o tf_nndistance.cpp
	g++ -std=c++11 tf_nndistance.cpp tf_nndistance_g.cu.o -o tf_nndistance_so.so -shared -fPIC -I $(tensorflow) -lcudart -L $(cudalib) -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -L$(TF_LIB) -ltensorflow_framework


tf_nndistance_g.cu.o: tf_nndistance_g.cu
	$(nvcc) -D_GLIBCXX_USE_CXX11_ABI=0 -std=c++11 -c -o tf_nndistance_g.cu.o tf_nndistance_g.cu -I $(tensorflow) -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -O2

clean:
	rm tf_approxmatch_so.so
	rm tf_nndistance_so.so
	rm  *.cu.o


#all: tf_approxmatch_so.so tf_approxmatch_g.cu.o tf_nndistance_so.so tf_nndistance_g.cu.o

#tf_approxmatch_so.so: tf_approxmatch_g.cu.o tf_approxmatch.cpp
#	g++ -std=c++11 tf_approxmatch.cpp tf_approxmatch_g.cu.o -o tf_approxmatch_so.so -shared -fPIC -I $(TF_INC) -I $(nsync) -lcudart -L $(cudalib) -L $(TF_LIB) -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=0

#tf_approxmatch_g.cu.o: tf_approxmatch_g.cu
#	$(nvcc) -std=c++11 -c -o tf_approxmatch_g.cu.o tf_approxmatch_g.cu -I $(TF_INC) -I $(nsync) -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -O2 -D_GLIBCXX_USE_CXX11_ABI=0

#tf_nndistance_so.so: tf_nndistance_g.cu.o tf_nndistance.cpp
#	g++ -std=c++11 tf_nndistance.cpp tf_nndistance_g.cu.o -o tf_nndistance_so.so -shared -fPIC -I $(TF_INC) -I $(nsync) -lcudart -L $(cudalib) -L $(TF_LIB) -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=0

#tf_nndistance_g.cu.o: tf_nndistance_g.cu
#	$(nvcc) -std=c++11 -c -o tf_nndistance_g.cu.o tf_nndistance_g.cu -I $(TF_INC) -I $(nsync) -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -O2 -D_GLIBCXX_USE_CXX11_ABI=0

#clean:
#	rm tf_approxmatch_so.so
#	rm tf_nndistance_so.so
#	rm  *.cu.o 
