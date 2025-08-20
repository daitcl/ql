<h3><div align="center">青龙面板</div>

---

<div align="center">
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](https://github.com/daitcl/ql/blob/main/License)

</div>

## 功能简介

此镜像是基于官方 [whyour/qinglong:debian](https://ghcr.io/whyour/qinglong:debian) 镜像的增强版本，主要增加了对 Chrome 浏览器和 Selenium 自动化测试框架的支持。

### 🚀 新增功能

与原版镜像相比，本镜像新增以下功能：

- **🖥️ 完整的 Chrome 浏览器**: 内置 Google Chrome 浏览器，支持无头模式运行
- **🧭 ChromeDriver 支持**: 包含与 Chrome 版本匹配的 ChromeDriver，用于 Web 自动化测试
- **🐍 Selenium 库**: 预安装 Python Selenium 库，可直接编写和执行自动化脚本
- **🎭 无头浏览支持**: 配置了 Xvfb 虚拟显示服务器，支持在无显示环境中的浏览器操作
- **🔧 自动化测试环境**: 开箱即用的 Web 自动化测试环境，适合网页爬虫和自动化任务

### 📦 技术栈

- **基础镜像**: `ghcr.io/whyour/qinglong:debian`
- **浏览器**: Google Chrome Stable
- **驱动**: ChromeDriver (与 Chrome 版本自动匹配)
- **自动化框架**: Selenium for Python
- **显示虚拟化**: Xvfb (X Virtual Framebuffer)

## 🐳 镜像地址

### 原版镜像

- **官方镜像**: `ghcr.io/whyour/qinglong:debian`246
- **Docker Hub**: `whyour/qinglong:debian`
- **功能**: 支持 Python3、JavaScript、Shell、Typescript 的定时任务管理平台246

### 本增强镜像

- **GitHub Container Registry**: `ghcr.io/daitcl/qinglong-selenium:latest`
- **标签策略**: 使用基础镜像的 Digest 前12位作为标签 (如: `ghcr.io/daitcl/qinglong-selenium:a1b2c3d4e5f6`)
- **更新机制**: 自动检测基础镜像更新并重建

## 🛠️ 使用方法

### 1. 拉取镜像

bash

```
docker pull ghcr.io/daitcl/qinglong-selenium:latest
```

### 2. 运行容器

bash

```
docker run -dit \
  -v $PWD/ql/data:/ql/data \
  -p 5700:5700 \
  --name qinglong-selenium \
  --restart unless-stopped \
  ghcr.io/daitcl/qinglong-selenium:latest
```

### 3. 使用 Selenium 功能

在 QingLong 的脚本中可以直接使用 Selenium：

python

```
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

# 配置 Chrome 选项
options = Options()
options.add_argument('--headless')  # 无头模式
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

# 创建浏览器实例
driver = webdriver.Chrome(options=options)

# 访问网页
driver.get('https://example.com')

# 执行你的自动化任务
print(driver.title)

# 关闭浏览器
driver.quit()
```

## 📁 项目信息

- **仓库地址**: https://github.com/daitcl/ql
- **自动更新**: 每天自动检查基础镜像更新并重建
- **构建状态**: 通过 GitHub Actions 自动化构建和测试

## ⚙️ 环境变量

本镜像继承了原版 QingLong 的所有环境变量，并新增了以下变量：

| 变量名              | 默认值                   | 描述                        |
| :------------------ | :----------------------- | :-------------------------- |
| `CHROME_BIN`        | `/usr/bin/google-chrome` | Chrome 浏览器可执行文件路径 |
| `CHROMEDRIVER_PATH` | `/usr/bin/chromedriver`  | ChromeDriver 可执行文件路径 |
| `DISPLAY`           | `:99`                    | Xvfb 虚拟显示服务器地址     |

## 🔄 更新策略

本项目通过 GitHub Actions 实现自动更新：

1. 每天自动检查基础镜像 `whyour/qinglong:debian` 是否有更新
2. 当检测到更新时，自动重建本镜像并推送到 GHCR
3. 保持与基础镜像的安全性和功能更新同步

## 📄 许可证

本项目采用 [MIT 许可证](License)

## 微信公众号
![微信公众号](./img/gzh.jpg)

---

## 赞赏

请我一杯咖啡吧！

![赞赏码](./img/skm.jpg)

---

**Note**: 本镜像仅用于学习和测试目的，请遵守相关网站的使用条款和法律法规。