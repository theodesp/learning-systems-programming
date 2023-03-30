const std = @import("std");

const IdentityContext = struct {
        pub fn eql(_: @This(), a: u64, b: u64) bool {
            return a == b;
        }

        pub fn hash(_: @This(), a: u64) u64 {
            return a;
        }
    };

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

    var my_map = std.HashMap(u64, []const u8, IdentityContext, 80).init(std.heap.c_allocator);
    try my_map.put(1, "one");
    try my_map.put(2, "two");
    try my_map.put(3, "three");

    var my_slice = [_][]const u8{""} ** 3;
    var idx: usize = 0;
    var it = my_map.valueIterator();
    while (it.next()) |val| {
        my_slice[idx] = val.*;
        idx += 1;
    }

    std.debug.print("my_slice: {s}\n", .{my_slice});

    try bw.flush(); // don't forget to flush!
}

fn withPointer(x: *i32) void {
    x.* = x.* * x.*;
}
