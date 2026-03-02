# DEV_PROCESS.md — 代码开发标准流程

## 核心原则
1. **如无必要，勿增实体**（奥卡姆剃刀）— 每一行代码、每一个模块都要有存在的理由
2. **简洁、清晰** — 代码是写给人看的，顺便给机器执行
3. **每个模块必须有单元测试，整体必须有端到端测试**
4. **代码通过双人review才算完成**

## 标准流程（5个阶段）

### 阶段1：Planning（规划）
1. 分析需求，确定模块结构
2. 输出 `docs/plan-<feature>.md`，包含：
   - 模块划分和职责
   - 接口/trait 设计
   - 数据结构定义
   - 依赖关系图
   - 测试计划（单元测试 + E2E测试的用例列表）
3. Plan 文件 commit 到仓库

### 阶段2：Implementation（实现）
1. 按 plan 逐模块实现
2. **每个模块同步写单元测试**（不是事后补）
3. 写端到端集成测试
4. 确保 `cargo build && cargo test` 全部通过
5. 0 errors, 0 warnings

### 阶段3：Review（双人审查）
1. 派出 **2个独立 sub-agent** 并行 review：
   - **Reviewer A**：代码质量审查（架构、命名、错误处理、边界条件、性能）
   - **Reviewer B**：测试覆盖审查（测试是否充分、边界用例、E2E覆盖率）
2. 两个 reviewer 都要对照 plan 文件检查实现完整度
3. 输出 review 报告，列出所有问题（Critical / Major / Minor）

### 阶段4：Iteration（迭代修复）
1. 根据 review 报告修复所有 Critical 和 Major 问题
2. Minor 问题视情况修复
3. 重新编译和测试
4. 再派 **2个新 sub-agent** review（不能用同一个session，要fresh eyes）
5. 重复直到两个 reviewer 都报告 **0 Critical, 0 Major**

### 阶段5：Ship（发布）
1. 最终 `cargo build && cargo test` 确认
2. git commit + push
3. 发群通知，附上完成摘要

## 测试要求

### 单元测试
- 每个 pub fn 至少1个正常路径测试
- 边界条件测试（空输入、极值、零值等）
- 错误路径测试（期望的错误是否正确返回）

### 集成/E2E测试
- 完整流程测试：数据加载 → 策略运行 → 回测 → 输出统计
- 多品种测试
- 策略组合测试
- 性能基准测试（可选）

## 命名规范
- Rust: snake_case 函数/变量, CamelCase 类型
- 英文注释，中文文档
- 测试函数命名：`test_<模块>_<场景>`

## 适用范围
本流程适用于 QuantTrading 项目的所有新模块开发和重大重构。
小修小补（bug fix、文档更新）可以简化流程。
