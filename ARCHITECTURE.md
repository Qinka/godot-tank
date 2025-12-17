# 项目架构 (Project Architecture)

## 系统架构图

```
┌─────────────────────────────────────────────────────────────┐
│                         Godot Engine 4.3                     │
│                      (Game Loop & Rendering)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Global Autoload (global.gd)               │
│  - Game State Management (Menu/Playing/Paused/GameOver)     │
│  - Player Stats (Score, Lives, Wave, Kills)                 │
│  - Scene Switching Logic                                    │
│  - Signal Broadcasting                                       │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐   ┌────────────────┐   ┌──────────────────┐
│  Main Menu    │   │  Game World    │   │   Game Over      │
│  (UI Scene)   │   │  (Game Scene)  │   │   (UI Scene)     │
└───────────────┘   └────────────────┘   └──────────────────┘
                            │
                    ┌───────┴───────┐
                    ▼               ▼
            ┌──────────────┐  ┌──────────────┐
            │ Game Manager │  │     HUD      │
            │   (Logic)    │  │   (UI)       │
            └──────────────┘  └──────────────┘
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
    ┌────────┐ ┌────────┐ ┌──────────┐
    │ Player │ │Enemies │ │Environment│
    │  Tank  │ │   AI   │ │ (Walls)  │
    └────────┘ └────────┘ └──────────┘
        │           │
        └─────┬─────┘
              ▼
        ┌──────────┐
        │  Bullets │
        │ (Shared) │
        └──────────┘
```

## 场景层次结构

### 主要场景

```
Main Menu (main_menu.tscn)
├── Background (ColorRect)
└── UI Container
    ├── Title Label
    ├── Start Button
    └── Quit Button

Game World (game_world.tscn)
├── Game Manager (Node)
├── Background (ColorRect)
├── Player Tank (CharacterBody2D)
│   ├── Sprite2D
│   ├── CollisionShape2D
│   └── Turret (Node2D)
│       ├── Turret Sprite
│       └── Shoot Point (Marker2D)
├── Walls (Node2D)
│   └── Wall Instances...
├── Obstacles (Node2D)
│   └── Brick Instances...
├── Enemy Spawner (Node2D)
│   ├── Spawn Timers
│   └── Spawn Points (Marker2D)
├── HUD (Control)
│   └── Labels (Score, Lives, Wave)
├── Pause Menu (Control)
└── Camera2D

Game Over (game_over.tscn)
├── Background (ColorRect)
└── UI Container
    ├── Game Over Label
    ├── Score Display
    ├── Stats Display
    ├── Restart Button
    └── Menu Button
```

### 实体场景

```
Player Tank (player_tank.tscn)
├── CharacterBody2D [Layer: Player]
├── Sprite2D (Green)
├── CollisionShape2D
├── Turret (Node2D)
│   ├── Turret Sprite
│   └── Shoot Point
├── Shoot Timer
└── Invulnerable Timer

Enemy Tank (enemy_tank.tscn)
├── CharacterBody2D [Layer: Enemy]
├── Sprite2D (Red)
├── CollisionShape2D
├── Turret (Node2D)
│   ├── Turret Sprite
│   └── Shoot Point
├── Shoot Timer
└── Detection Area (Area2D)

Bullet (bullet.tscn)
├── Area2D [Layer: PlayerBullet/EnemyBullet]
├── CollisionShape2D
└── Sprite2D (Yellow)

Wall (wall.tscn)
├── StaticBody2D [Layer: Wall]
├── CollisionShape2D
└── Sprite2D (Gray)

Brick (brick.tscn)
├── StaticBody2D [Layer: Destructible]
├── CollisionShape2D
└── Sprite2D (Brown)
```

## 脚本架构

### 核心脚本关系

```
global.gd (Autoload)
    ↓ provides state & signals
    ├── game_manager.gd
    │       ↓ manages
    │       ├── player_tank.gd
    │       ├── enemy_spawner.gd
    │       │       ↓ spawns
    │       │       └── enemy_tank.gd
    │       └── hud.gd
    │
    ├── main_menu.gd
    │       ↓ starts game
    │       └── [Scene Switch]
    │
    └── game_over.gd
            ↓ restarts or returns
            └── [Scene Switch]

player_tank.gd
    ↓ shoots
    └── bullet.gd

enemy_tank.gd
    ↓ shoots
    └── bullet.gd

bullet.gd
    ↓ damages
    ├── player_tank.gd
    ├── enemy_tank.gd
    └── brick.gd
```

## 信号流

