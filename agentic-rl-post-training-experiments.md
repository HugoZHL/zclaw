# Agentic RL 后训练方法实验计划

> 场景：超大规模基座模型后训练，提升通用能力
> 评估哲学：The Bitter Lesson — 优先选择能 scale with compute 的通用方法

---

## 一、主力方法（已确定）

### 1. 纯 On-Policy RL（GRPO/DAPO + Outcome Reward）

**Bitter Lesson 评分：⭐⭐⭐⭐⭐**

- **核心思路**：只给 outcome reward（答案对/错），让模型通过大量 rollout 自主探索推理路径
- **为什么是主力**：DeepSeek-R1 验证 — 纯 RL 在超大模型上涌现出 aha-moment、自我反思、长链推理，无需 SFT 预热或人类知识注入
- **关键配置**：
  - 算法：GRPO（Group Relative Policy Optimization）或 DAPO（Dynamic Advantage Policy Optimization）
  - Reward：verifiable outcome reward（数学答案校验、代码测试用例、单元测试通过率）
  - Rollout：每个问题 8-32 个 rollout，生成长度 8K-32K tokens
  - 数据：数学（AIME/MATH/GSM8K）、代码（LiveCodeBench/APPS）、推理（LogiQA/ARC）
- **参考实现**：[veRL](https://github.com/volcengine/verl)、[OpenRLHF](https://github.com/OpenRLHF/OpenRLHF)
- **参考论文**：
  - DeepSeek-R1: [arXiv:2501.12948](https://arxiv.org/abs/2501.12948)
  - DAPO: [arXiv:2503.14476](https://arxiv.org/abs/2503.14476)
  - GRPO (DeepSeek-Math): [arXiv:2402.03300](https://arxiv.org/abs/2402.03300)

### 2. OPD（On-Policy Distillation）— 有 teacher 时使用

**Bitter Lesson 评分：⭐⭐⭐⭐**

- **核心思路**：Student 做 on-policy rollout → Teacher 计算 token-level logprob → 作为 dense reward → Policy gradient 更新 student
- **本质**：learning from a stronger policy，RL 的变体，不注入 domain knowledge
- **适用条件**：存在比当前模型更强的 teacher 模型（如训练 72B 时用 235B-MoE 做 teacher）
- **关键优势**：每个问题只需 1 个 rollout（vs GRPO 的 8-32），dense token-level signal 收敛快
- **关键限制**：训练最大规模模型时可能没有 teacher 可用，此时退化回纯 RL
- **参考实现**：[Tinker Cookbook](https://github.com/Thinking-Machines-RL/tinker-cookbook)（TML 框架），核心算法可在 veRL/OpenRLHF 上自行实现
- **参考资料**：
  - TML Blog: https://thinkingmachines.ai/blog/on-policy-distillation/
  - Qwen3 技术报告中引用了类似方法

---

## 二、实验候选方法（选 1-2 个验证）

> 以下方法在 Bitter Lesson 框架下不是主力，但可能在特定场景下带来实际收益，值得做对照实验。
> 推荐优先级：POPE > OPSD > InT

### 推荐实验 A：POPE（Privileged On-Policy Exploration）

**推荐理由：最值得验证，工程改动最小，解决纯 RL 的核心痛点**

**Bitter Lesson 评分：⭐⭐⭐**（search augmentation，不完全是 human knowledge injection）

#### 解决什么问题
纯 RL 在难题上 pass@k ≈ 0 → 完全没有学习信号 → 难题永远学不会。这是纯 RL 的真实瓶颈。Bitter Lesson 说"算力能解决一切"，但如果 reward signal 为零，再多算力也是零乘以无穷。POPE 解决的是让 search 有起点，而不是教模型怎么 search。

#### 核心机制
1. 评估哪些问题是"难题"（on-policy rollout 后 pass@k = 0 的问题）
2. 对难题，将 oracle solution 的前 N 步作为 rollout 的 prefix（起始点）
3. 模型从中间步骤开始 on-policy 探索
4. 训练时 prefix 不计入 loss，只训练模型自主生成的部分
5. 关键发现：在 guided rollout 上学到的能力可以 transfer 回 unguided 的原始问题

#### 实验设计
```
实验组 A1: 纯 RL baseline（GRPO，全量数据，含难题）
实验组 A2: POPE（简单题用标准 rollout，难题用 prefix-guided rollout）
评估指标: 
  - 总体 pass@1 / pass@8 提升
  - 难题（baseline pass@128=0）的攻克率
  - 训练效率（达到同等 pass@1 需要的 rollout 数量）
数据集: AIME 2024/2025, MATH Level 5, LiveCodeBench Hard
```

#### 实现要点
- 实现简单：只需在 rollout 阶段加 prefix prepend 逻辑，loss mask 跳过 prefix 部分
- 需要 oracle solution：数学题用 ground-truth 答案构造 step-by-step prefix，代码题用 reference solution
- Prefix 长度选择：论文用 oracle solution 的 25%/50%/75% 作为 prefix，建议从 50% 开始
- 与标准 RL infra 完全兼容，不需要额外模型部署

#### Scaling 分析
- 论文实验：Qwen3-4B，但方法与模型规模完全解耦
- 超大模型的 instruction-following 更强 → prefix transfer 效果应更好
- 零额外算力开销（prefix 是静态文本，不需要推理）
- **潜在 Bitter Lesson 反驳**：随着模型变大 + rollout 变多，pass@k=0 的问题会自然减少，POPE 的边际收益递减。实验可以验证这个假设。

#### 参考论文
- POPE: [arXiv:2601.18779](https://arxiv.org/abs/2601.18779)

---

### 推荐实验 B：OPSD（On-Policy Self-Distillation）

**推荐理由：不需要外部 teacher，算力效率极高，适合验证 self-play 在超大模型上的效果**

**Bitter Lesson 评分：⭐⭐⭐**（self-play 变体，介于 learning 和 knowledge injection 之间）

#### 解决什么问题
OPD 需要外部 teacher，训练最大模型时没有 teacher 怎么办？OPSD 让模型自己当自己的 teacher：给它看标准答案后的条件分布 vs 不看答案的原始分布，差异就是 dense training signal。

#### 核心机制
1. Student：给模型问题，让它 on-policy 生成（不看答案）
2. Teacher：同一个模型，给它问题 + 标准答案，计算 token-level logprob
3. 训练目标：最小化 student 和 teacher 条件分布之间的 reverse KL
4. 核心假设："理解答案比生成答案容易" → teacher 条件分布天然更准确

#### 实验设计
```
实验组 B1: 纯 RL baseline（GRPO，8 rollouts/问题）
实验组 B2: OPSD（1 rollout/问题 + self-distillation）
实验组 B3: OPSD → RL（先 OPSD 训练 N 步，再接 GRPO）
评估指标:
  - 相同 token 消耗下的 pass@1 对比
  - 训练吞吐量（tokens/second）对比
  - 泛化性：在训练集外的 benchmark 上的表现
数据集: AIME, MATH, HMMT, GSM8K（覆盖不同难度）
```

#### 实现要点
- 代码已开源：[github.com/siyan-zhao/OPSD](https://github.com/siyan-zhao/OPSD)，基于 HuggingFace TRL
- 需要 ground-truth 答案（数学/代码天然适合）
- 每个问题只需 1 个 rollout + 2 次 forward pass（student + teacher conditioning）
- 支持 LoRA fine-tuning，对超大模型内存友好
- Vocab-level distillation 内存大 → 可用 sampled-token 变体，性能损失约 2%

#### Scaling 分析
- 论文实验：Qwen3-1.7B/4B/8B，1.7B 效果 marginal，4B+ 效果好
- **关键不确定性**：超大模型 pass@1 已经很高时，student 和 teacher 分布差异可能很小，self-distillation 信号减弱 → 实验可以验证
- 理论上无 scaling barrier（同一模型的两次 forward pass）
- 算力效率是所有方法中最高的（比 GRPO 省 4-8x rollout 开销）

#### Scaling 验证实验（附加）
```
在不同规模模型上对比 OPSD 收益：
  - 小模型（~8B）: 预期收益大（论文已验证）
  - 中模型（~32B）: 预期收益中等
  - 大模型（~72B+）: 关键验证点 — self-distillation 信号是否足够？
如果大模型上收益递减，说明 Bitter Lesson 正确 — 大模型不需要这种 trick。
如果大模型上仍有显著收益，说明 verification → generation 的 gap 是模型规模无关的。
```

#### 参考资料
- OPSD Blog: https://siyan-zhao.github.io/blog/2026/opsd/
- Code: https://github.com/siyan-zhao/OPSD

---

## 三、不做的方法（及原因）

| 方法 | 不做的原因 |
|------|-----------|
| **InT** | 过于 human-knowledge-heavy（定义错误步骤、设计修正机制）。只在 4B 上验证，工程复杂度高。Bitter Lesson 视角下属于 "building in how we think we think" |
| **SDPO** | 专注多轮社交对话（SOTOPIA benchmark），与通用推理能力提升场景不匹配 |
| **DigiRL** | 专注 device-control agent（1.3B VLM + Android 模拟器），完全不适用 |
| **Digi-Q** | 同 DigiRL，场景完全不匹配 |

---

## 四、实验优先级与时间线

```
Phase 0: 搭建 RL infra（veRL/OpenRLHF），跑通 GRPO baseline
         ↓
Phase 1: 纯 RL baseline 实验
         同时启动 POPE 实验（改动小，可并行）
         ↓
Phase 2: 对比 POPE vs baseline 在难题上的差异
         同时启动 OPSD 探索性实验（验证大模型上 self-distillation 信号）
         ↓
Phase 3: 根据 Phase 1-2 结果决定后续方向：
         - 如果 POPE 有效 → 纳入主 pipeline
         - 如果 OPSD 在大模型上有效 → 可替代/补充 OPD
         - 如果都无显著收益 → 验证了 Bitter Lesson，全力投入纯 RL + reward 质量
```

---

## 五、核心哲学（指导原则）

> **The Bitter Lesson (Rich Sutton, 2019):**
> "The biggest lesson that can be read from 70 years of AI research is that general methods that leverage computation are ultimately the most effective, and by a large margin."

应用到后训练：
1. **优先选择能 scale with compute 的方法** — 纯 RL 最符合，算力翻倍 = 性能提升
2. **避免注入人类知识的精巧设计** — 这些方法短期有效但长期 plateau
3. **Search + Learning = 两大支柱** — RL rollout 是 search，gradient update 是 learning
4. **Reward 质量 > 训练技巧** — 把工程精力放在构建更好的 reward signal 上，而不是设计更复杂的训练算法
5. **实验验证 > 理论推演** — POPE 和 OPSD 是否在超大模型上仍有收益，靠实验说话

---

## 六、关键参考文献

| 文献 | 链接 | 要点 |
|------|------|------|
| The Bitter Lesson | http://www.incompleteideas.net/IncIdeas/BitterLesson.html | 通用方法 + 计算 >> 精巧设计 |
| Scaling Laws (Kaplan 2020) | [arXiv:2001.08361](https://arxiv.org/abs/2001.08361) | 模型/数据/算力的幂律关系 |
| Chinchilla (Hoffmann 2022) | [arXiv:2203.15556](https://arxiv.org/abs/2203.15556) | Compute-optimal training |
| DeepSeek-R1 | [arXiv:2501.12948](https://arxiv.org/abs/2501.12948) | 纯 RL 涌现推理能力 |
| Test-Time Compute Scaling | [arXiv:2408.03314](https://arxiv.org/abs/2408.03314) | Inference-time scaling |
| DeepSeek-GRM | [arXiv:2504.02495](https://arxiv.org/abs/2504.02495) | Generalist reward model + inference-time scaling |
| OPD | [TML Blog](https://thinkingmachines.ai/blog/on-policy-distillation/) | On-policy distillation from teacher |
| OPSD | [Blog](https://siyan-zhao.github.io/blog/2026/opsd/) / [Code](https://github.com/siyan-zhao/OPSD) | Self-distillation without teacher |
| POPE | [arXiv:2601.18779](https://arxiv.org/abs/2601.18779) | Prefix-guided exploration for hard problems |
| InT | [arXiv:2601.14209](https://arxiv.org/abs/2601.14209) | Intervention training (不推荐) |
| 原始分析文章 | 青稞AI 公众号 (Hao Bai) | Agentic RL 宏观动力学分析 |
