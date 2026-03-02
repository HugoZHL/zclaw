# MEMORY.md - 长期记忆

## 用户偏好
- zhl 希望我每次对话都先读 SOUL.md
- zhl 希望我主动把重要信息记录到 memory 里，不用每次问
- 通过飞书联系，时区 UTC+8
- **读 paper/blog 总结模板**（2026-03-02 确认）：
  1. 核心内容总结
  2. 代码修改位置、改动量分析（改哪一层？Python/CUDA/通信？多少行？）
  3. 各个技术/trick 的单独贡献分析（有 ablation 就引用数据）
  4. 与当前最强 baseline 的对比分析（不只是论文选的 baseline，要判断是否缺少关键对比）
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
- **代码原则：如无必要勿增实体（奥卡姆剃刀）**
- **定时汇报：每天10:00-22:00每两小时一次（cron id: a53f47bc）**

## QuantTrading 项目
- GitHub: https://github.com/HugoZHL/QuantTrading
- 本地: /tmp/QuantTrading
- 技术栈: Rust 核心 + Python 研究层
- 架构: 6 crate（qt-common, qt-data, qt-engine, qt-indicators, qt-cta, qt-factor）
- 状态: 142 tests passing, 0 warnings
- 策略优先级: CTA期货 > A股多因子 > AI情绪 > 市场中性 > 期权波动率
- 下一步: Broker trait → 真实数据回测 → CTP模拟盘
- Git: user "QuantTrading Bot", PAT token 已配置
- DEV_PROCESS.md: Plan→Implement→Double Review→Iterate→Ship
- 飞书讨论群: oc_b35138984cc18c6c1c764d42973318a1

## 技术笔记
- 飞书图片可通过 im/v1/messages/{msg_id}/resources/{image_key}?type=image API 下载（需 tenant_access_token）
- 知乎 zhuanlan 反爬极强，服务器IP被完全封锁，API/Googlebot UA/jina 全部失败，只能靠搜索引擎摘要获取大意
- 飞书 chat_tab API 正确 endpoint: POST `/im/v1/chats/{chat_id}/chat_tabs`
- 飞书 bitable 创建时会自动生成空行，需要手动删除（batch_delete API）
- 小红书反爬很强，服务器IP被拦截，需要专门的skill
- ClawHub 有限速，频繁调用会被 rate limit
- 知乎封禁更新：搜狗微信搜索可找到公众号转载 → curl+mobile UA 抓 js_content div 提取全文
- 飞书文档 write API 有内容长度限制，长文档需分段 append
- 微信公众号 web_fetch 只拿标题（JS渲染），curl 抓 HTML 的 js_content div 可提取全文

## 用户工作背景（大模型后训练）
- zhl 做超大规模大模型后训练（post-training），目标提升基座模型通用能力
- 已实现：纯 RL（GRPO/DAPO）+ OPD（On-Policy Distillation）
- 评估方法论：The Bitter Lesson — scale with compute > human knowledge injection
- 待实验：POPE（难题 prefix 探索，arXiv:2601.18779）+ OPSD（自蒸馏，github.com/siyan-zhao/OPSD）
- 飞书实验计划文档：https://feishu.cn/docx/M8PRdLyWmoJ3CexP09scjrGEnOg
- 飞书待办看板：https://feishu.cn/docx/UseZdL4IRoYMMYxPbrXcI0oXnNg
