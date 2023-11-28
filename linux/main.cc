#include "my_application.h"
#include <cstdio>

int main(int argc, char **argv) {
  try {
    g_autoptr(MyApplication) app = my_application_new();
    return g_application_run(G_APPLICATION(app), argc, argv);
  } catch (const char *&e) {
    printf("Something bad happened : %s\n", e);
    return 1;
  }
}
