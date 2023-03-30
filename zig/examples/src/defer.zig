const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    _ = bw.writer();
    var i: usize = 0;
    while(i < 3): (i += 1) {
        defer std.debug.print("{d}", .{i});
    }
    try bw.flush(); // don't forget to flush!
}
