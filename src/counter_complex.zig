// Curse-o-meter: 7/10
//
// Our simple increment-only counter works great because it's guaranteed that
// each incrementation will result in a new unique error. Unfortunately,
// decrementing wouldn't work with that model because the small number's
// error would already exist, meaning the latest state would still be
// the larger number.
//
// This complex counter bypasses this entirely using invalid error name null checking.
//
// NOTE: You could totally do this without invalid error name null checking by just
// placing the nonce elsewhere in the error name, but this is just more cursed so why
// not? :P

const std = @import("std");

const GlobalErrorSetBackingInt = std.meta.Int(.unsigned, @bitSizeOf(anyerror));

fn getNewLastError(comptime Opaque: type) GlobalErrorSetBackingInt {
    return @intFromError(@field(anyerror, @typeName(Opaque)));
}

fn setCounter(
    comptime lit: @TypeOf(.enum_literal),
    comptime Opaque: type,
    comptime value: usize,
) void {
    if (!@inComptime()) @compileError("must be called at comptime");

    _ = @TypeOf(@field(anyerror, std.fmt.comptimePrint("counter:{s}:{d}\x00{s}", .{
        @tagName(lit),
        value,
        @typeName(Opaque),
    })));
}

fn getCounter(
    comptime lit: @TypeOf(.enum_literal),
    comptime Opaque: type,
) ?usize {
    comptime var err = getNewLastError(Opaque);
    while (err > 0) : (err -= 1) {
        const name = @errorName(@errorFromInt(err));
        if (std.mem.startsWith(u8, name, "counter:" ++ @tagName(lit) ++ ":")) {
            comptime var it = std.mem.splitScalar(u8, name, ':');
            _ = it.next().?;
            _ = it.next().?;
            const n = std.fmt.parseInt(usize, it.next().?, 10) catch unreachable;
            return n;
        }
    }

    return null;
}

pub fn main() !void {
    std.log.info("counter_a: {?d}", .{comptime getCounter(.counter_a, opaque {})});
    comptime setCounter(.counter_a, opaque {}, 10);
    std.log.info("counter_a: {?d}", .{comptime getCounter(.counter_a, opaque {})});
    std.log.info("counter_b: {?d}", .{comptime getCounter(.counter_b, opaque {})});
    comptime setCounter(.counter_b, opaque {}, 20);
    comptime setCounter(.counter_a, opaque {}, 5);
    std.log.info("counter_a: {?d}", .{comptime getCounter(.counter_a, opaque {})});
    std.log.info("counter_b: {?d}", .{comptime getCounter(.counter_b, opaque {})});
    comptime setCounter(.counter_b, opaque {}, 10);
    comptime setCounter(.counter_a, opaque {}, 10);
    std.log.info("counter_a: {?d}", .{comptime getCounter(.counter_a, opaque {})});
    std.log.info("counter_b: {?d}", .{comptime getCounter(.counter_b, opaque {})});
}
