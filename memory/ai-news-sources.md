# 大模型/AI 行业高质量信息源

> 整理时间：2026-03-01 | 经过实际访问验证

---

## 一、中文源

### 1. 机器之心 (Synced)
- **URL**: https://www.jiqizhixin.com
- **更新频率**: 每日多篇（工作日 5-10 篇）
- **内容特点**: 中国最权威的 AI 媒体之一，覆盖论文解读、行业分析、产品评测。内容质量高，有原创深度文章和会员通讯。部分内容需订阅会员。
- **RSS**: ❌ 官方 RSS 不可用（重定向循环）；可尝试 RSSHub 路由 `rsshub.app/jiqizhixin`（需自建 RSSHub 实例，公共实例被 Cloudflare 拦截）
- **免费**: 部分免费，深度文章需会员
- **自动抓取**: 需自建爬虫或通过微信公众号获取

### 2. 量子位 (QbitAI)
- **URL**: https://www.qbitai.com
- **更新频率**: 每日多篇（5-8 篇）
- **内容特点**: 聚焦国内 AI 创业和应用，报道速度快，文风活泼。涵盖大模型、AI 应用、融资动态。部分内容偏新闻向，少数深度稿。
- **RSS**: ❌ 官方 RSS 403；RSSHub 路由也被拦截
- **免费**: ✅ 免费
- **自动抓取**: 主要通过微信公众号「量子位」，网站爬虫较困难（403 防护）

### 3. 新智元 (AI Era)
- **URL**: https://mp.weixin.qq.com/s?__biz=MzI3MTA0MTk1MA== （主要活跃在微信公众号）
- **更新频率**: 每日 1-3 篇
- **内容特点**: 偏全球 AI 大事件报道，标题党倾向较强。适合快速了解行业动态，但深度分析不如机器之心。
- **RSS**: ❌ 无官方 RSS，网站域名已无法解析
- **免费**: ✅ 免费（微信公众号）
- **自动抓取**: 只能通过微信公众号抓取（WeChat RSS 方案如 feeddd.org）

### 4. 36氪 AI 频道
- **URL**: https://36kr.com/information/AI/
- **更新频率**: 每日多篇（3-8 篇）
- **内容特点**: 综合科技媒体的 AI 频道，侧重产业报道、公司动态、融资消息。内容偏商业化视角，适合了解 AI 行业商业动态。
- **RSS**: ⚠️ 可通过 RSSHub `rsshub.app/36kr/information/AI`（公共实例被 Cloudflare 拦截，需自建）
- **免费**: ✅ 免费
- **自动抓取**: 网站可访问，自建 RSSHub 可行

### 5. InfoQ AI 频道
- **URL**: https://www.infoq.cn/topic/AI
- **更新频率**: 每日 2-5 篇
- **内容特点**: 面向开发者的技术媒体，AI 内容偏技术实践，包括架构设计、工程落地、技术选型。质量较高，适合技术人员。
- **RSS**: ⚠️ 需通过 RSSHub 路由
- **免费**: ✅ 免费
- **自动抓取**: 网站 SPA 渲染，直接爬取较困难

### 6. 雷峰网 / AI科技评论
- **URL**: https://www.leiphone.com/category/ai
- **更新频率**: 每日 2-5 篇
- **内容特点**: 专注 AI 学术和产业报道，有论文解读和学者专访。「AI 科技评论」是其子栏目，质量中上。
- **RSS**: ❌ 无官方 RSS
- **免费**: ✅ 免费
- **自动抓取**: 网站可访问但需处理反爬

---

## 二、英文源

### 1. The Batch (Andrew Ng / DeepLearning.AI)
- **URL**: https://www.deeplearning.ai/the-batch/
- **更新频率**: 每周一期（周四发布）
- **内容特点**: Andrew Ng 亲自把关的周刊，每期 5-6 篇精选 AI 新闻 + 个人观点。内容精炼、视角独到，适合非研究者的 AI 从业者。吴恩达的个人信和评论是核心价值。
- **RSS**: ⚠️ 无官方 RSS，但可通过 email 订阅
- **免费**: ✅ 免费
- **自动抓取**: 可爬取网页归档

### 2. Import AI (Jack Clark)
- **URL**: https://importai.substack.com
- **更新频率**: 每周一期（周一发布）
- **内容特点**: Anthropic 联合创始人 Jack Clark 的深度周刊，112,000+ 订阅者。聚焦 AI 前沿研究和政策影响，分析深入，是 AI 安全/政策领域必读。每期精选 5-7 篇论文或事件做深度点评。
- **RSS**: ✅ `https://importai.substack.com/feed`
- **免费**: ✅ 免费
- **自动抓取**: ✅ Substack RSS 完美支持

