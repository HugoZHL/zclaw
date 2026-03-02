# 小红书帖子获取报告

## 目标帖子
- **URL**: https://www.xiaohongshu.com/discovery/item/69a143f7000000001a02e309
- **Feed ID**: `69a143f7000000001a02e309`
- **日期**: 2026-03-01

## 获取结果：❌ 失败

### 原因
小红书的反爬机制要求 **xsec_token**（会话绑定的安全令牌）才能访问帖子详情页。当前环境**未登录小红书账号**，所有访问方式均被拦截：

1. **xiaohongshu-skill 脚本** → `noteDetailMap 未就绪`，无法获取数据
2. **web_fetch 直接抓取** → 重定向到 404 页面（error_code=300031: "当前笔记暂时无法浏览"）
3. **Playwright 无头浏览器** → 同样被重定向到 404
4. **搜索引擎缓存** → DuckDuckGo/Google 均无此帖子的缓存
5. **xiaohongshu-mcp 服务** → 未运行（localhost:18060 无响应）

### 尝试的方法
| 方法 | 结果 |
|------|------|
| `python -m scripts feed <id> "" --load-comments` | No data（缺少 xsec_token） |
| `web_fetch` explore URL | 404 重定向 |
| `web_fetch` discovery URL | 404 重定向 |
| Playwright 桌面 UA | 404 重定向 |
| Playwright 移动 UA | 404 重定向 |
| Playwright 搜索页 | 搜索结果为空 |
| DuckDuckGo 搜索 | 无结果 |
| Google 缓存 | 无缓存 |

### 解决方案
要成功获取帖子内容，需要：
1. **登录小红书账号** — 运行 `python -m scripts qrcode --headless=false` 扫码登录
2. 或者 **启动 xiaohongshu-mcp 服务** 并通过已登录的会话访问
3. 登录后重新运行 `python -m scripts feed 69a143f7000000001a02e309 <xsec_token> --load-comments --max-comments=30`
