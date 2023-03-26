int lib_call(const char* str) {
  // Discard `str`, we just want to take any argument.
  (void)str;

  // This will go in `.bss`.
  static int count;
  return count++;
}