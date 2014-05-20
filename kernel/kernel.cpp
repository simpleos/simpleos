#include "../drivers/screen.h"
using namespace sos;

#if defined(__cplusplus)
extern "C" // Use C linkage for kernel_main
#endif
int kernel_main(int argc, const char* argv[])
{
    screen::clear();

    return 0;
}
