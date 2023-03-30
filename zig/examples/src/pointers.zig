const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var x: i32 = 2;
    withPointer(&x);
    try stdout.print("{d}", .{x});

    try bw.flush(); // don't forget to flush!
}

fn withPointer(x: *i32) void {
    x.* = x.* * x.*;
}
