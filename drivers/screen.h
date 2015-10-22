// screen.h
#pragma once
#include <stddef.h>
#include <stdint.h>

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

// Attribute byte for our default colour scheme.
#define WHITE_ON_BLACK 0x0f

// Screen device I/O ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5


namespace sos
{
    class screen
    {
    private:
        static size_t terminal_row;
        static size_t terminal_column;
        static uint8_t terminal_color;
        static uint16_t* terminal_buffer;

    public:
        static void clear();

        static void put_char(char c);

        static void move_cursor(size_t row, size_t column);

    private:
        static void clearRow(size_t row);
        static void update_cursor();
    };
}
