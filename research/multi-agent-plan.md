# OpenClaw 多 Agent 架构方案

## 一、核心机制

OpenClaw **原生支持**多 Agent，不需要额外 skill。在 `openclaw.json` 里配置 `agents.list` + `bindings` 即可。

每个 Agent 是一个**完全隔离的大脑**：
- 独立 workspace（SOUL.md / AGENTS.md / USER.md / MEMORY.md / memory/ 等）
- 独立 session 存储（对话历史不串）
- 独立 auth profile（API key 可以不同）
- 可以独立配置 model、sandbox、tool 权限

**所有 Agent 共享同一个 Gateway 进程 + 同一个飞书机器人**，通过 binding 规则路由消息。

## 二、新建 Agent 的步骤

### 2.1 CLI 一键创建

```bash
openclaw agents add <agent-id>
# 例如：
openclaw agents add quant
openclaw agents add research
```

这会自动：
1. 创建 workspace 目录 `~/.openclaw/workspace-<agent-id>`
2. 创建 agentDir `~/.openclaw/agents/<agent-id>/agent`
3. 生成模板 bootstrap 文件（AGENTS.md、SOUL.md、USER.md、IDENTITY.md）

### 2.2 手动创建（更灵活）

```bash
mkdir -p ~/.openclaw/workspace-quant
mkdir -p ~/.openclaw/agents/quant/agent
```

然后往 workspace 里放 md 文件。

## 三、Workspace 文件模板

每个新 Agent workspace 需要以下文件：

### 必须文件

| 文件 | 作用 | 说明 |
|------|------|------|
| `AGENTS.md` | 操作手册 | Agent 的工作规则、记忆管理方式、安全边界 |
| `SOUL.md` | 人格灵魂 | 语气、风格、边界、专长领域 |
| `USER.md` | 用户信息 | 谁在用这个 Agent、怎么称呼、时区 |
| `IDENTITY.md` | 身份标识 | Agent 名字、emoji、头像 |

### 可选文件

| 文件 | 作用 | 说明 |
|------|------|------|
| `TOOLS.md` | 工具笔记 | 环境特定的工具配置（SSH、API endpoint 等） |
| `MEMORY.md` | 长期记忆 | 跨会话记忆（仅私聊加载） |
| `HEARTBEAT.md` | 心跳任务 | 定期检查项 |
| `TODO.md` | 任务队列 | 如果需要 Ralph Loop 任务系统 |
| `memory/` | 日志目录 | 每日记忆 `memory/YYYY-MM-DD.md` |
| `skills/` | 本地 skill | Agent 专属的 skill（覆盖全局） |

## 四、配置示例

### 4.1 openclaw.json 改动

```json5
{
  agents: {
    defaults: {
      model: { primary: "openrouter/anthropic/claude-opus-4.6" },
      workspace: "~/.openclaw/workspace",  // 主 Agent（zclaw）
    },
    list: [
      {
        id: "main",       // 当前的 zclaw
        default: true,
        name: "zclaw",
        workspace: "~/.openclaw/workspace",
      },
      {
        id: "quant",
        name: "量化交易员",
        workspace: "~/.openclaw/workspace-quant",
        // 可以用不同模型：
        // model: "openrouter/anthropic/claude-sonnet-4-5",
      },
      {
        id: "research",
        name: "论文研究员",
        workspace: "~/.openclaw/workspace-research",
      },
    ],
  },

  bindings: [
    // 量化群 → 量化 Agent
    {
      agentId: "quant",
      match: {
        channel: "feishu",
        peer: { kind: "group", id: "oc_b35138984cc18c6c1c764d42973318a1" },
      },
    },
    // 日常群 → 主 Agent（zclaw）
    {
      agentId: "main",
      match: {
        channel: "feishu",
        peer: { kind: "group", id: "oc_734893e3844ad5b51156a02fd7fb5da9" },
      },
    },
    // 其他所有飞书消息 → 主 Agent
    { agentId: "main", match: { channel: "feishu" } },
  ],
}
```

### 4.2 路由逻辑

消息进来 → 按 binding 从上到下匹配 → 最具体的规则优先（peer > channel > default）

**同一个飞书机器人，不同群自动路由到不同 Agent。**

## 五、现有转发模式 vs 独立 Agent 对比

| 维度 | 当前方式（sub-agent） | 新方式（独立 Agent） |
|------|----------------------|---------------------|
| workspace | 共享主 workspace | 各自独立 workspace |
| 记忆 | 共享 MEMORY.md | 各自独立记忆体系 |
| session | 临时的，用完销毁 | 持久的，有完整对话历史 |
| 人格 | 继承主 Agent 的 SOUL.md | 各自有独立的 SOUL.md |
| 路由 | 手动 sessions_spawn | 自动按 binding 规则路由 |
| 群聊 | 同一个 Agent 回复所有群 | 不同群 → 不同 Agent |
| 适用场景 | 一次性任务 | 长期运行的专业角色 |

## 六、推荐的 Agent 规划

基于你目前的需求，建议分以下 Agent：

### 🐾 main (zclaw) — 日常管家
- 绑定：日常管理群 + 私聊
- 职责：健康提醒、任务管理、日常问答、调度其他 Agent
- workspace：当前的 `~/.openclaw/workspace`（不动）

### 📈 quant — 量化交易员
- 绑定：量化讨论群 `oc_b35138984cc18c6c1c764d42973318a1`
- 职责：量化策略开发、回测、CTP 模拟盘、市场数据分析
- 独立记忆：记录交易策略、回测结果、市场洞察
- workspace：`~/.openclaw/workspace-quant`

### 📚 research — 论文研究员（可选）
- 绑定：可以绑定到专门的学术讨论群
- 职责：论文精读、技术总结、实验方案设计
- 独立记忆：记录论文笔记、方法论对比、实验结论

### 💰 money — 赚钱专家（可选，等调研完后决定）
- 绑定：可以创建专门的赚钱项目群
- 职责：执行赚钱计划中的具体任务

## 七、执行计划

1. **选定要创建的 Agent**（你来决定）
2. **我来执行**：
   - `openclaw agents add <id>` 创建 Agent
   - 写好各自的 SOUL.md / AGENTS.md / USER.md
   - 修改 openclaw.json 添加 binding 规则
   - `openclaw gateway restart` 生效
3. **验证**：`openclaw agents list --bindings` 确认路由正确
4. **迁移**：把 QuantTrading 相关的记忆和 TODO 迁移到 quant workspace

## 八、注意事项

- 所有 Agent 共享同一个 OpenRouter API key（可以分开配但没必要）
- 新 Agent 的 workspace 也需要加入 git 备份（更新 backup.sh）
- Agent 之间默认不能互相通信，需要开启 `tools.agentToAgent`
- 可以给不同 Agent 设不同模型（比如日常用 Sonnet 省钱，深度任务用 Opus）

## 九、ClawHub 相关 Skill

搜到了一些相关 skill（但大多是社区方案，质量参差不齐）：
- `multi-agent-cn` — 中文多 Agent 协作
- `openclaw-workspace-pro` — workspace 增强
- `multi-user-workspace` — 多用户 workspace

**建议：不装这些 skill。** OpenClaw 原生多 Agent 能力已经很完善，社区 skill 可能和原生功能冲突。直接用原生配置即可。
