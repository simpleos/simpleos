// screen.c
#include "screen.h"

namespace sos
{
    size_t screen::terminal_row = 0;
    size_t screen::terminal_column = 0;
    uint8_t screen::terminal_color = WHITE_ON_BLACK;
    uint16_t* screen::terminal_buffer = NULL;

    void screen::clear()
    {
        	screen::terminal_row = 0;
        	screen::terminal_column = 0;
        	screen::terminal_color = WHITE_ON_BLACK; //make_color(COLOR_LIGHT_GREY, COLOR_BLACK);
        	screen::terminal_buffer = (uint16_t*) VIDEO_ADDRESS;

        	for ( size_t y = 0; y < MAX_ROWS; y++ )
        	{
        		for ( size_t x = 0; x < MAX_COLS; x++ )
        		{
        			const size_t index = y * MAX_COLS + x;
                    terminal_buffer[index] = ' ' | terminal_color << 8; // make_vgaentry(' ', terminal_color);
        		}
        	}
    }
}
