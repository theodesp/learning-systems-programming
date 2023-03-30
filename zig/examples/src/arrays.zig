const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const myArray: [4]i32 = [4]i32{1, 2, 4, -4};
    for (myArray) |el| {
        try stdout.print("{d}\n", .{el});
    }

    _ = [3][3]i32{
        [3]i32{1, 2, 3},
        [3]i32{4, 5, 6},
        [3]i32{7, 8, 9},
    };

    // try stdout.print("{d}\n", .{myArray[-1]}); error: type 'usize' cannot represent integer value '-1'

    try bw.flush(); // don't forget to flush!
}

fn withPointer(x: *i32) void {
    x.* = x.* * x.*;
}
