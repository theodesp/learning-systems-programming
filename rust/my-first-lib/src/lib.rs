//! This is a library that contains functions related to
//! dealing with processes,
//! and makes these tasks more convenient.
use std::process;
/// This function gets the process ID of the current
/// executable. It returns a non-zero  number
/// This function gets the process id of the current
/// executable. It returns a non-zero number
/// ```
/// fn get_id() {
///     let x = my_first_lib::get_process_id();
///     println!("{}",x);
/// }
/// ```
pub fn get_process_id() -> u32 {
    process::id()
}

pub fn add(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
