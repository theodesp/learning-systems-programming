const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    const p1 = Message {
        .X = 23,
        .Y = 12,
        .Label = "A Message"
    };

    const s1 = @field(p1, "X");
    const s2 = @field(p1, "Y");

    try stdout.print("{d}\n", .{s1});
    try stdout.print("{d}\n", .{s2});
    const fields = std.meta.fields(Message);
    inline for (fields) |f| {
        try stdout.print("{s}:{d}\n", .{f.name, @field(p1, f.name)});
    }

    try bw.flush(); // don't forget to flush!
}

const Message = struct {
    X: i32, Y: i32, Label: []const u8
};