```
Global Signals:
- score_changed(new_score) → HUD
- lives_changed(new_lives) → HUD
- wave_changed(new_wave) → HUD
- game_state_changed(state) → Game Manager

Enemy Spawner Signals:
- wave_started(wave_num) → Game Manager
- wave_completed(wave_num) → Game Manager
- all_enemies_defeated() → Game Manager

Node Signals:
- Timer.timeout → Various cooldown handlers
- Area2D.body_entered → Collision detection
- Button.pressed → UI actions
```

## 数据流

### 游戏启动流程

```
1. Engine Start
   ↓
2. Load Global Autoload
   ↓
3. Load Main Menu Scene
   ↓
4. User Clicks "Start"
   ↓
5. Global.start_game()
   ↓
6. Reset Game Stats
   ↓
7. Change Scene to Game World
   ↓
8. Game Manager Initializes
   ↓
9. Enemy Spawner Starts
   ↓
10. Game Loop Begins
```

### 战斗流程

```
Player Input
    ↓
Player Tank Movement/Shooting
    ↓
Bullet Created (Instance)
    ↓
Bullet Moves (Physics Process)
    ↓
Collision Detected
    ↓
┌──────────┬──────────┬──────────┐
│  Enemy   │   Wall   │  Brick   │
└──────────┴──────────┴──────────┘
    ↓          ↓          ↓
Take Damage  Destroy   Take Damage
    ↓        Bullet    Check HP
Enemy Dies     ↓          ↓
    ↓       (End)    Destroy if 0
Add Score                ↓
    ↓               (End)
Global.score_changed
    ↓
HUD Updates
```

### AI决策流程

```
Enemy Tank AI (每帧)
    ↓
Check Current State
    ↓
┌────────┬────────┬────────┬────────┐
│ PATROL │ CHASE  │ ATTACK │RETREAT │
└────────┴────────┴────────┴────────┘
    ↓        ↓        ↓        ↓
 Random   Follow  Keep Dist Back Away
 Movement  Player & Shoot  from Player
    ↓        ↓        ↓        ↓
Check for Player in Range
    ↓
Transition State if Needed
```

## 碰撞层配置

```
Layer 1 (Player):
- Collides with: Enemy(2), Wall(5), Destructible(6)

Layer 2 (Enemy):
- Collides with: Player(1), Wall(5), Destructible(6)

Layer 3 (PlayerBullet):
- Collides with: Enemy(2), Wall(5), Destructible(6)

Layer 4 (EnemyBullet):
- Collides with: Player(1), Wall(5), Destructible(6)

Layer 5 (Wall):
- Collides with: All moving objects and bullets

Layer 6 (Destructible):
- Collides with: All moving objects and bullets

Layer 7 (Powerup):
- Reserved for future use
```

## 性能考虑

### 实例管理

```
Bullets:
- Created on shoot
- Destroyed on collision or timeout
- No pooling (simple approach)

Enemies:
- Spawned by spawner
- Destroyed on death
- Connected signals cleaned up

Effects:
- Explosion particles (one-shot)
- Auto-destroy after animation
```

### 更新优化

```
Player Tank:
- Always active (single instance)

Enemy Tanks:
- Physics process for AI
- Detection via Area2D (efficient)

Bullets:
- Physics process for movement
- Simple collision detection
```

## 扩展点

### 容易添加的功能

1. **新敌人类型**
   ```
   - Duplicate enemy_tank.tscn
   - Modify @export variables
   - Optional: Extend AI behavior
   ```

2. **道具系统**
   ```
   - Create powerup.tscn (Area2D)
   - Set collision layer 7
   - Implement pickup in player_tank.gd
   ```

3. **新地图**
   ```
   - Duplicate game_world.tscn
   - Rearrange walls and obstacles
   - Update spawn points
   ```

4. **Boss战**
   ```
   - Create boss_tank.tscn
   - Implement advanced AI
   - Spawn at wave milestone
   ```

## 设计模式

### 使用的模式

1. **Singleton Pattern**
   - Global autoload for state management

2. **Observer Pattern**
   - Godot signals for event communication

3. **State Machine Pattern**
   - Enemy AI states (Patrol, Chase, Attack, Retreat)

4. **Factory Pattern**
   - Enemy spawner creates enemy instances
   - Tanks create bullet instances

5. **Component Pattern**
   - Turret as separate node
   - Timers as components

## 最佳实践

### 遵循的原则

- **Single Responsibility**: 每个脚本一个职责
- **DRY**: 共享逻辑通过信号和autoload
- **Loose Coupling**: 使用信号而非直接引用
- **Clear Naming**: 描述性的节点和变量名
- **Export Variables**: 便于在编辑器中调整
- **Groups**: 使用groups便于查找节点

---

**架构优势**:
- 模块化设计易于维护
- 清晰的职责分离
- 可扩展的系统设计
- 性能良好的实现

**架构局限**:
- 没有对象池（简单项目可接受）
- 没有复杂的资源管理
- 适合中小型项目规模
