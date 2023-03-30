const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    const asc_i32 = asc(i32);
    var slice = [_]i32{4,3,6,11,16,22,5};
    std.sort.sort(i32, &slice, {}, asc_i32);
    try stdout.print("Numbers sorted: ", .{});
    for (slice) |n| {
        try stdout.print("{d:^4}", .{n});
    }
    try bw.flush(); // don't forget to flush!
}

pub fn asc(comptime T: type) fn (void, T, T) bool {
    const impl = struct {
        fn inner(context: void, a: T, b: T) bool {
            _ = context;
            return a < b;
        }
    };

    return impl.inner;
}
