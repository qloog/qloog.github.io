---
layout: page
title: 关于
menu: About
---
{% assign current_year = site.time | date: '%Y' %}

Qloog
===
男 85后

## 概况

- 邮箱：quanlongwang#gmail.com
- 主页：[http://lnmp100.com](http://lnmp100.com)

计算机专业毕业，{{ current_year | minus: 2009 }} 年 web 开发经验。

## Keywords
<div class="btn-inline">
{% for keyword in site.skill_keywords %} <button class="btn btn-outline" type="button">{{ keyword }}</button> {% endfor %}
</div>

### 综合技能

| 名称 | 熟悉程度
|--:|:--|
| PHP | ★★★★★ |
| MySQL | ★★★★☆ |
| Linux | ★★★★☆ |
| javascript | ★★★★☆ |
| Nodejs | ★★★★☆ |
| C | ★★★☆☆ |
| Markdown | ★★★★★ |

