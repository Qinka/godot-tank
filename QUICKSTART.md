# 快速开始指南 (Quick Start Guide)

## 5分钟上手坦克大战

### 1. 安装 Godot

1. 访问 [Godot 官网](https://godotengine.org/download)
2. 下载 **Godot 4.3** 或更高版本
3. 解压并运行 Godot 编辑器

### 2. 打开项目

1. 克隆项目仓库：
   ```bash
   git clone https://github.com/Qinka/godot-tank.git
   cd godot-tank
   ```

2. 启动 Godot 编辑器

3. 点击 "Import"（导入）

4. 选择项目文件夹中的 `project.godot` 文件

5. 点击 "Import & Edit"（导入并编辑）

### 3. 运行游戏

- 按 **F5** 键启动游戏
- 或点击编辑器右上角的播放按钮 ▶️

### 4. 游戏操作

#### 移动控制
- **W** 或 **↑** - 向上移动
- **S** 或 **↓** - 向下移动
- **A** 或 **←** - 向左移动
- **D** 或 **→** - 向右移动

#### 战斗操作
- **鼠标移动** - 控制炮塔瞄准
- **空格键** 或 **鼠标左键** - 发射子弹

#### 其他操作
- **ESC** - 暂停游戏

### 5. 游戏目标

- 🎯 消灭所有敌方坦克
- 🛡️ 保护自己的生命值
- 📈 获得尽可能高的分数
- 🌊 尽可能存活更多波次

### 6. 游戏提示

#### 战斗技巧
- 利用墙壁作为掩护
- 保持移动，避免被敌人包围
- 注意射击冷却时间
- 每波开始时敌人会从四个角落生成

#### 得分机制
- 击败一个敌人：+100 分
- 每 10000 分获得 1 条额外生命

#### 敌人AI
- **巡逻状态**：敌人随机移动
- **追击状态**：发现你后会快速接近
- **攻击状态**：在合适距离保持并射击
- **撤退状态**：距离过近时会后退

### 7. 修改游戏（可选）

#### 调整难度

编辑 `scripts/player_tank.gd`:
```gdscript
@export var speed: float = 200.0        # 增加速度让游戏更简单
@export var max_health: int = 3         # 增加生命让游戏更简单
@export var shoot_cooldown: float = 0.5 # 减少冷却让游戏更简单
```

编辑 `scripts/enemy_tank.gd`:
```gdscript
@export var speed: float = 100.0        # 减少速度让游戏更简单
@export var max_health: int = 2         # 减少生命让游戏更简单
```

编辑 `scripts/enemy_spawner.gd`:
```gdscript
@export var enemies_per_wave: int = 3   # 减少数量让游戏更简单
@export var spawn_interval: float = 2.0 # 增加间隔让游戏更简单
```

#### 更换美术资源

1. 准备你的图片资源（PNG格式，建议 64x64 像素）

2. 将图片放入 `assets/textures/tanks/` 文件夹

3. 在 Godot 编辑器中：
   - 打开 `scenes/entities/player_tank.tscn`
   - 选择 `Sprite2D` 节点
   - 在右侧 Inspector 中找到 `Texture` 属性
   - 拖入你的图片文件

4. 重复以上步骤更换敌人坦克、子弹等的贴图

#### 添加音效

1. 准备音效文件（WAV 或 OGG 格式）

2. 将文件放入 `assets/sounds/` 文件夹

3. 在对应的场景中添加 `AudioStreamPlayer2D` 节点

4. 在脚本中播放：
   ```gdscript
   $AudioStreamPlayer2D.play()
   ```

### 8. 导出游戏

#### Windows 版本

1. 在 Godot 编辑器中点击 `Project` → `Export`
2. 点击 `Add...` 添加 Windows 导出模板
3. 点击 `Export Project`
4. 选择保存位置，点击保存

#### Linux 版本

1. 在 Godot 编辑器中点击 `Project` → `Export`
2. 点击 `Add...` 添加 Linux 导出模板
3. 点击 `Export Project`
4. 选择保存位置，点击保存

#### Web 版本 (HTML5)

1. 在 Godot 编辑器中点击 `Project` → `Export`
2. 点击 `Add...` 添加 HTML5 导出模板
3. 点击 `Export Project`
4. 选择保存位置，会生成一个 HTML 文件和相关资源
5. 可以上传到 itch.io 或其他游戏平台

### 9. 故障排除

#### 问题：游戏无法启动
- 确认 Godot 版本是 4.3 或更高
- 检查是否有错误信息显示在编辑器底部
- 尝试重新导入项目

#### 问题：角色无法移动
- 检查输入映射是否正确（Project → Project Settings → Input Map）
- 确认使用的是 WASD 或方向键

#### 问题：子弹不发射
- 检查是否有错误信息
- 确认 bullet.tscn 场景存在
- 检查射击冷却是否太长

#### 问题：敌人不出现
- 检查 enemy_spawner 节点是否存在
- 确认生成点（SpawnPoint）设置正确
- 查看编辑器输出是否有错误

### 10. 进一步学习

- 📚 [Godot 官方文档](https://docs.godotengine.org/)
- 🎮 [Godot 2D 游戏教程](https://docs.godotengine.org/en/stable/tutorials/2d/index.html)
- 💬 [Godot 中文社区](https://godotengine.org/)
- 📖 查看项目的 `README.md` 了解更多细节
- 📝 查看 `CONTRIBUTING.md` 了解如何贡献

### 11. 需要帮助？

- 📬 在 GitHub 上提交 Issue
- 💡 查看已有的 Issue 和讨论
- 📖 阅读代码中的注释

---

**准备好了吗？按 F5 开始游戏！** 🚀
