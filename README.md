# zil

zig interface linker

![logo](res/logo.png)

## api

```zig
// interface
pub const State = struct {
    enter: *const fn (state: *State) void,
    exit: *const fn (state: *State) void,
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

    pub fn exit(state: *State) void {
        const this = zil.cast(InitializeGameState, state);

        this.my_data -= 1;
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

var next_game_state = NextGameState.init();
sm.enter(&next_game_state.state);
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
