# beautifyFigure

一个用于统一、美化 MATLAB 图形以适配论文/报告导出的轻量工具。专注于：
- 统一字体与线宽（fontSize、lineWidth）
- 规范坐标轴/标题/标签/图例/颜色条样式
- 精确控制尺寸（以厘米为单位），并按需导出多种格式

适合批量或收尾阶段对图像做一致化处理。

## 文件
- `beautifyFigure.m` 主要功能入口（美化、尺寸、导出）
- `setAxesSize.m` 辅助函数（将坐标轴区域精确设置为目标尺寸）


## 快速开始
```matlab
% 绘图...
plot(rand(10,1));

% 一键美化当前图形
beautifyFigure()

% 统一字体 8pt、线宽 1.5
beautifyFigure(fontSize=8, lineWidth=1.5)

% 设置坐标轴区域尺寸为 7x5 cm 并导出 PDF/PNG（透明背景，300dpi）
beautifyFigure(figSize=[7,5], sizeObject="axes", filename="myfig", exportFormats=["pdf","png"])
```

## 参数说明
- `hFig` 图形句柄，默认 `gcf`
- `filename` 导出文件名（不含扩展名）。若留空则不导出
- `figSize` 图形/坐标轴尺寸 `[宽, 高]`（单位：厘米）。设为 `[0,0]` 则不修改尺寸
- `sizeObject` `"axes" | "figure"`，控制 `figSize` 作用于坐标轴区域或整个图形窗口（默认 `"axes"`）
- `exportFormats` 要导出的格式，任意组合于 `["pdf","fig","png","svg"]`（默认 `["pdf","fig","png"]`）
- `fontSize` 统一字体大小，单位 pt（默认 `6`）。应用到：
  - 坐标轴刻度、X/Y/Z 标签、标题
  - 图例、颜色条
  - Text/Annotation（包括 textbox/textarrow）
- `lineWidth` 统一线宽，单位 pt（默认 `1`）。应用到：
  - 坐标轴边框/刻度线宽（axes.LineWidth）
  - 折线（Line）、散点边框（Scatter）、区域（Area）、柱状（Bar）、盒须（BoxChart）
  - 颜色条（Colorbar）

## 行为与默认风格
- 单位统一切换为厘米进行尺寸计算
- 图形背景为白色（`Color='w'`）
- 默认字体：Arial；可在外部自行更改或绘图前设定
- 为便于新创建对象继承，设置了 figure 级的默认字体与线宽（`defaultTextFontSize`、`defaultAxesFontSize`、`defaultLineLineWidth`、`defaultAxesLineWidth`）

## 尺寸控制说明（figSize + sizeObject）
- `sizeObject="axes"`：精确将主坐标轴的宽高设置为 `figSize`（厘米），会相应调整整个图形窗口尺寸以匹配
- `sizeObject="figure"`：直接将图形窗口的宽高设置为 `figSize`（厘米）
- `figSize=[0,0]`：跳过尺寸修改

## 导出
- PDF：矢量导出、透明背景、300dpi（便于插入文档）
- PNG：300dpi 光栅导出
- FIG/SVG：按需选择

示例：
```matlab
beautifyFigure(filename="figure1", exportFormats=["pdf","png","svg"])
```

## 已覆盖的常见对象
- axes、title、xlabel/ylabel/zlabel
- line、scatter、area、bar、boxchart
- legend、colorbar
- text、annotation（包含部分常见类型：textbox、textarrow）

> 注：若你使用了更特殊的图形对象，可能需要在 `beautifyFigure.m` 中按相同模式扩展处理。

## 常见用法示例
```matlab
% 1) 美化并保持当前尺寸
beautifyFigure(fontSize=7, lineWidth=1)

% 2) 精确控制坐标轴区域尺寸（7x5 cm）
beautifyFigure(figSize=[7,5], sizeObject="axes")

% 3) 控制整个图形窗口尺寸（10x8 cm）并导出 PDF
beautifyFigure(figSize=[10,8], sizeObject="figure", filename="paper-fig")

% 4) 指定目标图形句柄
f = figure; plot(rand(10,1));
beautifyFigure(hFig=f, fontSize=8, lineWidth=1.5)
```

## 兼容性与注意事项
- 建议在绘图完成后调用，以避免后续绘图覆盖样式
- 若某些对象在外部手动设置过样式，`beautifyFigure` 会按统一规则覆盖（可在调用后再做个别微调）

## 许可
本仓库文件供科研/教学自由使用。若用于论文或开源项目，欢迎在致谢中提及。
