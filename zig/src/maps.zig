const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var days = std.StringHashMap(i32).init(allocator);
    try days.ensureTotalCapacity(7);
    defer days.deinit();
    try days.put("Mon", 0);
    try days.put("Tue", 1);
    try days.put("Wed", 2);
    try days.put("Thu", 3);
    try days.put("Fri", 4);
    try days.put("Sat", 5);
    try days.put("Sun", 6);

    var it = days.keyIterator();
    while(it.next()) |key| {
        if (days.get(key.*)) |val| {
            try stdout.print("{d}", .{val});
        }
    }

    try bw.flush(); // don't forget to flush!
}

fn withPointer(x: *i32) void {
    x.* = x.* * x.*;
}
