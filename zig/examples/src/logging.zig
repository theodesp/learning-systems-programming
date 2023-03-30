const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    _ = bw.writer();

    std.log.debug("Logging example", .{});
    var it = std.mem.tokenize(u8, " abc def ghi ", " ");

    while (it.next()) |token| {
        std.log.info("{s}", .{token});
    }
    
    try bw.flush();
}
