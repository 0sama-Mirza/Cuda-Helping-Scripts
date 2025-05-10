Certainly! There are several ways to execute your compiled CUDA and MPI program, depending on how you've set up your environment, how many processes you want to run, and how you want to manage resources. Below are the different ways you can execute your program after it has been compiled using `nvcc`.

### **1. Execute on a Single Node with Multiple Processes**
   This is the most common way to run your MPI program, especially if you're working on a single machine with multiple cores.

   - **Command:**
     ```bash
     mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1
     ```
   
   **Explanation:**
   - `mpirun` launches MPI processes.
   - `-np 4` specifies that you want to run 4 processes.
   - `-x CUDA_VISIBLE_DEVICES=0,1,2,3` makes the GPUs available to the program (this will allow your program to access GPUs 0, 1, 2, and 3).
   - `./Task1` is the compiled executable.

   If you don’t specify `CUDA_VISIBLE_DEVICES`, your program will use the default device or all available devices.

### **2. Run with Fewer Processes (e.g., 2 Processes)**
   If you're testing or want to run with fewer processes, change the `-np` option.

   - **Command:**
     ```bash
     mpirun -np 2 -x CUDA_VISIBLE_DEVICES=0,1 ./Task1
     ```

   This runs the program with 2 processes and assigns two GPUs (0 and 1) to those processes.

### **3. Run Without CUDA (MPI-Only Execution)**
   If you're testing just the MPI part of the program (without the GPU), you can run it without specifying `CUDA_VISIBLE_DEVICES`:

   - **Command:**
     ```bash
     mpirun -np 4 ./Task1
     ```

   This will run 4 MPI processes without involving CUDA.

### **4. Use the `--oversubscribe` Flag (If There Are Not Enough CPU Slots)**
   If your machine has fewer cores than the number of processes you want to run, you can use the `--oversubscribe` flag to allow oversubscription of processes (i.e., run more processes than there are CPU cores).

   - **Command:**
     ```bash
     mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 --oversubscribe ./Task1
     ```

   This tells MPI to ignore the slot allocation and allow the program to run more processes than available cores.

### **5. Run with Resource Manager (e.g., SLURM, PBS)**
   If you're running on a **cluster** or using a **resource manager** like SLURM or PBS, you'll need to submit the job through the resource manager. Here's an example for **SLURM**.

   - **SLURM Command Example:**
     ```bash
     sbatch --ntasks=4 --gres=gpu:4 --wrap="mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1"
     ```

   **Explanation:**
   - `--ntasks=4`: Specifies 4 MPI tasks.
   - `--gres=gpu:4`: Allocates 4 GPUs for the job.
   - `--wrap="mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1"`: Wraps the `mpirun` command inside the SLURM job submission.

   Make sure that SLURM and MPI are properly configured on your system for this to work.

### **6. Run with `mpiexec` (Alternative to `mpirun`)**
   `mpiexec` is often an alias for `mpirun` and is used to launch MPI programs. Some systems prefer `mpiexec`, so you can try using it instead:

   - **Command:**
     ```bash
     mpiexec -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1
     ```

   Both `mpirun` and `mpiexec` should work similarly, but you might prefer one over the other depending on your environment or configuration.

### **7. Run the Program with a Custom Hostfile (For Multiple Machines)**
   If you want to run the program on multiple machines, you can create a **hostfile** that lists the machines and their available slots.

   - **Hostfile (e.g., `hostfile`):**
     ```
     machine1 slots=2
     machine2 slots=2
     ```

   - **Command:**
     ```bash
     mpirun -np 4 -hostfile hostfile -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1
     ```

   This runs 4 processes across two machines (`machine1` and `machine2`), with 2 processes on each.

### **8. Debugging MPI Program (Running with Fewer Processes)**
   If you're debugging or developing, you might want to run the program with just 1 process first to make sure everything works correctly.

   - **Command:**
     ```bash
     mpirun -np 1 -x CUDA_VISIBLE_DEVICES=0 ./Task1
     ```

   This runs the program with just 1 process and assigns GPU 0.

### **9. Run with Hyperthreading (Using `--use-hwthread-cpus`)**
   If your machine supports **hyperthreading** and you want to run MPI processes on hardware threads instead of physical cores, you can use the `--use-hwthread-cpus` flag:

   - **Command:**
     ```bash
     mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 --use-hwthread-cpus ./Task1
     ```

   This allows MPI to utilize logical cores if your CPU supports hyperthreading.

### **10. Run on a Single GPU (Single Device Setup)**
   If you want to run the program on just a single GPU, you can modify `CUDA_VISIBLE_DEVICES` to only specify one GPU.

   - **Command:**
     ```bash
     mpirun -np 1 -x CUDA_VISIBLE_DEVICES=0 ./Task1
     ```

   This runs a single MPI process on GPU 0.

---

### Summary of Commands

1. **Standard Run (4 Processes, 4 GPUs)**:
   ```bash
   mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1
   ```

2. **Run with Fewer Processes (2 Processes)**:
   ```bash
   mpirun -np 2 -x CUDA_VISIBLE_DEVICES=0,1 ./Task1
   ```

3. **Run Without CUDA (MPI Only)**:
   ```bash
   mpirun -np 4 ./Task1
   ```

4. **Allow Oversubscription**:
   ```bash
   mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 --oversubscribe ./Task1
   ```

5. **Run with SLURM**:
   ```bash
   sbatch --ntasks=4 --gres=gpu:4 --wrap="mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1"
   ```

6. **Use `mpiexec` Instead of `mpirun`**:
   ```bash
   mpiexec -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1
   ```

7. **Run with a Hostfile** (Multiple Machines):
   ```bash
   mpirun -np 4 -hostfile hostfile -x CUDA_VISIBLE_DEVICES=0,1,2,3 ./Task1
   ```

8. **Run for Debugging (1 Process)**:
   ```bash
   mpirun -np 1 -x CUDA_VISIBLE_DEVICES=0 ./Task1
   ```

9. **Run with Hyperthreading**:
   ```bash
   mpirun -np 4 -x CUDA_VISIBLE_DEVICES=0,1,2,3 --use-hwthread-cpus ./Task1
   ```

10. **Run on a Single GPU**:
   ```bash
   mpirun -np 1 -x CUDA_VISIBLE_DEVICES=0 ./Task1
   ```

---

These are all the common ways to execute an MPI and CUDA program. Each option has a different use case depending on the resources available, the number of processes you want to run, and the hardware you're targeting.
