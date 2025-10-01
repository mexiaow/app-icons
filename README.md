# App Icons 图标库

一个用于同步和管理应用图标的项目，支持自动化同步到多个Git仓库。

## 📁 项目结构

```
app-icons/
├── app/                # 应用图标目录
│   ├── alist.png      # Alist 文件管理器图标
│   ├── clash.png      # Clash 代理工具图标
│   ├── embyserver.png # Emby 媒体服务器图标
│   └── ...            # 更多应用图标
├── bg/                 # 背景图片目录
├── app.py              # Flask Webhook 服务器
├── git-sync.bat        # Git 同步批处理脚本
├── cdn.txt             # CDN 链接配置
└── .gitignore          # Git 忽略文件配置
```

## 🚀 功能特性

### 自动同步
- **Webhook 监听**：通过 Flask 应用监听 Gitee webhook 事件
- **自动拉取**：当检测到推送事件时自动执行 `git pull`
- **密码验证**：确保只有授权的推送才会触发同步

### 手动同步
- **双仓库推送**：同时推送到 GitHub 和 Gitee
- **自动提交**：自动添加所有更改并生成时间戳提交信息
- **错误处理**：完整的错误检查和用户反馈

## 🛠️ 部署说明

### Flask Webhook 服务器

1. **配置环境**
   ```bash
   pip install flask
   ```

2. **修改配置**
   编辑 `app.py` 中的配置项：
   ```python
   WEBHOOK_SECRET = 'your_webhook_password'  # Gitee Webhook 密码
   REPO_PATH = '/path/to/your/repo'          # 本地仓库路径
   GIT_CMD = '/usr/bin/git'                  # Git 命令路径
   ```

3. **启动服务**
   ```bash
   python app.py
   ```
   服务将在 `http://0.0.0.0:8899` 启动

4. **配置 Gitee Webhook**
   - 在 Gitee 仓库设置中添加 Webhook
   - URL: `http://your-server:8899/webhook`
   - 验证方式：密码
   - 密码：与 `WEBHOOK_SECRET` 保持一致

### Windows 手动同步

1. **配置 Git 远程仓库**
   ```bash
   git remote add github https://github.com/username/app-icons.git
   git remote add gitee https://gitee.com/username/app-icons.git
   ```

2. **运行同步脚本**
   ```bash
   git-sync.bat
   ```

## 📦 图标使用

### 直接访问
```html
<img src="https://your-domain.com/app/alist.png" alt="Alist">
```

## 🔧 API 接口

### Webhook 接口
- **URL**: `/webhook`
- **方法**: `POST`
- **认证**: 密码验证
- **功能**: 接收 Gitee 推送事件并执行同步

**请求示例**：
```json
{
  "hook_name": "push_hooks",
  "password": "your_webhook_password",
  ...
}
```

**响应示例**：
```json
{
  "status": "success",
  "message": "Repository updated successfully"
}
```

## 📋 支持的应用图标

项目包含以下应用的图标：

| 应用名称 | 图标文件 | 说明 |
|---------|---------|------|
| Alist | `alist.png` | 文件管理器 |
| Clash | `clash.png` | 网络代理工具 |
| Emby | `embyserver.png` | 媒体服务器 |
| Nextcloud | `nextcloud.png` | 私有云存储 |
| qBittorrent | `qbittorrent.png` | BT下载工具 |
| Portainer | `portainer.png` | Docker管理工具 |
| ... | ... | 更多图标持续添加中 |

## 🔒 安全注意事项

1. **密码保护**：确保 Webhook 密码足够复杂
2. **网络安全**：建议使用 HTTPS 和防火墙保护
3. **权限控制**：确保 Git 仓库路径权限正确
4. **日志监控**：定期检查应用日志

## 🤝 贡献指南

1. Fork 本仓库
2. 创建功能分支: `git checkout -b feature/new-icons`
3. 添加新的图标文件到 `app/` 目录
4. 提交更改: `git commit -m 'Add new app icons'`
5. 推送分支: `git push origin feature/new-icons`
6. 创建 Pull Request

## 📝 更新日志

- **2024-09**: 添加自动同步功能
- **2024-08**: 新增多个应用图标
- **2024-07**: 项目初始化，基础图标库建立

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 🆘 常见问题

**Q: Webhook 不工作怎么办？**
A: 检查密码配置、网络连接和日志输出

**Q: 如何添加新的图标？**
A: 将 PNG 格式的图标文件放入 `app/` 目录并推送到仓库

**Q: 支持哪些图片格式？**
A: 主要支持 PNG 格式，建议分辨率为 256x256 或更高

---

💡 **提示**: 如有问题或建议，欢迎提交 Issue 或 Pull Request！