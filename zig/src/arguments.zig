const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    const stdin_file = std.io.getStdIn().reader();
    var br = std.io.bufferedReader(stdin_file);
    const stdin = br.reader();

    var args = std.process.args();
    var minus: bool = false;
    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "-i")) {
            minus = true;
            break;
        }
    }
    if (minus) {
        try stdout.print("Got the -i parameter!\n", .{});
        try stdout.print("y/n: ", .{});
        try bw.flush();
        var answer: [2]u8 = std.mem.zeroes([2]u8);
        _ = try stdin.readAll(&answer);
        try stdout.print("You entered: {s}", .{answer});
    } else {
        try stdout.print("The -i parameter is not set", .{});
    }

    try bw.flush(); // don't forget to flush!
}
