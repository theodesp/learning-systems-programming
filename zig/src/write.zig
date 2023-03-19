const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var file = try std.fs.cwd().openFile("./example", .{ .mode = .read_write });
    defer file.close();
    var fd = file.handle;
    const wrote = std.os.write(fd, "Hello World");
    try stdout.print("Wrote {!d} bytes", .{wrote});
    try bw.flush(); // don't forget to flush!
}
