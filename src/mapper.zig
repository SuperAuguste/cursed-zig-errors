// Curse-o-meter: 8/10
//
// Manipulate memoization to map data. We could use the loop concept demonstrated in
// the counter examples to achieve the same effect, but this is arguably more
// efficient (and it's also more cursed :^)).

const std = @import("std");

const GlobalErrorSetBackingInt = std.meta.Int(.unsigned, @bitSizeOf(anyerror));

fn put(comptime key: usize, comptime value: usize) void {
    if (!@inComptime()) @compileError("must be called at comptime");

    _ = @TypeOf(@field(anyerror, std.fmt.comptimePrint("kv:{d}:{d}", .{ key, value })));
    std.debug.assert(get(key) == value);
}

fn get(comptime key: usize) usize {
    if (!@inComptime()) @compileError("must be called at comptime");

    // Variant of the `getNewLastError` technique
    const last = @intFromError(@field(anyerror, std.fmt.comptimePrint("k:{d}", .{key})));
    const error_name = @errorName(@errorFromInt(last - 1));
    if (last == 1 or !std.mem.startsWith(u8, error_name, "kv:")) {
        @compileError(std.fmt.comptimePrint("No entry with key {d}", .{key}));
    }

    comptime var it = std.mem.splitScalar(u8, error_name, ':');
    _ = it.next();
    _ = it.next();
    return std.fmt.parseInt(usize, it.next().?, 10) catch unreachable;
}

pub fn main() !void {
    comptime put(1, 2);
    std.log.info("key 1 -> value {d}", .{comptime get(1)});
    comptime put(3, 5);
    std.log.info("key 3 -> value {d}", .{comptime get(3)});

    // Compile error:
    // std.log.info("{d}", .{comptime get(5)});
}
