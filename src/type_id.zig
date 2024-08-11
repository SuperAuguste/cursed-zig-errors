// Curse-o-meter: 4/10

const std = @import("std");

const AnyErrorIntType = std.meta.Int(.unsigned, @bitSizeOf(anyerror));

pub fn typeId(comptime T: type) AnyErrorIntType {
    return @intFromError(@field(anyerror, @typeName(T)));
}

pub fn main() !void {
    std.log.info("u8 type id: {d}", .{comptime typeId(u8)});
    std.log.info("u16 type id: {d}", .{comptime typeId(u16)});
    std.log.info("u8 type id again: {d}", .{comptime typeId(u8)});
}
