function [fig, ax] = setAxesSize(targetSize, fig, ax)
    %SETAXESSIZE 调整图形窗口大小以精确匹配坐标区的目标尺寸。
    %
    % 语法:
    %   setAxesSize(targetSize)
    %   setAxesSize(targetSize, figHandle)
    %   setAxesSize(targetSize, figHandle, axHandle)
    %   [fig, ax] = setAxesSize(...)
    %
    % 描述:
    %   此函数重新调整图形窗口（Figure）的大小，使其主坐标区（Axes）的宽度和
    %   高度精确地等于 targetSize（单位：厘米）。函数会自动计算并调整图形窗口
    %   的尺寸，以保持坐标区周围的边距（用于标题、标签、图例等）不变。
    %
    % 输入参数:
    %   targetSize - 一个 1x2 的向量 [宽度, 高度]，指定坐标区的目标尺寸（单位：厘米）。
    %   fig        - (可选) 要修改的图形句柄。如果未提供，则默认为当前图形 (gcf)。
    %   ax         - (可选) 要修改的坐标区句柄。如果未提供，则默认为指定图形的当前坐标区 (gca)。
    %
    % 输出参数:
    %   fig        - 修改后的图形句柄。
    %   ax         - 修改后的坐标区句柄。
    %
    
    % --- 1. 处理输入参数 ---
    if nargin < 1
        error('必须提供目标尺寸 [宽度, 高度]。');
    end
    if nargin < 2 || isempty(fig)
        fig = gcf; % 如果未提供图形句柄，则获取当前图形
    end
    if nargin < 3 || isempty(ax)
        ax = gca(fig); % 如果未提供坐标区句柄，则获取当前坐标区
    end
    
    % --- 2. 核心逻辑 ---
    
    % 保存原始单位以便后续恢复
    originalFigUnits = fig.Units;
    originalAxUnits = ax.Units;
    
    % 将单位设置为厘米，以便进行精确计算
    fig.Units = 'centimeters';
    ax.Units = 'centimeters';
    
    % 获取当前坐标区的位置和尺寸 [left, bottom, width, height]
    currentAxPos = ax.Position;
    currentAxSize = currentAxPos(3:4);
    
    % 计算期望尺寸与当前尺寸的差异
    sizeDiff = targetSize - currentAxSize;
    
    % 将尺寸差异添加到整个图形窗口的尺寸上
    fig.Position(3:4) = fig.Position(3:4) + sizeDiff;
    
    % 现在图形窗口已有足够空间，将坐标区设置为目标尺寸
    ax.Position(3:4) = targetSize;
    
    % 恢复原始单位，避免影响后续操作
    fig.Units = originalFigUnits;
    ax.Units = originalAxUnits;
    
end
