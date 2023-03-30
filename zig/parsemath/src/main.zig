const std = @import("std");
const parser = @import("./parser.zig");
const ParseError = parser.ParseError;

pub fn main() !void {
    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const stdin_file = std.io.getStdIn().reader();
    var br = std.io.bufferedReader(stdin_file);
    const stdin = br.reader();

    try stdout.print("Hello! Welcome to Arithmetic expression evaluator.\n", .{});
    try stdout.print("You can calculate value for expression such as 2*3+(4-5)+2^3/4.\n", .{});
    try stdout.print("Allowed numbers: positive, negative and decimals.\n", .{});
    try stdout.print("Supported operations: Add, Subtract, Multiply, Divide, PowerOf(^).\n", .{});
    try stdout.print("Enter your arithmetic expression below:\n", .{});
    try bw.flush(); // don't forget to flush!
    while (true) {
        var buf: [1024]u8 = undefined;
        if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |input| {
            if (parser.evaluate(input)) |val| {
                try stdout.print("Expression entered: {s} \n", .{input});
                try stdout.print("The computed number is {d} \n", .{val orelse 0});
            } else |err| switch (err) {
                ParseError.UnableToParse => try stdout.print("Error in evaluating: {s} \n", .{input}),
                ParseError.InvalidOperator => try stdout.print("Error in evaluating: {s} \n", .{input})
            }
        } else {
            try stdout.print("Error", .{});
        }
        try bw.flush(); // don't forget to flush!
    }
}
