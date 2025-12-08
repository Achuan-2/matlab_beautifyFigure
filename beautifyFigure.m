function beautifyFigure(hFig,opts)
    % BEAUTIFYFIGURE 美化 MATLAB 图形以适用于论文出版。
    %
    % 用法：
    %   beautifyFigure()                                    % 自动美化当前图形。
    %   beautifyFigure(fig)                                 % 美化指定句柄的图形（位置参数）。
    %   beautifyFigure(hFig=fig)                           % 美化指定句柄的图形（命名参数）。
    %   beautifyFigure(fig, filename="foo")                % 美化并保存图形。
    %   beautifyFigure(fig, figSize=[7, 5])                % 指定尺寸。[宽, 高]
    %   beautifyFigure(fig, figSize=[0, 0])                % 不修改尺寸。
    %   beautifyFigure(sizeObject="figure", figSize=[10, 8]) % 设置整个图形尺寸。
    %   beautifyFigure(sizeObject="axes", figSize=[7, 5])    % 设置坐标轴尺寸。
    %   beautifyFigure(filename="foo", exportFormats=["pdf"]) % 只导出PDF格式。
    %   beautifyFigure(fontSize=8)                         % 统一设置字体大小为 8 pt。
    %   beautifyFigure(lineWidth=1.5)                      % 统一设置线宽为 1.5 pt。
    %
    % 参数：
    %   "hFig" - 图形句柄，默认使用当前图形。如果同时提供位置参数和命名参数 hFig，则优先使用位置参数。
    %   "filename" - 保存文件的名称（不包含扩展名），如果提供，则保存美化后的图形。
    %   "figSize" - 尺寸，格式为 [宽, 高]，单位为厘米。设置为 [0, 0] 时不修改尺寸。
    %   "sizeObject" - figSize作用的对象，"axes"表示设置坐标轴尺寸，"figure"表示设置整个图形尺寸。
    %   "exportFormats" - 导出格式，可选值为 ["pdf", "fig", "png", "svg"] 的组合，默认为 ["pdf", "fig", "png"]。
    %   "fontSize" - 字体大小（单位：pt），用于坐标轴刻度、标签、标题、图例、颜色条、文本等，默认 6。
    %   "lineWidth" - 线宽（单位：pt），用于坐标轴边框/刻度、线对象、散点边框、区域/柱状/盒须图边界、颜色条等，默认 1。
    
    arguments
        hFig = []; % 默认空，表示未设置
        opts.hFig  = []; % 默认空，表示未设置
        opts.filename string = ""; % 默认文件名为空
        opts.figSize (1, 2) double = [4, 4]; % 默认尺寸为 [4, 4] 厘米
        opts.sizeObject string {mustBeMember(opts.sizeObject, ["axes", "figure"])} = "axes"; % 默认设置坐标轴尺寸
        opts.exportFormats string = ["pdf", "fig", "png"]; % 默认导出格式
        opts.fontSize (1,1) double {mustBePositive} = 6; % 统一字体大小（pt）
        opts.lineWidth (1,1) double {mustBePositive} = 1; % 统一线宽（pt）
        opts.firstTickRatio (1,1) double {mustBeFinite, mustBeGreaterThanOrEqual(opts.firstTickRatio,0), mustBeLessThan(opts.firstTickRatio,0.5)} = 0.1; % y轴第一个刻度距离底部的比例，0 表示不处理
    end
    
    % 确定使用的图形句柄：优先使用位置参数 hFig，其次使用命名参数 opts.hFig，最后使用 gcf
    if isempty(hFig) && isempty(opts.hFig)
        hFig = gcf;
    elseif ~isempty(hFig)
        % 使用位置参数 hFig
    else
        hFig = opts.hFig;
    end
    
    % 设置图形单位为厘米
    set(hFig, 'Units', 'centimeters');
    
    % 将图形背景设置为白色
    set(hFig, 'Color', 'w');
    
    % 设置默认字体为 Arial
    set(hFig, 'defaultTextFontName', 'Arial');
    set(hFig, 'defaultAxesFontName', 'Arial');
    % 设置默认字体大小（便于新创建对象继承）
    set(hFig, 'defaultTextFontSize', opts.fontSize);
    set(hFig, 'defaultAxesFontSize', opts.fontSize);
    % 设置默认线宽（便于新创建对象继承）
    set(hFig, 'defaultLineLineWidth', opts.lineWidth);
    set(hFig, 'defaultAxesLineWidth', opts.lineWidth);
    
    % 获取图形中的所有坐标轴
    axesHandles = findall(hFig, 'Type', 'axes');
    % 调整坐标轴和图形尺寸，根据sizeObject参数决定调整目标
    if ~isempty(axesHandles) && ~isequal(opts.figSize, [0, 0])
        if opts.sizeObject == "axes"
            % 设置坐标轴尺寸（原有逻辑）
            ax = axesHandles(1);
            ax.Units = 'Centimeters';
            sizeDiff = opts.figSize - ax.Position(3:4);
            hFig.Units = 'centimeters';
            hFig.Position(3:4) = hFig.Position(3:4) + sizeDiff;
            ax.Position(3:4) = opts.figSize;
        elseif opts.sizeObject == "figure"
            % 设置整个图形尺寸
            hFig.Units = 'centimeters';
            hFig.Position(3:4) = opts.figSize;
        end
    end
    for i = 1:length(axesHandles)
        ax = axesHandles(i);
        
        % 设置刻度方向为 'out'
        set(ax, 'TickDir', 'out');
        % 设置坐标轴线宽为 opts.lineWidth，刻度标签字体大小为 opts.fontSize pt，字体为 Arial
        set(ax, 'LineWidth', opts.lineWidth);
        set(ax, 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
        
  
        
        % 设置轴标签字体大小为 opts.fontSize pt，字体为 Arial
        xlabel(ax, ax.XLabel.String, 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
        ylabel(ax, ax.YLabel.String, 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
        
        if ~isempty(ax.ZLabel.String)
            zlabel(ax, ax.ZLabel.String, 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
        end
        
        % 设置标题字体
        if ~isempty(ax.Title.String)
            title(ax, ax.Title.String, 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
        end
        
        
        % 设置线条和标记属性
        lines = findall(ax, 'Type', 'Line');
        
        for j = 1:length(lines)
            set(lines(j), 'LineWidth', opts.lineWidth, 'MarkerSize', 1);
        end
        
        % 设置散点图属性
        scatters = findall(ax, 'Type', 'Scatter');
        
        for j = 1:length(scatters)
            set(scatters(j), 'LineWidth', opts.lineWidth);
        end
        
        % 设置区域图属性
        areas = findall(ax, 'Type', 'Area');
        
        for j = 1:length(areas)
            set(areas(j), 'LineWidth', opts.lineWidth);
        end
        
        % 设置柱状图属性
        bars = findall(ax, 'Type', 'Bar');
        
        for j = 1:length(bars)
            set(bars(j), 'LineWidth', opts.lineWidth);
        end
        
        % 设置盒须图属性
        boxes = findall(ax, 'Type', 'BoxChart');
        
        for j = 1:length(boxes)
            set(boxes(j), 'LineWidth', opts.lineWidth);
        end
        
        % 关闭坐标轴边框（设置为 box off）
        set(ax, 'Box', 'off');

        % 确保Y轴刻度至少有三个点（左、中、右）
        yticks_current = get(ax, 'YTick');
        if 0 < length(yticks_current) && length(yticks_current) < 3
            % 如果当前刻度少于3个，设置为左、中、右三个点
            middle = mean(yticks_current);
            yticks_new = [yticks_current(1), middle, yticks_current(2)];
            set(ax, 'YTick', yticks_new);
        end

        % 如果用户要求，统一 y 轴第一个刻度到 x 轴的视觉距离（ratio=0 则跳过）
        if isfield(opts, 'firstTickRatio') && opts.firstTickRatio > 0
            try
                unifyFirstTickDistance(ax, opts.firstTickRatio);
            catch
                % 若因不支持的坐标轴类型或其他原因失败，忽略并继续
            end
        end
    end
    
    % 设置所有text对象的字体
    textHandles = findall(hFig, 'Type', 'text');
    
    for i = 1:length(textHandles)
        set(textHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
    end
    
    % 设置所有annotation对象的字体（包括textbox, textarrow等）
    annotationHandles = findall(hFig, 'Type', 'hggroup', '-property', 'FontName');
    
    for i = 1:length(annotationHandles)
        if isprop(annotationHandles(i), 'FontName')
            set(annotationHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
        end
    end
    
    % 查找并设置textbox annotation对象
    textboxHandles = findall(hFig, 'Type', 'textbox');
    
    for i = 1:length(textboxHandles)
        set(textboxHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
    end
    
    % 查找并设置textarrow annotation对象
    textarrowHandles = findall(hFig, 'Type', 'textarrow');
    
    for i = 1:length(textarrowHandles)
        set(textarrowHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
    end
    
    % 调整图例属性
    legendHandles = findall(hFig, 'Type', 'legend');
    
    for i = 1:length(legendHandles)
        set(legendHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial', 'EdgeColor', [0 0 0]);
    end
    
    % 调整颜色条属性
    colorbarHandles = findall(hFig, 'Type', 'colorbar');
    
    for i = 1:length(colorbarHandles)
        set(colorbarHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial', 'LineWidth', opts.lineWidth);
    end
    

    
    % 如果提供了文件名，则根据指定格式保存图形
    if opts.filename ~= ""
        % 保存为 FIG 文件
        if ismember("fig", opts.exportFormats)
            savefig(hFig, strcat(opts.filename, '.fig'));
        end
        % 保存为 SVG 文件
        if ismember("svg", opts.exportFormats)
            saveas(hFig, strcat(opts.filename, '.svg'));
        end
        % 保存为 PDF 文件
        if ismember("pdf", opts.exportFormats)
            exportgraphics(hFig, strcat(opts.filename, '.pdf'), 'ContentType', 'vector', 'BackgroundColor', 'none', 'Resolution', 300);
        end
        % 保存为 PNG 文件
        if ismember("png", opts.exportFormats)
            exportgraphics(hFig, strcat(opts.filename, '.png'), 'Resolution', 300);
        end
    end
    
end


function unifyFirstTickDistance(ax, ratio)
    % unifyFirstTickDistance 统一y轴第一个刻度距离x轴的视觉距离
    %
    % 输入：
    %   ax    - 坐标区对象（可选，默认为 gca）
    %   ratio - 第一个刻度距离底部的比例（可选，默认为 0.1，即10%）
    %
    % 示例：
    %   plot(x, y);
    %   unifyFirstTickDistance(gca, 0.15); % 第一个刻度在15%高度处
    
    arguments
        ax matlab.graphics.axis.Axes = gca
        ratio (1,1) double {mustBeFinite, mustBeGreaterThanOrEqual(ratio,0), mustBeLessThan(ratio,0.5)} = 0.1
    end
    
    % 获取当前的 y 轴刻度
    currentTicks = ax.YTick;
    
    % 如果没有刻度，直接返回
    if isempty(currentTicks)
        return;
    end
    
    % 获取第一个和最后一个刻度值
    firstTick = currentTicks(1);
    lastTick = currentTicks(end);
    
    % 计算刻度范围
    tickRange = lastTick - firstTick;
    
    % 处理边界情况：当 tickRange 为 0（所有刻度相同）时，使用一个小的填充
    if tickRange == 0
        pad = abs(firstTick) * 0.05; % 5% 的相对填充
        if pad == 0
            pad = 0.1; % 对于全零刻度，使用绝对填充
        end
        newYMin = firstTick - pad;
        newYMax = firstTick + pad;
    else
        % 根据 ratio 计算新的 y 轴下限与上限
        % 若第一个刻度在比例位置 ratio：
        % (firstTick - newYMin) / (newYMax - newYMin) = ratio
        % 假设在上方也留出相同比例的空间
        % 当 ratio < 0.5 时，下面的分母为正
        newYMin = firstTick - tickRange * ratio / (1 - 2*ratio);
        newYMax = lastTick + tickRange * ratio / (1 - 2*ratio);
    end
    
    % 设置新的 y 轴范围
    ax.YLim = [newYMin, newYMax];
end

