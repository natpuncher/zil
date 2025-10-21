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

    pub fn init() InitializeGameState {
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

    pub fn update(state: *State, delta_time: f32) void {
        _ = .{state, delta_time};
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
    has_state: bool = false,

    pub fn enter(sm: *StateMachine, state: *State) void {
        if (sm.has_state) sm.current_state.exit();

        sm.current_state = state;
        sm.current_state.enter();
        sm.has_state = true;
    }

    // ...
};

var sm: StateMachine = .{};

var initialize_game_state = InitializeGameState.init();
sm.enter(&initialize_game_state.state);

var other_game_state = OtherGameState.init();
sm.enter(&other_game_state.state);
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
