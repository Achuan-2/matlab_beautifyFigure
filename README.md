# beautifyFigure

一个用于快速统一和美化 MATLAB 图形的小工具，适合将图像整理成论文/报告所需的风格：

- 统一字体与线宽（`fontSize`、`lineWidth`）
- 规范坐标轴、标题、标签、图例、颜色条等样式
- 精确按厘米控制尺寸，并按需导出多种格式（PDF/PNG/FIG/SVG）

适合在绘图完成后对图像做一次“一键收尾”，保证风格一致。

## 文件

- `beautifyFigure.m`：主函数，负责美化、尺寸调整和导出。
- `setAxesSize.m`：辅助函数，用于把坐标轴区域设置为精确尺寸（如果需要更细的控制）。

## 快速示例

```matlab
% 画图
plot(rand(10,1));

% 1) 默认美化当前图形
beautifyFigure()

% 2) 设置字体 8pt、线宽 1.5pt
beautifyFigure(fontSize=8, lineWidth=1.5)

% 3) 将主坐标轴区域设置为 7x5 cm，并导出 PDF/PNG（透明背景，300 dpi）
beautifyFigure(figSize=[7,5], sizeObject="axes", filename="myfig", exportFormats=["pdf","png"])
```

## 参数说明（常用）

- `hFig`：图形句柄，默认 `gcf`（当前图形）。
- `filename`：导出文件名（不含扩展名）。为空则不导出。
- `figSize`：目标尺寸 `[宽, 高]`（单位：厘米）。设为 `[0,0]` 则不修改尺寸。
- `sizeObject`：`"axes"`（把 `figSize` 应用于主坐标轴区域）或 `"figure"`（把 `figSize` 应用于整个图形窗口），默认 `"axes"`。
  - 作用：MATLAB 默认导出figure大小是按照整个figure大小进行的，论文排版的时候一般是axes统一会更加美观。在某些情况下，比如论文要统一加legend和没有加legend的图形的宽度，由于legend放在图外的时候也会占用空间，就算指定figure大小，但实际axes的内容宽度是不一样的。使用 `sizeObject="axes"` 可以保证导出后图形内容区域大小一致。
- `exportFormats`：要导出的格式列表，支持 `"pdf"`、`"fig"`、`"png"`、`"svg"`（默认 `["pdf","fig","png"]`）。
- `fontSize`：统一字体大小（单位：pt），默认 `6`，作用于轴刻度、标签、标题、图例、颜色条、文本和注释。
- `lineWidth`：统一线宽（单位：pt），默认 `1`，作用于轴框线、折线、散点边框、面积、柱状、盒须图、颜色条等对象。

- `firstTickRatio`：控制 Y 轴第一个刻度（最底部刻度）与 Y 轴下边界（即 X 轴所在视觉位置）之间的“视觉距离”。
  - 默认：`0.1`（即第一个刻度距离底部约为高度的 10%）。
  - 取值范围：`[0, 0.5)`。如果设置为 `0` 则不做调整（保留原有 YLim）。
  - 作用：当需要在底部留白以便显示出特别低的数据时，`firstTickRatio` 会调整 `YLim`，使第一个刻度在图区中处于指定的相对高度。




## 常见用法示例

```matlab
% 美化并保持当前尺寸
beautifyFigure(fontSize=7, lineWidth=1)

% 精确设置主坐标轴为 7x5 cm
beautifyFigure(figSize=[7,5], sizeObject="axes")

% 设置整个图形为 10x8 cm 并导出 PDF
beautifyFigure(figSize=[10,8], sizeObject="figure", filename="paper-fig")

% 指定目标图形句柄
f = figure; plot(rand(10,1));
beautifyFigure(hFig=f, fontSize=8, lineWidth=1.5)
```


## 许可

本仓库文件供科研与教学参考与使用。欢迎在论文或项目中引用本工具并在致谢中提及。
