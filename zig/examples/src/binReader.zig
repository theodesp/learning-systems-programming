const std = @import("std");

const BinaryReader = struct {
    fn read(comptime T: type, reader: anytype) !T {
        var data: [@sizeOf(T)]u8 = undefined;
        _ = try reader.readNoEof(&data);
        return @bitCast(T, data);
    }

    fn readBigEndian(comptime T: type, reader: anytype) !T {
        var data: [@sizeOf(T)]u8 = undefined;
        _ = try reader.readNoEof(&data);
        return @byteSwap(@bitCast(T, data));
    }

    fn readIntVariableLength(reader: anytype) !i32 {
        var acc: i32 = 0;
        var count: i32 = 0;

        while (true) {
            const value = @intCast(i32, try BinaryReader.read(u8, reader));
            acc = (acc << 7) | (value & 127);
            if ((value & 128) == 0) {
                break;
            }
            count += 1;
            if (count == 4) {
                return error.Unexpected;
            }
        }

        return acc;
    }
};