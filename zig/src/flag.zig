const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    _ = bw.writer();

    
    try bw.flush(); // don't forget to flush!
}

/// These constants cause FlagSet.Parse to behave as described if the parse fails.
pub const ErrorHandling = enum(u4) {
    /// Return a descriptive error.
    continueOnError,
    /// Call os.Exit(2) or for -h/-help Exit(0).
    exitOnError,
    /// Call panic with a descriptive error.
    panicOnError,
};

/// NewFlagSet returns a new, empty flag set with the specified name and
/// error handling property. If the name is not empty, it will be printed
/// in the default usage message and in error messages.
pub const FlagSet = struct {
    name: []const u8,
    parsed: bool = false,
    actual: std.StringHashMapUnmanaged(Flag) = .{},
    formal: std.StringHashMapUnmanaged(Flag)= .{},
    /// arguments after flags
    args: std.ArrayListUnmanaged([]const u8) = .{},
    errorHandling: ErrorHandling,
    pub fn init(name: []const u8, errorHandling: ErrorHandling) FlagSet {
        return FlagSet {
            .name = name,
            .errorHandling = errorHandling
        };
    }

    pub fn parsed(self: FlagSet) bool {
        return self.parsed;
    }

    /// Lookup returns the Flag structure of the named flag, returning nil if none exists.
    pub fn lookup(self: FlagSet, name: []const u8) ?*Flag {
        return self.formal.get(name);
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
    var args = std.process.args();
    var argz = try std.process.argsAlloc(std.testing.allocator);
    var CommandLine = FlagSet.init(args.next() orelse "", .exitOnError);
    try std.testing.expect(!std.mem.eql(u8, CommandLine.name, ""));
}
