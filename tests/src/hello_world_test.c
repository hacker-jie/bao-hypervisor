#include "testf.h"

BAO_TEST(HELLO, TEST_A)
{
    printf("Hello World!!!\n");
    EXPECTED_EQUAL(0,1);
}

BAO_TEST(HELLO, TEST_B)
{
    EXPECTED_EQUAL(0,0);
    printf(" Bao Test Framework is up!!!\n");
}