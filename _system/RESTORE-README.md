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
