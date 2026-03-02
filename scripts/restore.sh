#!/bin/bash
# zclaw 一键恢复脚本
# 在新机器上从 git 仓库恢复所有配置
# 前提：已安装 openclaw、gh、git
# 用法: bash scripts/restore.sh

set -e
WORKSPACE="/root/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/_system"
OPENCLAW_DIR="/root/.openclaw"

echo "🐾 zclaw 恢复开始..."

# 检查备份目录
if [ ! -d "$BACKUP_DIR" ]; then
  echo "❌ 找不到备份目录 $BACKUP_DIR"
  echo "请先 clone 仓库: git clone https://github.com/HugoZHL/zclaw.git ~/.openclaw/workspace"
  exit 1
fi

# 0. 解密敏感数据
echo "🔐 解密敏感数据..."
if [ -f "$BACKUP_DIR/sensitive-data.tar.gz.enc" ]; then
  BACKUP_KEY="${ZCLAW_BACKUP_KEY:-zclaw-backup-2026}"
  cd "$BACKUP_DIR"
  openssl enc -aes-256-cbc -d -salt -pbkdf2 -pass "pass:$BACKUP_KEY" -in sensitive-data.tar.gz.enc | tar xzf -
  cd "$WORKSPACE"
  echo "  ✅ 敏感数据已解密"
else
  echo "  ⚠️ 没有找到加密备份文件，跳过"
fi

# 1. 恢复 openclaw.json
echo "📋 恢复 openclaw.json..."
if [ -f "$BACKUP_DIR/config/openclaw.json" ]; then
  # 备份现有配置（如果有）
  [ -f "$OPENCLAW_DIR/openclaw.json" ] && cp "$OPENCLAW_DIR/openclaw.json" "$OPENCLAW_DIR/openclaw.json.pre-restore"
  cp "$BACKUP_DIR/config/openclaw.json" "$OPENCLAW_DIR/openclaw.json"
  echo "  ✅ openclaw.json 已恢复"
fi

# 2. 恢复 GitHub 认证
echo "🔑 恢复 GitHub 认证..."
if [ -f "$BACKUP_DIR/credentials/gh-hosts.yml" ]; then
  mkdir -p "$HOME/.config/gh"
  cp "$BACKUP_DIR/credentials/gh-hosts.yml" "$HOME/.config/gh/hosts.yml"
  echo "  ✅ GitHub 认证已恢复"
fi

# 3. 恢复 Cron 数据
echo "⏰ 恢复 cron 任务..."
if [ -d "$BACKUP_DIR/cron" ]; then
  mkdir -p "$OPENCLAW_DIR/cron"
  cp -r "$BACKUP_DIR/cron/"* "$OPENCLAW_DIR/cron/" 2>/dev/null || true
  echo "  ✅ Cron 数据已恢复（重启 gateway 后生效）"
fi

# 4. 恢复身份信息
echo "🆔 恢复 identity..."
if [ -d "$BACKUP_DIR/identity" ]; then
  mkdir -p "$OPENCLAW_DIR/identity"
  cp -r "$BACKUP_DIR/identity/"* "$OPENCLAW_DIR/identity/" 2>/dev/null || true
  echo "  ✅ 身份信息已恢复"
fi

# 5. 恢复飞书配置
echo "📱 恢复飞书配置..."
if [ -d "$BACKUP_DIR/feishu" ]; then
  mkdir -p "$OPENCLAW_DIR/feishu"
  cp -r "$BACKUP_DIR/feishu/"* "$OPENCLAW_DIR/feishu/" 2>/dev/null || true
  echo "  ✅ 飞书配置已恢复"
fi

# 6. 恢复设备信息
echo "📱 恢复设备信息..."
if [ -d "$BACKUP_DIR/devices" ]; then
  mkdir -p "$OPENCLAW_DIR/devices"
  cp -r "$BACKUP_DIR/devices/"* "$OPENCLAW_DIR/devices/" 2>/dev/null || true
  echo "  ✅ 设备信息已恢复"
fi

# 7. 恢复凭据
echo "🔐 恢复凭据..."
if [ -d "$BACKUP_DIR/credentials" ]; then
  mkdir -p "$OPENCLAW_DIR/credentials"
  # 复制除 gh-hosts.yml 之外的凭据
  for f in "$BACKUP_DIR/credentials/"*; do
    fname=$(basename "$f")
    [ "$fname" = "gh-hosts.yml" ] && continue
    cp "$f" "$OPENCLAW_DIR/credentials/" 2>/dev/null || true
  done
  echo "  ✅ 凭据已恢复"
fi

# 8. 恢复记忆数据库
echo "🧠 恢复记忆数据库..."
if [ -f "$BACKUP_DIR/memory-main.sqlite" ]; then
  mkdir -p "$OPENCLAW_DIR/memory"
  cp "$BACKUP_DIR/memory-main.sqlite" "$OPENCLAW_DIR/memory/main.sqlite"
  echo "  ✅ 记忆数据库已恢复"
fi

# 9. 恢复会话历史
echo "💬 恢复会话历史..."
if [ -d "$BACKUP_DIR/sessions" ]; then
  cp -r "$BACKUP_DIR/sessions/"* "$OPENCLAW_DIR/agents/" 2>/dev/null || true
  echo "  ✅ 会话历史已恢复"
fi

# 10. 重新安装技能
echo "🛠️ 安装技能..."
if [ -f "$BACKUP_DIR/skills-manifest.json" ]; then
  skills=$(cat "$BACKUP_DIR/skills-manifest.json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for name in data.get('skills', {}):
    print(name)
" 2>/dev/null || true)
  
  if [ -n "$skills" ]; then
    for skill in $skills; do
      echo "  📦 安装 $skill..."
      clawhub install "$skill" 2>/dev/null || echo "  ⚠️ $skill 安装失败，可稍后手动安装"
    done
  fi
  echo "  ✅ 技能安装完成"
fi

# 11. 设置 git 用户信息
echo "🔧 配置 git..."
git config --global user.name "zclaw-bot" 2>/dev/null || true
git config --global user.email "zclaw-bot@users.noreply.github.com" 2>/dev/null || true

echo ""
echo "============================================"
echo "🐾 zclaw 恢复完成！"
echo "============================================"
echo ""
echo "下一步："
echo "  1. 启动 gateway:  openclaw gateway start"
echo "  2. 验证状态:      openclaw status"
echo "  3. 检查 cron:     openclaw cron list"
echo ""
echo "⚠️ 注意事项："
echo "  - 如果 token 过期，需要更新 openclaw.json 中的 API key"
echo "  - 如果 GitHub token 过期，运行: gh auth login"
echo "  - 飞书 webhook 地址如果变了，需要在飞书后台更新"
echo ""
