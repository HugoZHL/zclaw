# zclaw 完整恢复指南

## 一键恢复（新机器上执行）

```bash
# 1. 安装 OpenClaw
pnpm i -g openclaw

# 2. Clone 仓库
git clone https://github.com/HugoZHL/zclaw.git ~/.openclaw/workspace

# 3. 设置解密密钥（可选，默认有内置密钥）
export ZCLAW_BACKUP_KEY="zclaw-backup-2026"

# 4. 一键恢复
bash ~/.openclaw/workspace/scripts/restore.sh

# 5. 启动
openclaw gateway start
```

## 恢复内容清单

| 类别 | 说明 | 存储方式 |
|------|------|----------|
| 身份文件 | SOUL.md, IDENTITY.md, USER.md | 明文 git |
| 记忆 | MEMORY.md, memory/*.md | 明文 git |
| 工作配置 | AGENTS.md, TOOLS.md, HEARTBEAT.md | 明文 git |
| Cron 任务 | 所有定时任务定义和历史 | 明文 git |
| 设备信息 | 配对设备列表 | 明文 git |
| 技能列表 | skills-manifest.json → 自动重装 | 明文 git |
| openclaw.json | 渠道配置、模型设置、API key | 加密包 |
| GitHub 认证 | gh CLI token | 加密包 |
| 飞书配置 | token 缓存 | 加密包 |
| 凭据 | 各种服务凭据 | 加密包 |
| 会话历史 | 最近 7 天对话记录 | 加密包 |
| 记忆数据库 | SQLite 语义搜索库 | 加密包 |

## 最小存储策略

- 每月 1 号自动 squash git 历史
- 只保留最近 7 天会话（旧的已被 MEMORY.md 提炼）
- 技能代码不备份（从 ClawHub 重装）
- 超过 30 天的日记自动清理

## 注意事项

- 如果 token 过期，需手动更新 openclaw.json 中的 API key
- 如果 GitHub token 过期，运行 `gh auth login`
- 飞书 webhook 地址如果变了，需在飞书后台更新回调 URL
- 加密密钥通过环境变量 `ZCLAW_BACKUP_KEY` 设置
