const std = @import("std");

pub fn link(implementation: type, interface: type) interface {
    const interface_info = @typeInfo(interface).@"struct";
    comptime var result: interface = undefined;
    inline for (interface_info.fields) |field| {
        @field(result, field.name) = @field(implementation, field.name);
    }
    return result;
}

pub fn cast(implementation: type, instance: anytype) *implementation {
    const implementation_info = @typeInfo(implementation).@"struct";
    const interface = @TypeOf(instance.*);
    inline for (implementation_info.fields) |field| {
        if (field.type == interface) {
            return @fieldParentPtr(field.name, instance);
        }
    }
    @compileError(std.fmt.comptimePrint("zil: no interface field with type {s} found in {s}!", .{ @typeName(interface), @typeName(implementation) }));
}
