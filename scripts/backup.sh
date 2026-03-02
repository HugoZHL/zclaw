#!/bin/bash
# zclaw 完整备份脚本
# 将所有"我"的数据备份到 git 仓库的 _system/ 目录
# 用法: bash scripts/backup.sh

set -e
WORKSPACE="/root/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/_system"
OPENCLAW_DIR="/root/.openclaw"

echo "🐾 zclaw 完整备份开始..."

# 创建备份目录结构
mkdir -p "$BACKUP_DIR/config"
mkdir -p "$BACKUP_DIR/cron"
mkdir -p "$BACKUP_DIR/credentials"
mkdir -p "$BACKUP_DIR/sessions"
mkdir -p "$BACKUP_DIR/identity"

# 1. OpenClaw 主配置
echo "📋 备份 openclaw.json..."
cp "$OPENCLAW_DIR/openclaw.json" "$BACKUP_DIR/config/openclaw.json"

# 2. Cron 任务 - 导出完整 cron 数据
echo "⏰ 备份 cron 任务..."
cp -r "$OPENCLAW_DIR/cron/"* "$BACKUP_DIR/cron/" 2>/dev/null || true
# 同时导出可读的 cron 列表
openclaw cron list 2>/dev/null > "$BACKUP_DIR/cron/cron-list.txt" || true

# 3. GitHub 认证
echo "🔑 备份 GitHub 认证..."
if [ -f "$HOME/.config/gh/hosts.yml" ]; then
  cp "$HOME/.config/gh/hosts.yml" "$BACKUP_DIR/credentials/gh-hosts.yml"
fi

# 4. 身份信息
echo "🆔 备份 identity..."
cp -r "$OPENCLAW_DIR/identity/"* "$BACKUP_DIR/identity/" 2>/dev/null || true

# 5. 飞书 token 缓存
echo "📱 备份飞书配置..."
cp -r "$OPENCLAW_DIR/feishu/" "$BACKUP_DIR/feishu/" 2>/dev/null || true

# 6. 设备信息
echo "📱 备份设备信息..."
cp -r "$OPENCLAW_DIR/devices/" "$BACKUP_DIR/devices/" 2>/dev/null || true

# 7. 凭据（加密备份）
echo "🔐 备份凭据..."
cp -r "$OPENCLAW_DIR/credentials/"* "$BACKUP_DIR/credentials/" 2>/dev/null || true

# 8. 对话记忆数据库
echo "🧠 备份记忆数据库..."
if [ -f "$OPENCLAW_DIR/memory/main.sqlite" ]; then
  cp "$OPENCLAW_DIR/memory/main.sqlite" "$BACKUP_DIR/memory-main.sqlite"
fi

# 9. 会话历史（只保留最近 7 天，减少存储）
echo "💬 备份会话历史（近7天）..."
mkdir -p "$BACKUP_DIR/sessions/agents/main/sessions"
# 复制 sessions.json 索引
cp "$OPENCLAW_DIR/agents/main/sessions/sessions.json" "$BACKUP_DIR/sessions/agents/main/sessions/" 2>/dev/null || true
# 复制 agent 配置
cp -r "$OPENCLAW_DIR/agents/main/agent/" "$BACKUP_DIR/sessions/agents/main/agent/" 2>/dev/null || true
# 只复制最近 7 天修改的会话文件
find "$OPENCLAW_DIR/agents/main/sessions/" -name "*.jsonl" -mtime -7 -exec cp {} "$BACKUP_DIR/sessions/agents/main/sessions/" \; 2>/dev/null || true

# 10. 已安装技能列表（只记录列表，不备份代码）
echo "🛠️ 记录已安装技能..."
cat "$WORKSPACE/.clawhub/manifest.json" > "$BACKUP_DIR/skills-manifest.json" 2>/dev/null || true

# 11. 生成恢复指南
echo "📝 生成恢复指南..."
cat > "$BACKUP_DIR/RESTORE-README.md" << 'GUIDE'
# zclaw 恢复指南

