# Cursed Zig Errors

Using Zig's errors in ways you've never seen before to bring back our much beloved
global mutable comptime state. Runs on Zig `master`.

**Please don't actually use this code or code like it.**

A week or two of experience with Zig is probably required to understand this.

For your enjoyment, I recommend viewing in this order (from least to most cursed):
- `concepts.zig` (you can technically run `zig build concepts` but no output will appear)
- `zig build deduplicate` / `deduplicate.zig`
- `zig build type_id` / `type_id.zig`
- `zig build new_last_error` / `new_last_error.zig`
- `zig build counter_increment_only` / `counter_increment_only.zig`
- `zig build counter_complex` / `counter_complex.zig`

Each example builds on previous examples.

## License

MIT
