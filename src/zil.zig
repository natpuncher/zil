const std = @import("std");

pub fn link(implementation: type, interface: type) interface {
    const interface_info = @typeInfo(interface).@"struct";
    comptime var result: interface = undefined;
    inline for (interface_info.field_names) |name| {
        @field(result, name) = @field(implementation, name);
    }
    return result;
}

pub fn cast(implementation: type, instance: anytype) *implementation {
    const implementation_info = @typeInfo(implementation).@"struct";
    const interface = @TypeOf(instance.*);
    inline for (implementation_info.field_names, implementation_info.field_types) |name, Field| {
        if (Field == interface) {
            return @alignCast(@fieldParentPtr(name, instance));
        }
    }
    @compileError(std.fmt.comptimePrint("zil: no interface field with type {s} found in {s}!", .{ @typeName(interface), @typeName(implementation) }));
}