### 3. Hacker News
- **URL**: https://news.ycombinator.com
- **更新频率**: 实时更新，AI 内容每日大量
- **内容特点**: 技术社区的风向标，AI 话题是目前最热门类别。评论区价值极高（比文章本身更有价值）。需要自行过滤 AI 相关内容。
- **RSS**: ✅ `https://hnrss.org/frontpage` (第三方，非常稳定)
- **免费**: ✅ 免费
- **自动抓取**: ✅ HN API (`https://hacker-news.firebaseio.com/v0/`) + hnrss.org；可用关键词过滤 `hnrss.org/newest?q=LLM+OR+AI+OR+GPT`
- **特别推荐**: 搜索 AI 话题可用 `https://hn.algolia.com/?q=LLM`

### 4. Hugging Face Daily Papers
- **URL**: https://huggingface.co/papers
- **更新频率**: 每日更新（工作日）
- **内容特点**: 由 AK (@_akhaliq) 和社区策展的每日论文精选，直接展示 ArXiv 最新热门论文。质量极高，是追踪前沿研究的最佳入口。社区投票机制确保精品。
- **RSS**: ⚠️ 无原生 RSS，可订阅 email 通知；也可通过 HF API 获取
- **免费**: ✅ 免费
- **自动抓取**: ✅ Hugging Face API `https://huggingface.co/api/daily_papers`

### 5. The Gradient
- **URL**: https://thegradient.pub
- **更新频率**: 每月 2-4 篇
- **内容特点**: 高质量的 AI 长文分析刊物，文章常达数千字，涵盖技术深度分析和行业思考。不追热点，适合深度阅读。由斯坦福学生/校友运营。
- **RSS**: ✅ `https://thegradient.pub/rss/` (Ghost 平台)
- **免费**: ✅ 免费
- **自动抓取**: ✅ RSS 完美支持

### 6. Ahead of AI (Sebastian Raschka)
- **URL**: https://magazine.sebastianraschka.com
- **更新频率**: 每月 2-4 篇
- **内容特点**: 169,000+ 订阅者。机器学习教育家 Sebastian Raschka 的深度技术博客。专注 LLM 技术解析、训练方法、架构对比。内容极其硬核，代码丰富，是技术从业者必读。
- **RSS**: ✅ `https://magazine.sebastianraschka.com/feed`
- **免费**: ✅ 核心内容免费，部分深度文章付费
- **自动抓取**: ✅ Substack RSS 完美支持

### 7. Papers With Code / HF Trending
- **URL**: https://paperswithcode.com → 现已合并至 https://huggingface.co/papers/trending
- **更新频率**: 实时
- **内容特点**: 追踪最热门的 AI 论文及其开源实现代码。从 SOTA benchmark 排行到论文代码复现一站式获取。
- **RSS**: ⚠️ 通过 HF API 获取
- **免费**: ✅ 免费
- **自动抓取**: ✅ API 支持

---

## 三、Newsletter（精品邮件通讯）

### 1. Alpha Signal
- **URL**: https://alphasignal.ai
- **更新频率**: 每日
- **内容特点**: 250,000+ 订阅者。每日 5 分钟摘要，覆盖最新突破性新闻、模型、论文和开源项目。简洁高效，适合快速扫描。
- **RSS**: ❌ 邮件订阅
- **免费**: ✅ 免费
- **自动抓取**: 需邮件转 RSS 方案

### 2. The AiEdge Newsletter (Damien Benveniste)
- **URL**: https://newsletter.theaiedge.io
- **更新频率**: 每周
- **内容特点**: 82,000+ 订阅者。聚焦 ML 应用、ML 系统设计、MLOps。偏工程实践，适合 ML 工程师。订阅送免费 ML 电子书。
- **RSS**: ✅ Substack feed 支持
- **免费**: ✅ 免费
- **自动抓取**: ✅ Substack RSS

### 3. NLP News (Sebastian Ruder)
- **URL**: https://newsletter.ruder.io
- **更新频率**: 每月 1-2 篇
- **内容特点**: 29,000+ 订阅者。Google DeepMind 研究科学家的 NLP 深度分析。每期回顾 NLP/LLM 领域重要进展，学术性强，视角权威。
- **RSS**: ✅ Substack feed 支持
- **免费**: ✅ 免费
- **自动抓取**: ✅ Substack RSS

### 4. Ben's Bites
- **URL**: https://bensbites.beehiiv.com
- **更新频率**: 每日
- **内容特点**: 120,000+ 订阅者。偏 AI 产品/创业/应用方向，内容轻量化，适合非技术背景的 AI 关注者。近期方向转向「用 AI 建 App」的教学。
- **RSS**: ⚠️ Beehiiv 平台有 RSS 支持
- **免费**: ✅ 免费
- **自动抓取**: ⚠️ 需确认 RSS endpoint

### 5. AI News by Swyx (smol.ai)
- **URL**: https://news.smol.ai（从 buttondown.com/ainews 迁移）
- **更新频率**: 每日
- **内容特点**: AI 聚合器，自动监控 9 个 subreddit、449 个 Twitter 账号和 29 个 Discord。原始信息量极大，适合想全面覆盖的人。
- **RSS**: ✅ 支持
- **免费**: ✅ 免费
- **自动抓取**: ✅ RSS 支持

