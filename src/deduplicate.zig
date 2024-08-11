// Curse-o-meter: 3/10

const std = @import("std");

pub fn main() !void {
    const my_strings: []const []const u8 = &.{ "pog", "hello", "pog", "hi" };
    const my_deduplicated_strings = comptime blk: {
        var ErrorSet = error{};
        for (my_strings) |string| {
            ErrorSet = ErrorSet || @TypeOf(@field(anyerror, string));
        }

        const error_set_details = @typeInfo(ErrorSet).ErrorSet.?;
        var my_deduplicated_strings: [error_set_details.len][]const u8 = undefined;
        for (error_set_details, &my_deduplicated_strings) |src, *dst| {
            dst.* = src.name;
        }

        break :blk my_deduplicated_strings;
    };

    std.log.info("original: {s}", .{my_strings});
    std.log.info("deduplicated: {s}", .{my_deduplicated_strings});
}
