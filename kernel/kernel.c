
// main
int main(int argc, const char* argv[])
{
    char* video_memory = 0xb8000;
    int i = 0;

    *video_memory = 'K';

    for(i=0; i<42; i++)
    {
        *(video_memory+i) = 0;
    }

    return 0;
}
