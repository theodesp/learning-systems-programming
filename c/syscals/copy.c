#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <errno.h>

#ifndef __NR_copy_file_range
#ifdef __x86_64__
#define __NR_copy_file_range 326
#else
#define __NR_copy_file_range 391
#endif
#endif

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <src_file> <dst_file>\n", argv[0]);
        return 1;
    }

    int src_fd = open(argv[1], O_RDONLY);
    if (src_fd == -1) {
        perror("open source file");
        return 1;
    }

    int dst_fd = open(argv[2], O_CREAT | O_WRONLY, 0644);
    if (dst_fd == -1) {
        perror("open destination file");
        close(src_fd);
        return 1;
    }

    off_t src_offset = 0;
    off_t dst_offset = 0;
    size_t len = 4096;
    unsigned int flags = 0;

    while (1) {
        ssize_t ret = syscall(__NR_copy_file_range, src_fd, &src_offset,
                               dst_fd, &dst_offset, len, flags);

        if (ret == -1) {
            if (errno == ENOSYS) {
                printf("Error: copy_file_range() is not supported on this system\n");
                break;
            } else {
                perror("copy_file_range");
                break;
            }
        }

        if (ret == 0) {
            break;
        }

        src_offset += ret;
        dst_offset += ret;
    }

    close(src_fd);
    close(dst_fd);

    return 0;
}
