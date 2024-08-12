// Learn about the concepts we'll be using!
//
// Reading this before heading into other examples
// will help make understanding everything featured
// trivial.
//
// These basic concepts, when combined, allow us to construct
// rather complex global mutable comptime state.

const std = @import("std");
const testing = std.testing;

test "Concept: Error uniqueness" {
    // Only one error exists per error name.

    try testing.expectEqual(error.TestExpectedEqual, error.TestExpectedEqual);
    try testing.expectEqual(error.A, error.A);
    try testing.expectEqual(error.A, @field(anyerror, "A"));
    try testing.expectEqual(error.A, error{A}.A);
    try testing.expectEqual(error{ A, B }, error{ A, B } || error{A});
}

test "Concept: Error integers" {
    // Each error has its own integer representation, starting from 1 for the
    // first error present in the program.

    try testing.expectEqual(2, @intFromError(error.A)); // A is the second error we created.
    try testing.expectEqual(3, @intFromError(error.B)); // B is the third error we created.
    try testing.expectEqual(error.A, @errorFromInt(2));
    try testing.expectEqual(error.B, @errorFromInt(3));

    // This code would cause a compile error as no error presently exists for int 4
    // _ = @errorFromInt(4);
}

test "Concept: `anyerror` backing integer" {
    // `anyerror` has a fixed backing int size that can be modified with `--error-limit [num]`.
    // By default, this backing int is a `u16`.

    try testing.expectEqual(u16, std.meta.Int(.unsigned, @bitSizeOf(anyerror)));
}

test "Concept: Invalid error name null checking for @field" {
    // Invalid (ast-check fails w/ "identifier cannot contain null bytes")
    // const my_error = error.@"Bruh\x00";

    // Totally valid!
    const Bruh = @field(anyerror, "Bruh\x00");

    try testing.expectEqual(Bruh, @field(anyerror, "Bruh\x00"));
    try testing.expect(Bruh != @field(anyerror, "Bruh\x00Abc"));
    try testing.expectEqual(@field(anyerror, "Bruh\x00Abc"), @field(anyerror, "Bruh\x00Abc"));
    try testing.expectEqualStrings(
        @errorName(@field(anyerror, "Bruh")),
        @errorName(@field(anyerror, "Bruh\x00Abc")),
    );
}
