const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const argz = try std.process.argsAlloc(std.heap.c_allocator);
    var fName = argz[1];
    var file = try std.fs.cwd().openFile(fName, .{ .mode = .read_only });
    defer file.close();
    

    try stdout.print("FileInfo: {any}\", .{fileInfo});
    const fileInfo = try std.os.fstat(file.handle);
    var fileType = switch (fileInfo.mode & std.os.S.IFMT) {
                std.os.S.IFBLK => "BlockDevice",
                std.os.S.IFCHR => "CharacterDevice",
                std.os.S.IFDIR => "Directory",
                std.os.S.IFIFO => "NamedPipe",
                std.os.S.IFLNK => "SymLink",
                std.os.S.IFREG => "File",
                std.os.S.IFSOCK => "UnixDomainSocket",
                else => "Unknown",
            };
    try stdout.print("File type: {s}", .{fileType});
    
    try bw.flush(); // don't forget to flush!
}