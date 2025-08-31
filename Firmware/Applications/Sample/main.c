#include <stdio.h>

#include <Version.h>

int main(void)
{
    printf("%s - %s - V%s\n", APPLICATION_NAME, APPLICATION_CONFIG, FIRMWARE_VERSION);
    printf("Revision ID: %s\n", REVISION_ID);
    printf("Build Date & Time: %s\n", BUILD_DATE);
    printf("Compiler: %s - V%s\n", COMPILER_ID, COMPILER_VERSION); 
}

