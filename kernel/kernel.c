
// main
int main(int argc, const char* argv[])
{
    char* video_memory = 0xb8000;
    *video_memory = 'K';

    return 0;
}
