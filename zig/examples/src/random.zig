const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("{d}", .{random(0, 100)});


    try bw.flush(); // don't forget to flush!
}

fn random(min: i32, max: i32) i32 {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        std.os.getrandom(std.mem.asBytes(&seed)) catch return 0;
        break :blk seed;
    });
    return prng.random().intRangeAtMost(i32, min, max);
}