### 6. Simon Willison's Weblog
- **URL**: https://simonwillison.net
- **更新频率**: 几乎每日
- **内容特点**: Django 联合创始人的博客，现已成为 AI/LLM 实践领域最有影响力的独立博客之一。以实际动手体验为主，评测新模型、工具，分享 prompt 技巧。极其务实。
- **RSS**: ✅ `https://simonwillison.net/atom/everything/`
- **免费**: ✅ 免费
- **自动抓取**: ✅ Atom feed 完美支持

---

## 四、社交媒体

### Twitter/X 关键账号

| 账号 | 关注点 | 粉丝级别 |
|------|--------|---------|
| **@kaborasmus** (Andrej Karpathy) | 前 OpenAI/Tesla，LLM 教学，深度技术洞察 | 顶级 |
| **@AndrewYNg** (Andrew Ng) | AI 教育、行业观察、DeepLearning.AI | 顶级 |
| **@ylecun** (Yann LeCun) | Meta AI 首席科学家，经常参与 AI 辩论 | 顶级 |
| **@sama** (Sam Altman) | OpenAI CEO，产品发布和行业风向 | 顶级 |
| **@demaborosh** (Demis Hassabis) | DeepMind CEO，前沿研究方向 | 顶级 |
| **@jimfan** (Jim Fan) | NVIDIA 高级研究科学家，具身智能/基础模型 | 高 |
| **@_akhaliq** (AK) | AI 论文速递的活字典，HF Daily Papers 策展人 | 高 |
| **@swaboroshi** (Swyx) | AI 工程方向，smol.ai 创始人 | 高 |
| **@simonw** (Simon Willison) | AI 工程实践、工具评测 | 高 |
| **@emaborosworth** (Elvis) | LLM 开源社区核心，Nous Research | 高 |
| **@bindureddy** (Bindu Reddy) | Abacus.AI CEO，LLM 应用 | 中高 |
| **@rasbt** (Sebastian Raschka) | ML 教育、LLM 技术深度 | 高 |
| **@ClementDelangue** (Clement Delangue) | Hugging Face CEO，开源 AI 生态 | 高 |

### Reddit 社区

#### r/MachineLearning
- **URL**: https://www.reddit.com/r/MachineLearning/
- **更新频率**: 实时，极活跃
- **内容特点**: 最大的 ML 学术社区，以论文讨论为主（[R] 标签）。有严格的内容质量控制。每周有「Simple Questions」帖。
- **RSS**: ✅ `https://www.reddit.com/r/MachineLearning/.rss`
- **免费**: ✅ 免费
- **自动抓取**: ✅ RSS + Reddit API

#### r/LocalLLaMA
- **URL**: https://www.reddit.com/r/LocalLLaMA/
- **更新频率**: 实时，极活跃
- **内容特点**: 本地部署 LLM 的核心社区，覆盖开源模型评测、量化方案、推理优化、硬件推荐。是开源 LLM 生态最活跃的讨论地。
- **RSS**: ✅ `https://www.reddit.com/r/LocalLLaMA/.rss`
- **免费**: ✅ 免费
- **自动抓取**: ✅ RSS + Reddit API

---

## 五、自动抓取方案总结

### ✅ 可直接 RSS 订阅的优质源（推荐首批接入）
1. Import AI → `importai.substack.com/feed`
2. Ahead of AI → `magazine.sebastianraschka.com/feed`
3. The Gradient → `thegradient.pub/rss/`
4. Simon Willison → `simonwillison.net/atom/everything/`
5. Hacker News (AI 过滤) → `hnrss.org/newest?q=LLM+OR+transformer+OR+GPT+OR+AI+agent`
6. r/MachineLearning → `reddit.com/r/MachineLearning/.rss`
7. r/LocalLLaMA → `reddit.com/r/LocalLLaMA/.rss`
8. NLP News → `newsletter.ruder.io/feed`

### ⚠️ 需要自建 RSSHub 或爬虫的源
1. 机器之心 → 自建 RSSHub 或微信公众号抓取
2. 量子位 → 微信公众号抓取
3. 36氪 AI → 自建 RSSHub
4. InfoQ AI → 自建 RSSHub
5. Hugging Face Papers → HF API 轮询

### 📧 仅支持邮件订阅
1. The Batch (Andrew Ng) → 邮件订阅 + kill-the-newsletter 转 RSS
2. Alpha Signal → 邮件订阅
3. Ben's Bites → 邮件订阅

---

## 六、推荐阅读策略

### 每日速览（5-10 分钟）
- Alpha Signal 邮件
- Hacker News AI 过滤
- r/LocalLLaMA 热帖
- Hugging Face Daily Papers

### 每周深读（30 分钟）
- Import AI (Jack Clark)
- The Batch (Andrew Ng)
- Ahead of AI (Sebastian Raschka) 新文

### 每月精读
- The Gradient 长文
- NLP News (Sebastian Ruder)
- 机器之心深度报告

### 技术实践跟踪
- Simon Willison's Weblog（AI 工具和实践）
- r/LocalLLaMA（开源模型动态）
- InfoQ AI（工程落地）
