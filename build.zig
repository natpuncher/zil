const std = @import("std");

pub fn build(build_settings: *std.Build) void {
    const optimize = build_settings.standardOptimizeOption(.{});
    const target = build_settings.standardTargetOptions(.{});

    _ = build_settings.addModule("zil", .{
        .root_source_file = build_settings.path("src/zil.zig"),
    });

    const tests = build_settings.addTest(.{
        .root_module = build_settings.createModule(.{
            .root_source_file = build_settings.path("zil.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const test_step = build_settings.step("test", "Run unit tests");
    const run_test = build_settings.addRunArtifact(tests);
    test_step.dependOn(&run_test.step);
}
