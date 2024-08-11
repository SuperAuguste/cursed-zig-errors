// Curse-o-meter: 6/10
//
// Now we're really pushing it! Counting using global mutable comptime state.

const std = @import("std");

const GlobalErrorSetBackingInt = std.meta.Int(.unsigned, @bitSizeOf(anyerror));

fn getNewLastError(comptime Opaque: type) GlobalErrorSetBackingInt {
    return @intFromError(@field(anyerror, @typeName(Opaque)));
}

fn count(comptime lit: @TypeOf(.enum_literal), comptime Opaque: type) usize {
    comptime var err = getNewLastError(Opaque);
    while (err > 0) : (err -= 1) {
        const name = @errorName(@errorFromInt(err));
        if (std.mem.startsWith(u8, name, "counter:" ++ @tagName(lit) ++ ":")) {
            comptime var it = std.mem.splitScalar(u8, name, ':');
            _ = it.next().?;
            _ = it.next().?;
            const n = std.fmt.parseInt(usize, it.next().?, 10) catch unreachable;

            // @TypeOf used here as discarding an error is not allowed
            _ = @TypeOf(@field(anyerror, std.fmt.comptimePrint("counter:{s}:{d}", .{ @tagName(lit), n + 1 })));
            return n + 1;
        }
    }

    _ = @TypeOf(@field(anyerror, std.fmt.comptimePrint("counter:{s}:{d}", .{ @tagName(lit), 0 })));

    return 0;
}

pub fn main() !void {
    std.log.info("counter_a: {d}", .{comptime count(.counter_a, opaque {})});
    std.log.info("counter_a: {d}", .{comptime count(.counter_a, opaque {})});
    std.log.info("counter_b: {d}", .{comptime count(.counter_b, opaque {})});
    std.log.info("counter_a: {d}", .{comptime count(.counter_a, opaque {})});
    std.log.info("counter_b: {d}", .{comptime count(.counter_b, opaque {})});
}
