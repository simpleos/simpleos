// screen.c
#include <string.h>

#include "../kernel/low_level.h"
#include "screen.h"

namespace sos
{
    size_t screen::terminal_row = 0;
    size_t screen::terminal_column = 0;
    uint8_t screen::terminal_color = WHITE_ON_BLACK;
    uint16_t* screen::terminal_buffer = (uint16_t*) VIDEO_ADDRESS;

    void screen::clear()
    {
        screen::move_cursor(0, 0);
        screen::terminal_color = WHITE_ON_BLACK; //make_color(COLOR_LIGHT_GREY, COLOR_BLACK);

        for ( size_t y = 0; y < MAX_ROWS; y++ )
            screen::clearRow(y);
	}
    void screen::clearRow(size_t row)
    {
        for ( size_t x = 0; x < MAX_COLS; x++ )
        {
            const size_t index = row * MAX_COLS + x;
            terminal_buffer[index] = ' ' | screen::terminal_color << 8; // make_vgaentry(' ', terminal_color);
        }
    }

    void screen::put_char(char c)
    {
        const size_t pos = screen::terminal_row * MAX_COLS + screen::terminal_column;
        terminal_buffer[pos] = c | screen::terminal_color << 8;
        
        ++screen::terminal_column;

        if (screen::terminal_column > MAX_COLS) {
            screen::terminal_column = 0;

            if (screen::terminal_row < MAX_ROWS) {
                ++screen::terminal_row;
            } else {
                // TODO: memmove
                //memmove(screen::terminal_buffer, screen::terminal_buffer + MAX_COLS, sizeof(uint16_t) * (MAX_ROWS - 1) * MAX_COLS);
                screen::clearRow(MAX_ROWS - 1);
            }
        }

        screen::update_cursor();
    }

    void screen::move_cursor(size_t row, size_t column)
    {
        screen::terminal_row = row;
        screen::terminal_column = column;
        screen::update_cursor();
    }

    void screen::update_cursor()
    {
        const size_t pos = (screen::terminal_row * MAX_COLS) + screen::terminal_column;

        // cursor LOW port to vga INDEX register
        port_word_out(0x3D4, 0x0F);
        port_word_out(0x3D5, (unsigned char)(pos&0xFF));

        // cursor HIGH port to vga INDEX register
        port_word_out(0x3D4, 0x0E);
        port_word_out(0x3D5, (unsigned char)((pos>>8)&0xFF));
    }
}
