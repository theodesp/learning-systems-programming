const std = @import("std");


pub fn main() !void {
    var allocator = std.heap.GeneralPurposeAllocator(.{}){};
    var gpa = allocator.allocator();
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const out = bw.writer();
    const pid = try std.os.fork();
    if (pid == 0) {
        var m = std.process.EnvMap.init(gpa);
        const argv: []const []const u8 = &.{ "/bin/sh", "-c", "ps", "-a" };
        std.process.execve(gpa, argv, &m) catch {
            unreachable;
        };
    } else {
        try out.print("process launched, pid : {}\n", .{pid});
    }
    try bw.flush();
}
