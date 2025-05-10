#include <stdio.h>
#include <cuda_runtime.h>
#include <cudnn.h>
int main() {
    int cuda_version = 0;
    
    // Get the version of the installed CUDA runtime
    cudaRuntimeGetVersion(&cuda_version);
    
    // Print the version in major.minor format
    printf("CUDA Version: %d.%d\n", cuda_version / 1000, (cuda_version % 1000) / 10);
   
    // cuDNN version
    printf("cuDNN Version: %d\n", CUDNN_VERSION);  // CUDNN_VERSION is a predefined macro

    return 0;
}

