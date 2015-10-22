#include "../drivers/screen.h"
using namespace sos;

#if defined(__cplusplus)
extern "C" // Use C linkage for kernel_main
#endif
int kernel_main(int argc, const char* argv[])
{
    screen::clear();

    screen::put_char('H');
    screen::put_char('e');
    screen::put_char('l');
    screen::put_char('l');
    screen::put_char('o');
    screen::put_char(',');
    screen::put_char(' ');
    screen::put_char('W');
    screen::put_char('o');
    screen::put_char('r');
    screen::put_char('l');
    screen::put_char('d');
    screen::put_char('!');


    return 0;
}
