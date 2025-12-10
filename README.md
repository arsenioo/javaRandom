cpp compile:

g++ -std=c++11 -O3 -march=native -ffast-math -funroll-loops -flto test.cpp -o test_cpp


dart compile:

dart compile exe ./test.dart -o test_dart


java compile:

javac ./Main.java


time measuring: time ./test_cpp

