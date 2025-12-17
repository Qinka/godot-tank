# 坦克大战 (Godot Tank Battle)

一款使用 Godot 4.x 引擎开发的经典坦克大战游戏。

![Game Version](https://img.shields.io/badge/version-1.0.0-blue)
![Godot Version](https://img.shields.io/badge/godot-4.3-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 📋 目录

- [游戏简介](#游戏简介)
- [游戏特性](#游戏特性)
- [游戏截图](#游戏截图)
- [控制说明](#控制说明)
- [运行方法](#运行方法)
- [项目结构](#项目结构)
- [开发环境要求](#开发环境要求)
- [游戏机制详解](#游戏机制详解)
- [扩展功能](#扩展功能未实现)
- [自定义和扩展](#自定义和扩展)
- [贡献指南](#贡献指南)
- [许可证](#许可证)

## 游戏简介

这是一款经典的坦克大战游戏，玩家需要控制坦克击败一波又一波的敌方坦克。游戏包含智能AI敌人、多种障碍物、波次系统等特性。

## 游戏特性

### 核心玩法
- 🎮 流畅的坦克移动和瞄准系统
- 🔫 射击系统，带冷却时间
- 🤖 智能AI敌人，具有多种行为状态
- 💥 完整的战斗系统和生命值管理
- 🏆 计分系统和波次进度

### 游戏系统
- **玩家系统**：WASD移动，鼠标瞄准，点击或空格射击
- **敌人AI**：包含巡逻、追击、攻击、撤退等状态
- **波次系统**：敌人数量随波次递增，难度逐渐提升
- **环境系统**：不可破坏的墙壁和可破坏的砖块
- **UI界面**：主菜单、游戏HUD、游戏结束界面

## 游戏截图

*游戏使用简单的几何形状作为占位符，可以替换为自定义的美术资源*

## 控制说明

### 键盘控制
- **W / ↑** - 向上移动
- **S / ↓** - 向下移动
- **A / ←** - 向左移动
- **D / →** - 向右移动
- **空格键** - 发射子弹
- **ESC** - 暂停游戏

### 鼠标控制
- **鼠标移动** - 控制炮塔瞄准方向
- **鼠标左键** - 发射子弹

## 运行方法

### 使用 Godot 编辑器
1. 下载并安装 [Godot 4.3 或更高版本](https://godotengine.org/download)
2. 克隆或下载本项目
   ```bash
   git clone https://github.com/Qinka/godot-tank.git
   cd godot-tank
   ```
3. 使用 Godot 编辑器打开项目
4. 点击运行按钮 (F5) 启动游戏

### 导出游戏
1. 在 Godot 编辑器中打开项目
2. 点击 `项目` -> `导出`
3. 选择目标平台（Windows, Linux, macOS, HTML5等）
4. 配置导出设置
5. 点击 `导出项目` 生成可执行文件

## 项目结构

```
godot-tank/
├── project.godot           # 项目配置文件
├── icon.svg               # 项目图标
├── README.md              # 项目文档
├── scenes/                # 场景文件夹
│   ├── menu/             # 菜单场景
│   │   ├── main_menu.tscn
│   │   └── game_over.tscn
│   ├── game/             # 游戏场景
│   │   ├── game_world.tscn
│   │   └── hud.tscn
│   ├── entities/         # 实体场景
│   │   ├── player_tank.tscn
│   │   ├── enemy_tank.tscn
│   │   ├── bullet.tscn
│   │   └── explosion.tscn
│   └── environment/      # 环境场景
│       ├── wall.tscn
│       └── brick.tscn
├── scripts/              # 脚本文件夹
│   ├── player_tank.gd
│   ├── enemy_tank.gd
│   ├── bullet.gd
│   ├── game_manager.gd
│   ├── enemy_spawner.gd
│   ├── hud.gd
│   ├── main_menu.gd
│   ├── game_over.gd
│   └── brick.gd
├── autoload/             # 自动加载脚本
│   └── global.gd
└── assets/               # 资源文件夹
    ├── textures/
    ├── sounds/
    └── fonts/
```

## 开发环境要求

- **Godot 版本**: 4.3 或更高
- **编程语言**: GDScript
- **支持平台**: Windows, Linux, macOS, Web (HTML5)

## 游戏机制详解

### 玩家坦克
- **生命值**: 3 条命
- **移动速度**: 200 像素/秒
- **射击冷却**: 0.5 秒
- **受伤后**: 2 秒无敌时间（闪烁效果）

### 敌方坦克
- **生命值**: 2 点
- **移动速度**: 100 像素/秒
- **射击冷却**: 1.5 秒
- **检测范围**: 400 像素
- **攻击范围**: 300 像素
- **分数价值**: 100 分

### 敌人AI行为
1. **巡逻状态**: 随机选择目标点移动
2. **追击状态**: 发现玩家后快速接近
3. **攻击状态**: 保持距离并射击
4. **撤退状态**: 距离过近时后退

### 子弹系统
- **速度**: 500 像素/秒
- **伤害**: 1 点
- **最大距离**: 1000 像素
- **碰撞检测**: 击中目标或障碍物后消失

### 波次系统
- 第1波: 3 个敌人
- 每增加一波: +2 个敌人
- 清空所有敌人后，3秒延迟进入下一波

### 得分系统
- 击败敌人: +100 分
- 每 10000 分: 额外获得 1 条命

## 扩展功能（未实现）

以下功能可以作为游戏的扩展方向：

- 🎨 更丰富的美术资源（坦克、地图、特效）
- 🔊 音效和背景音乐
- 💎 道具系统（血包、武器升级、护盾等）
- 🗺️ 多个关卡/地图
- 👾 更多敌人类型和Boss战
- ⚡ 粒子效果和屏幕震动
- 🎯 更高级的AI行为
- 🏅 成就系统
- 📊 排行榜系统
- 👥 多人模式

## 自定义和扩展

### 调整游戏参数

你可以在以下脚本中轻松调整游戏参数：

**玩家坦克** (`scripts/player_tank.gd`):
```gdscript
@export var speed: float = 200.0
@export var max_health: int = 3
@export var shoot_cooldown: float = 0.5
```

**敌方坦克** (`scripts/enemy_tank.gd`):
```gdscript
@export var speed: float = 100.0
@export var max_health: int = 2
@export var shoot_cooldown: float = 1.5
@export var detection_range: float = 400.0
```

**波次生成** (`scripts/enemy_spawner.gd`):
```gdscript
@export var enemies_per_wave: int = 3
@export var spawn_interval: float = 2.0
```

### 添加新的美术资源

1. 将图片文件放入 `assets/textures/` 对应文件夹
2. 在 Godot 编辑器中打开对应的场景文件
3. 选择 `Sprite2D` 节点
4. 将 `texture` 属性设置为你的图片资源
5. 调整碰撞形状以匹配新的外观

### 添加音效

1. 将音频文件放入 `assets/sounds/` 文件夹
2. 在场景中添加 `AudioStreamPlayer2D` 节点
3. 设置 `stream` 属性为你的音频文件
4. 在脚本中调用 `audio_player.play()` 播放音效

## 贡献指南

欢迎贡献代码、报告问题或提出新功能建议！

1. Fork 本项目
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

## 已知问题

- 使用简单几何形状作为占位符，需要添加真实的美术资源
- 没有音效和背景音乐
- 暂停菜单功能尚未完全实现
- 某些边缘情况下AI可能会卡住

## 技术细节

### 碰撞层配置
- Layer 1: Player (玩家)
- Layer 2: Enemy (敌人)
- Layer 3: PlayerBullet (玩家子弹)
- Layer 4: EnemyBullet (敌人子弹)
- Layer 5: Wall (墙壁)
- Layer 6: Destructible (可破坏物)
- Layer 7: Powerup (道具，预留）

### 信号系统
游戏使用 Godot 的信号系统进行组件间通信：
- `Global.score_changed` - 分数变化
- `Global.lives_changed` - 生命值变化
- `Global.wave_changed` - 波次变化
- `Global.game_state_changed` - 游戏状态变化

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 致谢

- Godot 游戏引擎团队
- 经典坦克大战游戏的灵感来源

## 联系方式

如有问题或建议，请通过以下方式联系：
- GitHub Issues: [项目Issues页面](https://github.com/Qinka/godot-tank/issues)

---

**祝游戏愉快！🎮**
