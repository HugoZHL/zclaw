# HEARTBEAT.md

## Ralph Loop - 任务队列检查（sub-agent 模式）

1. 读取 `TODO.md`，查看「待办任务」区域是否有 `- [ ]` 开头的任务
2. 如果有待办任务：
   - 取第一个 `- [ ]` 任务
   - 将其状态改为 `- [>]` 并移到「进行中」区域
   - **用 sessions_spawn 派 sub-agent 异步执行**，不要自己阻塞等待
   - sub-agent 完成后会自动回报，届时更新 TODO.md 并通知群里对应的人
3. 如果有 `- [>]` 进行中的任务：检查对应 sub-agent 是否已完成（用 subagents list），如已完成则更新状态
4. 通知方式：向飞书群发送完成反馈（message 工具，channel=feishu，target=chat:oc_734893e3844ad5b51156a02fd7fb5da9），@ 对应负责人（`<at user_id="open_id">名字</at>`）
5. 人员对应关系见 TODO.md 的「人员信息」部分
6. 如果没有待办任务也没有进行中任务：回复 HEARTBEAT_OK
