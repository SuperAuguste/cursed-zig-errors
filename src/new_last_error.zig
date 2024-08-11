// Curse-o-meter: 5/10
//
// Identical to the last example except instead of any type being acceptable,
// an opaque must be passed in. This guarantees a unique @typeName for every call.
//
// More cursed than `type_id` because this specific variant will be used to create
// signficant global mutable comptime state.

const std = @import("std");

const GlobalErrorSetBackingInt = std.meta.Int(.unsigned, @bitSizeOf(anyerror));

/// Creates a guaranteed unique error and immediately returns its integer
/// representation. As this error's name is unique, its index will now be
/// the new last error.
fn getNewLastError(comptime Opaque: type) GlobalErrorSetBackingInt {
    return @intFromError(@field(anyerror, @typeName(Opaque)));
}

pub fn main() !void {
    std.log.info("New last error: {d}", .{comptime getNewLastError(opaque {})});
    std.log.info("New last error again: {d}", .{comptime getNewLastError(opaque {})});
}
