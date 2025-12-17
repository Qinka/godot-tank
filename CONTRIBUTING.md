# 贡献指南 (Contributing Guide)

感谢您对坦克大战项目的关注！我们欢迎各种形式的贡献。

## 如何贡献

### 报告问题 (Bug Reports)

如果您发现了bug，请创建一个Issue并包含以下信息：
- 问题的详细描述
- 重现步骤
- 预期行为
- 实际行为
- 您的环境（操作系统、Godot版本等）
- 如果可能，附上截图或视频

### 功能建议 (Feature Requests)

如果您有新功能的想法：
- 创建一个Issue描述您的建议
- 解释为什么这个功能对游戏有价值
- 如果可能，提供实现的思路

### 提交代码 (Pull Requests)

1. **Fork项目**
   ```bash
   # 在GitHub上Fork项目后
   git clone https://github.com/YOUR_USERNAME/godot-tank.git
   cd godot-tank
   ```

2. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   # 或
   git checkout -b fix/bug-description
   ```

3. **进行修改**
   - 遵循现有的代码风格
   - 添加适当的注释（支持中文注释）
   - 测试您的更改

4. **提交更改**
   ```bash
   git add .
   git commit -m "描述您的更改"
   ```

5. **推送并创建PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   然后在GitHub上创建Pull Request

## 代码规范

### GDScript 风格

- 使用Tab缩进
- 变量名使用snake_case: `player_health`, `max_speed`
- 函数名使用snake_case: `move_player()`, `take_damage()`
- 常量使用UPPER_CASE: `MAX_HEALTH`, `SPAWN_RATE`
- 类名使用PascalCase（如果需要）
- 私有变量/函数使用下划线前缀: `_internal_function()`

### 注释规范

```gdscript
# 单行注释使用中文或英文都可以

## 文档注释（用于导出的函数和类）
## 描述函数的功能
## 参数：
##   damage: 伤害值
## 返回：
##   bool: 是否成功造成伤害
func take_damage(damage: int) -> bool:
	pass
```

### 场景组织

- 场景文件使用snake_case命名: `player_tank.tscn`
- 节点命名使用PascalCase: `PlayerTank`, `ShootPoint`
- 保持场景树结构清晰，合理使用Node2D组织子节点

### 信号使用

```gdscript
# 信号名称使用snake_case
signal health_changed(new_health)
signal player_died()

# 连接信号使用.connect()方法
player.health_changed.connect(_on_player_health_changed)
```

## 开发流程

### 本地开发

1. **打开项目**
   - 使用Godot 4.3或更高版本
   - 打开`project.godot`文件

2. **测试更改**
   - 按F5运行游戏
   - 测试所有受影响的功能
   - 确保没有破坏现有功能

3. **性能检查**
   - 使用Godot的性能监视器
   - 确保帧率稳定
   - 检查内存使用

### 添加新功能

1. **计划功能**
   - 在Issue中讨论功能设计
   - 考虑与现有系统的集成

2. **实现功能**
   - 创建必要的场景和脚本
   - 遵循现有的架构模式
   - 添加适当的注释

3. **测试功能**
   - 测试各种使用场景
   - 测试边界条件
   - 测试与其他系统的交互

### 修复Bug

1. **重现Bug**
   - 确保能够稳定重现
   - 记录重现步骤

2. **定位问题**
   - 使用print()调试
   - 使用Godot调试器
   - 检查相关代码

3. **修复并测试**
   - 最小化更改范围
   - 测试修复效果
   - 确保不引入新问题

## 项目结构说明

### 核心系统

- `autoload/global.gd`: 全局游戏状态管理
- `scripts/game_manager.gd`: 游戏流程控制
- `scripts/enemy_spawner.gd`: 敌人生成系统

### 实体系统

- `scripts/player_tank.gd`: 玩家控制逻辑
- `scripts/enemy_tank.gd`: 敌人AI逻辑
- `scripts/bullet.gd`: 子弹物理和碰撞

### UI系统

- `scripts/hud.gd`: 游戏内HUD显示
- `scripts/main_menu.gd`: 主菜单逻辑
- `scripts/game_over.gd`: 游戏结束界面

### 碰撞层说明

- Layer 1: Player - 玩家
- Layer 2: Enemy - 敌人
- Layer 3: PlayerBullet - 玩家子弹
- Layer 4: EnemyBullet - 敌人子弹
- Layer 5: Wall - 墙壁
- Layer 6: Destructible - 可破坏物
- Layer 7: Powerup - 道具（预留）

## 常见任务

### 添加新的敌人类型

1. 复制`scenes/entities/enemy_tank.tscn`
2. 修改外观和属性
3. 如需特殊行为，继承或修改AI脚本
4. 在enemy_spawner中添加生成逻辑

### 添加新的道具

1. 创建新场景（Area2D）
2. 设置碰撞层为Layer 7
3. 实现拾取逻辑
4. 在玩家脚本中处理道具效果

### 添加新的地图元素

1. 创建场景（StaticBody2D）
2. 设置适当的碰撞层
3. 添加视觉效果
4. 在game_world场景中放置

### 添加音效

1. 将音频文件放入`assets/sounds/`
2. 在场景中添加AudioStreamPlayer2D
3. 在脚本中调用`play()`方法

## 资源规范

### 图片资源

- 格式：PNG（带透明通道）
- 尺寸：坦克 64x64, 地图元素 50x50
- 导入设置：Filter=Nearest（像素风格）

### 音频资源

- 音效：WAV格式，短小精悍
- 音乐：OGG格式，循环播放
- 音量：标准化处理，避免爆音

## 测试清单

提交前请检查：

- [ ] 代码没有语法错误
- [ ] 游戏可以正常启动
- [ ] 所有核心功能正常工作
- [ ] 没有明显的性能问题
- [ ] 添加了必要的注释
- [ ] 更新了相关文档
- [ ] 没有提交临时文件或测试代码

## 获取帮助

如果您在贡献过程中遇到问题：

1. 查看现有的Issue和PR
2. 阅读Godot官方文档
3. 在Issue中提问
4. 加入社区讨论

## 行为准则

- 尊重所有贡献者
- 建设性地提供反馈
- 专注于改进项目
- 保持友好和专业

感谢您的贡献！🎮
