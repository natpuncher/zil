# zil

zig interface linker

## api

```zig
// interface
pub const State = struct {
    enter: *const fn (state: *State) void,
    load: *const fn (state: *State) void,
    exit: *const fn (state: *State) void,
    update: *const fn (state: *State, delta_time: f32) void,
    render: *const fn (state: *State) void,
    renderUI: *const fn (state: *State) void,
};
```

```zig
const zil = @import("zil");

// implementation
pub const InitializeGameState = struct {
    my_data: f32 = 0,

    state: State,

    pub fn init(services: *Services) InitializeGameState {
        return .{
            .state = zil.link(InitializeGameState, State),
        };
    }

    pub fn enter(state: *State) InitializeGameState {
        const this = zil.cast(InitializeGameState, state);

        this.my_data += 1;
    }

    pub fn load(state: *State) void {
        _ = state;
    }

    pub fn exit(state: *State) void {
        _ = state;
    }

    pub fn update(state: *State) void {
        _ = state;
    }

    pub fn render(state: *State) void {
        _ = state;
    }

    pub fn renderUI(state: *State) void {
        _ = state;
    }
};
```

```zig
// usage
pub const StateMachine = struct {
    current_state: *State = undefined,

    pub fn enter(sm: *StateMachine, state: *State) void {
        sm.current_state.exit();

        sm.current_state = state;
        sm.current_state.enter();
    }

    // ...
};
```

## install

execute in your project repository root:

```
zig fetch --save git+https://github.com/natpuncher/zil.git
```

then add dependency and import in `build.zig` file:

```zig
const zil = build_settings.dependency("zil", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("zil", zil.module("zil"));
```
