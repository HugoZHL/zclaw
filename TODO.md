# TODO.md - Ralph Loop 任务队列

## 使用说明
- 状态标记：`[ ]` 待办 | `[>]` 进行中 | `[x]` 已完成
- 新任务追加到对应人员的「待办」区域
- 完成后自动移到对应人员的「已完成」区域，并在群里 @ 通知

## 人员信息
- **张海林（囧囧爸爸）** — open_id: `ou_317c2197e63ab5e293e11883592e2124`
- **囧囧妈妈** — open_id: `ou_3f223ff9fa52e3d8da7037eb6708428a`

---

## 🤖 zclaw 今晚自动推进（QuantTrading）

### 待办

### 进行中

### 已完成（深夜自动确认）
- [x] QT-07: CTP 模拟盘联调 — ✅ ctp2rs 绑定 + CtpBroker 实现 + ctp_connect 示例，qt-ctp crate 完整（2026-03-03 ~04:00 UTC）
- [x] QT-10: Broker trait 完善 + 真实期货数据多策略回测 — ✅ Broker trait 已实现，多策略回测完成（2026-03-03 ~04:00 UTC）
- [x] QT-11: Donchian/RollingMinMax O(1) 单调队列优化 — ✅ donchian.rs + rolling_minmax.rs 已实现（2026-03-03 ~04:00 UTC）
- [x] QT-12: Python CTP Bridge 完善（openctp-ctp + IPC 协议）— ✅ Python bridge 层完成（2026-03-03 ~04:00 UTC）
- [x] QT-13: 风控系统 Major 问题修复 — ✅ risk.rs 修复完成，235测试全通过（2026-03-03 ~04:00 UTC）

### 已完成
- [x] QT-09: 整理今晚进展+晨间汇报 — ✅ 已生成 morning_brief_20260303.md 并发送飞书群（2026-03-02 19:22 UTC）
- [x] QT-08: Double Review 全量代码审查 — ✅ 3250行/16文件审查完成，0 Critical，4 Major（修1），227测试全通过（2026-03-02 18:55 UTC）
- [x] QT-06: 多品种组合优化 — ✅ 新增 portfolio 模块(3种权重策略) + 30个单元测试, 7品种DualMA组合年化+26.3%/夏普0.92/回撤17.8%, 227测试全通过（2026-03-02 18:45 UTC）
- [x] QT-05: 实现滚动 Walk-Forward — ✅ 核心逻辑+CLI示例+11个新测试，197测试全通过（2026-03-02 18:21 UTC）
- [x] QT-04: 交易看板完善 — ✅ backtest_dashboard.html 已生成，含热力图/PnL对比/WF验证，186测试全通过（2026-03-02 18:14 UTC）
- [x] QT-01: 合约乘数 + Q切分回测验证 — ✅ 8品种×4策略=32组回测 + Walk-Forward 完成（2026-03-02）
- [x] QT-02: Code Review — ✅ contract.rs + data_split.rs 审查完成，186测试全通过，6个Minor问题（2026-03-02）
- [x] QT-03: 回测报告生成 — ✅ 完整中文报告已写入 `/tmp/QuantTrading/reports/backtest_report_20260302.md`（2026-03-02）

---

## 👨 张海林（囧囧爸爸）

### 待办
- [ ] 🔴 veRL Rollout：POPE 难题探索 — 改约50行 — https://feishu.cn/docx/CRFrdhFvxoYq7rxs3QQcS4lHnZf
- [ ] 🔴 POPE 筛选难题数据集 — 离线跑 pass@128（AIME/MATH L5/LiveCodeBench Hard）
- [ ] 🟡 veRL Rollout：CoBA-RL 动态 rollout 分配 — 改约110行 — https://feishu.cn/docx/CRFrdhFvxoYq7rxs3QQcS4lHnZf
- [ ] 🟡 veRL 优化器：TAMPO 自适应温度 — 改约130行 — https://feishu.cn/docx/XdpxdSDutoo1mBxIjn4c68NQnHd
- [ ] 🔵 veRL Rollout：OPSD 自蒸馏 — 改约200行 — https://feishu.cn/docx/CRFrdhFvxoYq7rxs3QQcS4lHnZf
- [ ] 🔵 Megatron：Spectra 优化器 — 改约300行 — https://feishu.cn/docx/ABYDdEMHHoXi7bxrTmicXupQn4c

### 进行中

### 已完成
- [x] 📖 阅读飞书文档「论文精读：AFD 的挑战与边界」— ✅ 已生成总结并发送到飞书群（2026-03-02 14:06 UTC）
- [x] 小红书帖子总结 — ❌ 未登录无法获取，需扫码登录后重试（2026-03-01 16:22 UTC）
- [x] 安装小红书 skill — ✅ 已安装 xiaohongshu-skill v1.0.2 + xiaohongshu-deep-research v1.2.1（2026-03-01 16:13 UTC）3个可疑skill已拒绝安装

---

## 👩 囧囧妈妈

### 待办

### 进行中

### 已完成

## 待安装技能
- [ ] self-improving-agent (v1.0.11) — 自我反思和错误学习，等 ClawHub rate limit 恢复后安装
- [ ] tavily-search 更新 → 1.0.0 — 等 rate limit 恢复（2026-03-03 再试仍 rate limit）
- [ ] crypto-market-data — ⚠️ VirusTotal 标记可疑，需 zhl 确认是否 --force 安装
- [ ] crypto-stock-market-data — ⚠️ VirusTotal 标记可疑，需 zhl 确认是否 --force 安装
- [ ] n8n-workflow-automation — 🟡 需要 n8n 服务，工作流自动化（需确认是否部署 n8n）
