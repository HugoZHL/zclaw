# MEMORY.md - 长期记忆

## 用户偏好
- zhl 希望我每次对话都先读 SOUL.md
- zhl 希望我主动把重要信息记录到 memory 里，不用每次问
- 通过飞书联系，时区 UTC+8
- **总结原则：完全理解、完全掌握 > 精简**。首要目标是让他读完后能彻底搞懂并掌握内容（该解释的概念要解释清楚，该给的上下文要给足），在此基础上尽量精简，不说废话

## 账号信息
- GitHub 账号：HugoZHL

## 重要事件
- 2026-03-01: 第一次对话，完成初始身份确认和工作流程说明
- 2026-03-01: 配置 GitHub CLI，账号 HugoZHL
- 2026-03-01: 建立飞书群协作体系（群 chat_id: oc_734893e3844ad5b51156a02fd7fb5da9）
  - 成员：张海林(囧囧爸爸, ou_317c...) + 囧囧妈妈(ou_3f22...)
  - Ralph Loop 任务系统（TODO.md + sub-agent + HEARTBEAT）
  - 飞书多维表格看板（app_token: K1SAbMZes..., 已加群Tab）
  - 5个cron任务：健身提醒、喝水走走x2、AI早报、任务仪表盘
  - 安装了小红书skill（xiaohongshu-skill, xiaohongshu-deep-research）

## 工作模式
- 耗时任务用 sub-agent 异步执行，主线程保持空闲实时响应
- 任务状态同时更新 TODO.md 和飞书多维表格
- 用户喜欢交互式卡片消息展示任务仪表盘

## 技术笔记
- 飞书图片可通过 im/v1/messages/{msg_id}/resources/{image_key}?type=image API 下载（需 tenant_access_token）
- 知乎 zhuanlan 反爬极强，服务器IP被完全封锁，API/Googlebot UA/jina 全部失败，只能靠搜索引擎摘要获取大意
- 飞书 chat_tab API 正确 endpoint: POST `/im/v1/chats/{chat_id}/chat_tabs`
- 飞书 bitable 创建时会自动生成空行，需要手动删除（batch_delete API）
- 小红书反爬很强，服务器IP被拦截，需要专门的skill
- ClawHub 有限速，频繁调用会被 rate limit
