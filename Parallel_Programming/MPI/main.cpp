#include <iostream>
#include <mpi.h>
#include <cstdlib>

#define Tag 1

double Integral_Function(int x_left, int N, int proc) {
    int x_right = x_left + N / proc;
    if (N - x_right < N / proc) { // ну если самый последный кусок будет меньше дельта_x, то будем считать частью дельта_х
        x_right = N;
    }
    double I = 0;
    for (int i = x_left; i < x_right; i++) {
        double m = i / (double)N;
        double m_1 = (i + 1) / (double)N;
        I += ((4.0 / (1.0 + m * m) + 4.0 / (1.0 + m_1 * m_1)) / 2) / N;
    }
    return I;
}

int main(int argc, char* argv[]) {
    int size, rank;
    MPI_Status Status;
    int N, x1, x2 = 0;
    double I = 0, cur_I = 0;
    N = atoi(argv[1]);
    MPI_Init(&argc, &argv);

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    double begin_time = MPI_Wtime();
    if (rank == 0) {
        for (int i = 1; i < size; i++) {
            x1 = (N / size) * i;
            MPI_Send(&x1, 1, MPI_INT, i, Tag, MPI_COMM_WORLD);
        }
    }
    else {
        MPI_Recv(&x2, 1, MPI_INT, 0, Tag, MPI_COMM_WORLD, &Status);
    }
    cur_I = Integral_Function(x2, N, size);
    if (rank != 0) {
        MPI_Send(&cur_I, 1, MPI_DOUBLE, 0, Tag, MPI_COMM_WORLD);
    }
    else {
        std::cout << "I0 = " << cur_I << std::endl;
        I += cur_I;
        for (int i = 1; i < size; i++) {
            MPI_Recv(&cur_I, 1, MPI_DOUBLE, i, Tag, MPI_COMM_WORLD, &Status);
            std::cout << "I" << i << " = " << cur_I << std::endl;
            I += cur_I;
        }
        std::cout << "I = " << I << std::endl;
        double end_time = MPI_Wtime();
        double I1 = 0;
        double begin_time_one_proc = MPI_Wtime();
        for (int i = 0; i < size; i++) {
            x1 = (N / size) * i;
            I1 += Integral_Function(x1, N, size);
        }
        double end_time_one_proc = MPI_Wtime();
        std::cout << "I - I_proc = " << I1 - I << std::endl;
        std::cout << "S = " << (end_time_one_proc - begin_time_one_proc) / (end_time - begin_time) << std::endl;
    }
    MPI_Finalize();
    return 0;
}