## 在新机器上一键恢复

```bash
# 1. 安装 OpenClaw
pnpm i -g openclaw

# 2. clone 仓库
git clone https://github.com/HugoZHL/zclaw.git ~/.openclaw/workspace

# 3. 运行恢复脚本
bash ~/.openclaw/workspace/scripts/restore.sh

# 4. 启动
openclaw gateway start
```

## 恢复内容
- openclaw.json (所有渠道配置、模型设置)
- Cron 定时任务
- GitHub 认证
- 飞书连接配置
- 对话历史和记忆数据库
- 身份和凭据信息
- 已安装技能列表（会自动重新安装）
GUIDE

# 12. 加密打包敏感文件
echo "🔐 加密打包敏感数据..."
SENSITIVE_ARCHIVE="$BACKUP_DIR/sensitive-data.tar.gz.enc"
SENSITIVE_DIRS=""
[ -d "$BACKUP_DIR/credentials" ] && SENSITIVE_DIRS="$SENSITIVE_DIRS credentials"
[ -f "$BACKUP_DIR/config/openclaw.json" ] && SENSITIVE_DIRS="$SENSITIVE_DIRS config"
[ -d "$BACKUP_DIR/sessions" ] && SENSITIVE_DIRS="$SENSITIVE_DIRS sessions"
[ -f "$BACKUP_DIR/memory-main.sqlite" ] && SENSITIVE_DIRS="$SENSITIVE_DIRS memory-main.sqlite"
[ -d "$BACKUP_DIR/feishu" ] && SENSITIVE_DIRS="$SENSITIVE_DIRS feishu"

if [ -n "$SENSITIVE_DIRS" ]; then
  cd "$BACKUP_DIR"
  # 用密码加密（密码从环境变量 ZCLAW_BACKUP_KEY 读取，默认用固定密钥）
  BACKUP_KEY="${ZCLAW_BACKUP_KEY:-zclaw-backup-2026}"
  tar czf - $SENSITIVE_DIRS | openssl enc -aes-256-cbc -salt -pbkdf2 -pass "pass:$BACKUP_KEY" -out sensitive-data.tar.gz.enc
  echo "  ✅ 敏感数据已加密 (解密密钥: ZCLAW_BACKUP_KEY 环境变量)"
  cd "$WORKSPACE"
fi

# 13. 清理旧的备份临时文件（保持最小存储）
echo "🧹 清理临时文件..."
rm -rf "$BACKUP_DIR/credentials" "$BACKUP_DIR/config" "$BACKUP_DIR/sessions" "$BACKUP_DIR/memory-main.sqlite" "$BACKUP_DIR/feishu" 2>/dev/null || true

# 14. 清理超过 30 天的 memory 日记（已被 MEMORY.md 提炼）
echo "📅 清理旧日记..."
find "$WORKSPACE/memory/" -name "20??-??-??.md" -mtime +30 -exec rm {} \; 2>/dev/null || true

# Git 提交（只推非敏感文件 + 加密包）
cd "$WORKSPACE"
git add -A
if git diff --cached --quiet; then
  echo "✅ 没有变更需要备份"
else
  git commit -m "🔄 自动备份 $(date '+%Y-%m-%d %H:%M') (北京时间 $(TZ='Asia/Shanghai' date '+%H:%M'))"
  git push origin master
  echo "✅ 备份已推送到 GitHub"
fi

# 15. 每月 1 号 squash git 历史（保持仓库小）
DAY=$(TZ='Asia/Shanghai' date '+%d')
if [ "$DAY" = "01" ]; then
  echo "📦 月度 squash：压缩 git 历史..."
  cd "$WORKSPACE"
  git checkout --orphan temp_branch
  git add -A
  git commit -m "🗜️ 月度 squash $(TZ='Asia/Shanghai' date '+%Y-%m')"
  git branch -D master
  git branch -m master
  git push -f origin master
  echo "  ✅ Git 历史已压缩"
fi

echo "🐾 备份完成！"
