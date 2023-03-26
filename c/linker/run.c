extern int lib_call(const char* str);

// We're gonna use a custom entrypoint. This code will never run anyways, we
// just care about the linker output.
void run(void) {
  // This will go in `.data`, because it's initialized to non-zero.
  static int data = 5;

  // The string-constant will go into `.rodata`.
  data = lib_call("Hello from .rodata!");
}