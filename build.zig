const std = @import("std");

pub const examples = .{
    .{ "deduplicate", "src/deduplicate.zig" },
    .{ "type_id", "src/type_id.zig" },
    .{ "new_last_error", "src/new_last_error.zig" },
    .{ "counter_increment_only", "src/counter_increment_only.zig" },
    .{ "counter_complex", "src/counter_complex.zig" },
    .{ "mapper", "src/mapper.zig" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const concepts = b.addTest(.{
        .name = "concepts",
        .root_source_file = b.path("src/concepts.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_concepts = b.addRunArtifact(concepts);
    run_concepts.has_side_effects = true;

    const run_concepts_step = b.step("concepts", "Run concepts");
    run_concepts_step.dependOn(&run_concepts.step);

    inline for (examples) |example| {
        const name, const source_file = example;

        const exe = b.addExecutable(.{
            .name = name,
            .root_source_file = b.path(source_file),
            .target = target,
            .optimize = optimize,
        });

        const run_exe = b.addRunArtifact(exe);
        run_exe.has_side_effects = true;

        const run_step = b.step(name, "Run " ++ name);
        run_step.dependOn(&run_exe.step);
    }
}
