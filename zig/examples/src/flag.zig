const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    var out = bw.writer();
    
    var CommandLine = FlagSet.init("program", .exitOnError);
    try out.print("{s}", .{CommandLine.name});

    try CommandLine.defaultUsage(out);
    try out.print("{d}", .{CommandLine.arg(0)});
    
    try bw.flush();
}

/// These constants cause FlagSet.Parse to behave as described if the parse fails.
pub const ErrorHandling = enum {
    /// Return a descriptive error.
    continueOnError,
    /// Call os.Exit(2) or for -h/-help Exit(0).
    exitOnError,
    /// Call panic with a descriptive error.
    panicOnError,
};

pub const FlagSetError = enum {
    /// No such Flag Error.
    noSuchFlag,
};

/// NewFlagSet returns a new, empty flag set with the specified name and
/// error handling property. If the name is not empty, it will be printed
/// in the default usage message and in error messages.
pub const FlagSet = struct {
    name: []const u8,
    parsed: bool = false,
    formal: std.StringHashMapUnmanaged(Flag)= .{},
    actual: std.StringHashMapUnmanaged(Flag) = .{},
    // /// arguments after flags
    args: std.ArrayListUnmanaged([]const u8) = .{},
    errorHandling: ErrorHandling,

    pub fn init(flagName: []const u8, errorHandle: ErrorHandling) FlagSet {
        return FlagSet {
            .name = flagName,
            .errorHandling = errorHandle
        };
    }

    /// name returns the name of the flag set.
    pub fn name(self: FlagSet) []const u8 {
        return self.name;
    }

    /// errorHandling returns the error handling behavior of the flag set.
    pub fn errorHandling(self: FlagSet) ErrorHandling {
        return self.errorHandling;
    }

    pub fn parsed(self: FlagSet) bool {
        return self.parsed;
    }

    /// lookup returns the Flag structure of the named flag, returning nil if none exists.
    pub fn lookup(self: FlagSet, flagName: []const u8) ?Flag {
        return self.formal.get(flagName);
    }

    /// defaultUsage is the default function to print a usage message.
    pub fn defaultUsage(self: FlagSet, writer: anytype) !void {
        if (std.mem.eql(u8, self.name, "")) {
            try writer.print("Usage:\n", .{});
        } else {
            try writer.print("Usage of {s}\n", .{self.name});
        }
    }

    /// nFlag returns the number of flags that have been set.
    pub fn nFlag(self: FlagSet) usize {
        return self.actual.count();
    }

    /// arg returns the i'th argument. arg(0) is the first remaining argument
    /// after flags have been processed. arg returns an empty string if the
    /// requested element does not exist.
    pub fn arg(self: FlagSet, i: i32) []const u8 {
        if (i < 0 or i >= self.args.items.len) {
            return "";
        }
        return self.args.items[@intCast(usize, i)];
    }

};


/// A Flag represents the state of a flag.
pub const Flag = struct {
    /// name as it appears on command line
	name: []const u8, 
	usage: []const u8, // help message
    // value as set
	value: []const u8,
    // default value (as text); for usage message
	defValue: []const u8,

    pub const Sorter = void;

    pub fn sortByName(_: Sorter, flag: Flag, rhs: Flag) bool {
        return flag.name < rhs.name;
    }
};

/// sortFlags returns the flags as a slice in lexicographical sorted order.
fn sortFlags(flags: std.StringHashMapUnmanaged(Flag)) ![]Flag {
    var result: [flags.size]Flag = undefined;
    var clone = try flags.clone();
    var it = clone.valueIterator();
    for (it.next(), 0..) |flag, i| {
        result[i] = flag;
    }
    std.sort.sort(Flag, &result, {}, Flag.sortByName);
	return result;
}


test "CommandLine" {
    var args = try std.process.argsAlloc(std.testing.allocator);
    defer std.process.argsFree(std.testing.allocator, args);
     
    var CommandLine = FlagSet.init(args[0], .exitOnError);
    try std.testing.expect(!std.mem.eql(u8, CommandLine.name, ""));
}

test "FlagSet: lookup" {
    var CommandLine = FlagSet.init("example", .exitOnError);
    var flag = CommandLine.lookup("dock");
    try std.testing.expect(flag == null);
}