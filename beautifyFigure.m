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
    %   beautifyFigure(truncateY=[10,20], truncateYTickSpacing=[2,5]) % 截断Y轴，下轴间隔2，上轴间隔5
    %
    % 参数：
    %   "hFig" - 图形句柄，默认使用当前图形。如果同时提供位置参数和命名参数 hFig，则优先使用位置参数。
    %   "filename" - 保存文件的名称（不包含扩展名），如果提供，则保存美化后的图形。
    %   "figSize" - 尺寸，格式为 [宽, 高]，单位为厘米。设置为 [0, 0] 时不修改尺寸。
    %   "sizeObject" - figSize作用的对象，"axes"表示设置坐标轴尺寸，"figure"表示设置整个图形尺寸。
    %   "exportFormats" - 导出格式，可选值为 ["pdf", "fig", "png", "svg"] 的组合，默认为 ["pdf", "fig", "png"]。
    %   "fontSize" - 字体大小（单位：pt），用于坐标轴刻度、标签、标题、图例、颜色条、文本等，默认 6。
    %   "lineWidth" - 线宽（单位：pt），用于坐标轴边框/刻度、线对象、散点边框、区域/柱状/盒须图边界、颜色条等，默认 1。
    %   "truncateY" - Y轴截断区间，格式为 [a,b]，去除区间 (a,b)，显示 [ymin,a] 与 [b,ymax]，默认为空（不截断）。
    %   "truncateYTickSpacing" - 截断Y轴时的刻度间隔，格式为 [下轴间隔, 上轴间隔]，默认为空（自动计算）。
    
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
        opts.truncateY double = []; % 默认不截断；若为 [a,b] 则去除区间 (a,b)，显示 [ymin,a] 与 [b,ymax]
        opts.truncateYTickSpacing double = []; % 默认为空（自动计算）；若为 [a,b] 则下轴间隔为a，上轴间隔为b
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
    
    % 若需要对 Y 轴进行截断处理，则为每个坐标区创建上下两个子坐标区
    if ~isempty(opts.truncateY)
        if ~(isnumeric(opts.truncateY) && isvector(opts.truncateY) && numel(opts.truncateY)==2 && opts.truncateY(1)<opts.truncateY(2))
            error('opts.truncateY must be empty or a 1x2 numeric vector with increasing values.');
        end
        % 验证 truncateYTickSpacing 参数
        if ~isempty(opts.truncateYTickSpacing)
            if ~(isnumeric(opts.truncateYTickSpacing) && isvector(opts.truncateYTickSpacing) && numel(opts.truncateYTickSpacing)==2 && all(opts.truncateYTickSpacing>0))
                error('opts.truncateYTickSpacing must be empty or a 1x2 positive numeric vector.');
            end
        end
        origAxes = axesHandles;
        for k = 1:length(origAxes)
            try
                createTruncatedAxes(origAxes(k), opts.truncateY, hFig, opts.truncateYTickSpacing);
            catch
                warning('beautifyFigure:truncate','Failed to create truncated axes for one axes; skipping.');
            end
        end
        % 重新获取 axesHandles（包含新创建的上下坐标区）
        axesHandles = findall(hFig, 'Type', 'axes');
    end
    
    % 调整坐标轴和图形尺寸，根据sizeObject参数决定调整目标
    if ~isempty(axesHandles) && ~isequal(opts.figSize, [0, 0])
        if opts.sizeObject == "axes"
            % 设置坐标轴尺寸
            if ~isempty(opts.truncateY)
                % 截断模式：找到上下坐标轴，调整它们的总体尺寸
                adjustTruncatedAxesSize(hFig, opts.figSize);
            else
                % 普通模式：调整单个坐标轴
                ax = axesHandles(1);
                ax.Units = 'centimeters';
                sizeDiff = opts.figSize - ax.Position(3:4);
                hFig.Units = 'centimeters';
                hFig.Position(3:4) = hFig.Position(3:4) + sizeDiff;
                ax.Position(3:4) = opts.figSize;
            end
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
            middle = mean(yticks_current);
            yticks_new = [yticks_current(1), middle, yticks_current(end)];
            set(ax, 'YTick', yticks_new);
        end
        
        % 如果用户要求，统一 y 轴第一个刻度到 x 轴的视觉距离（ratio=0 则跳过）
        if isfield(opts, 'firstTickRatio') && opts.firstTickRatio > 0
            try
                % 当存在截断时，仅对底部轴应用 firstTickRatio
                if ~isempty(opts.truncateY)
                    role = getappdata(ax, 'BeautifyTruncateRole');
                    if isempty(role) || strcmp(role, 'bottom')
                        unifyFirstTickDistance(ax, opts.firstTickRatio);
                    end
                else
                    unifyFirstTickDistance(ax, opts.firstTickRatio);
                end
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


function adjustTruncatedAxesSize(hFig, targetSize)
    % adjustTruncatedAxesSize 调整截断坐标轴组的总体尺寸
    % targetSize: [宽, 高] 单位：厘米
    
    % 查找所有坐标轴
    allAxes = findall(hFig, 'Type', 'axes');
    
    % 找到上下坐标轴
    topAx = [];
    bottomAx = [];
    for i = 1:length(allAxes)
        role = getappdata(allAxes(i), 'BeautifyTruncateRole');
        if strcmp(role, 'top')
            topAx = allAxes(i);
        elseif strcmp(role, 'bottom')
            bottomAx = allAxes(i);
        end
    end
    
    if isempty(topAx) || isempty(bottomAx)
        return;
    end
    
    % 转换为厘米单位
    topAx.Units = 'centimeters';
    bottomAx.Units = 'centimeters';
    hFig.Units = 'centimeters';
    
    % 获取当前位置
    topPos = topAx.Position;
    bottomPos = bottomAx.Position;
    
    % 计算当前总高度（包括间隙）
    currentTotalHeight = (topPos(2) + topPos(4)) - bottomPos(2);
    currentWidth = bottomPos(3);
    
    % 计算缩放比例
    heightScale = targetSize(2) / currentTotalHeight;
    widthScale = targetSize(1) / currentWidth;
    
    % 计算当前间隙
    currentGap = topPos(2) - (bottomPos(2) + bottomPos(4));
    
    % 按比例缩放各部分
    newBottomH = bottomPos(4) * heightScale;
    newTopH = topPos(4) * heightScale;
    newGap = currentGap * heightScale;
    newWidth = targetSize(1);
    
    % 更新位置（保持左下角 x, y 不变）
    bottomPos_new = [bottomPos(1), bottomPos(2), newWidth, newBottomH];
    topPos_new = [topPos(1), bottomPos(2) + newBottomH + newGap, newWidth, newTopH];
    
    bottomAx.Position = bottomPos_new;
    topAx.Position = topPos_new;
    
    % 调整图形窗口大小
    figPos = hFig.Position;
    widthDiff = targetSize(1) - currentWidth;
    heightDiff = targetSize(2) - currentTotalHeight;
    hFig.Position(3:4) = figPos(3:4) + [widthDiff, heightDiff];
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


function createTruncatedAxes(ax, interval, hFig, tickSpacing)
    % createTruncatedAxes 将一个坐标区拆分为上下两个坐标区以实现Y轴截断
    % interval = [a, b] 表示移除 (a,b) 区间，显示 [ymin,a] 与 [b,ymax]
    % tickSpacing = [bottomSpacing, topSpacing] 指定上下轴的刻度间隔（可选）
    
    % 保护性检查
    if isempty(ax) || ~isvalid(ax)
        return;
    end
    a = interval(1);
    b = interval(2);
    if a >= b
        return;
    end
    
    % 使用归一化位置便于计算（不改变原坐标区的Units）
    origUnits = ax.Units;
    ax.Units = 'normalized';
    origPos = ax.Position; % [x y w h]
    
    % 当前显示范围
    ylim_orig = ax.YLim;
    ymin = ylim_orig(1);
    ymax = ylim_orig(2);
    
    % 若截断区间与当前范围无交集或无效，则跳过
    if a <= ymin || b >= ymax
        ax.Units = origUnits;
        return;
    end
    
    bottomRange = a - ymin;
    topRange = ymax - b;
    if bottomRange <= 0 || topRange <= 0
        ax.Units = origUnits;
        return;
    end
    
    % 按显示数据范围比例分配上下高度，并在两者之间留出空白（高度为原轴高度的10%）
    totalRange = bottomRange + topRange;
    gapFrac = 0.10; % 中间空白占原轴高度的比例
    gap = origPos(4) * gapFrac;
    remainingH = origPos(4) - gap;
    bottomH = remainingH * (bottomRange / totalRange);
    topH = remainingH - bottomH;
    
    % 子坐标区位置（上下之间留出 gap 空白）
    bottomPos = [origPos(1), origPos(2), origPos(3), bottomH];
    topPos = [origPos(1), origPos(2) + bottomH + gap, origPos(3), topH];
    
    % 创建新的两个坐标区
    topAx = axes('Parent', hFig, 'Position', topPos, 'Units', 'normalized');
    bottomAx = axes('Parent', hFig, 'Position', bottomPos, 'Units', 'normalized');
    % 标记角色，便于主流程区分（top / bottom）
    setappdata(topAx, 'BeautifyTruncateRole', 'top');
    setappdata(bottomAx, 'BeautifyTruncateRole', 'bottom');
    
    % 复制原坐标区的属性（标签、标题、颜色等简单属性）
    try
        set(topAx, 'FontName', ax.FontName, 'FontSize', ax.FontSize, 'LineWidth', ax.LineWidth, 'Box', 'off');
        set(bottomAx, 'FontName', ax.FontName, 'FontSize', ax.FontSize, 'LineWidth', ax.LineWidth, 'Box', 'off');
    catch
    end
    
    % 复制子对象到两个坐标区（会被各自的 YLim 裁剪）
    kids = allchild(ax);
    for k = 1:length(kids)
        try
            copyobj(kids(k), topAx);
            copyobj(kids(k), bottomAx);
        catch
        end
    end
    
    % 设置上下坐标区的 YLim
    topAx.YLim = [b, ymax];
    bottomAx.YLim = [ymin, a];
    
    % X 轴保持一致，隐藏上坐标区的 X 标签与刻度标签；同时隐藏上轴的 X 轴线与刻度
    xlimVal = ax.XLim;
    topAx.XLim = xlimVal;
    bottomAx.XLim = xlimVal;
    set(topAx, 'XTickLabel', []);
    try
        set(topAx, 'XColor', 'none', 'XTick', []);
    catch
        % 某些 MATLAB 版本或对象可能不支持直接设置，忽略即可
    end
    
    % 将两个坐标区在 X 方向联动
    linkaxes([topAx, bottomAx], 'x');
    
    % 调整刻度：根据是否提供 tickSpacing 参数
    if nargin >= 4 && ~isempty(tickSpacing) && numel(tickSpacing) == 2
        % 使用用户指定的刻度间隔
        bottomSpacing = tickSpacing(1);
        topSpacing = tickSpacing(2);
        
        % 为下轴生成刻度
        bottomTicks = ymin:bottomSpacing:a;
        if isempty(bottomTicks) || bottomTicks(end) < a
            bottomTicks = unique([bottomTicks, a]);
        end
        
        % 为上轴生成刻度
        topTicks = b:topSpacing:ymax;
        if isempty(topTicks) || topTicks(end) < ymax
            topTicks = unique([topTicks, ymax]);
        end
    else
        % 自动计算刻度（使用原有逻辑）
        origTicks = ax.YTick;
        bottomTicks = origTicks(origTicks <= a);
        topTicks = origTicks(origTicks >= b);
        if isempty(bottomTicks)
            bottomTicks = unique([ymin, a]);
        end
        if isempty(topTicks)
            topTicks = unique([b, ymax]);
        end
    end
    
    set(bottomAx, 'YTick', bottomTicks);
    set(topAx, 'YTick', topTicks);
    
    % 中间不绘制任何断裂线，保留空白以提示截断
    
    % 复制坐标轴标签与标题到下轴（保留位置），上轴不显示 X 标签
    try
        xlabel(bottomAx, ax.XLabel.String, 'FontSize', ax.XLabel.FontSize, 'FontName', ax.XLabel.FontName);
        ylabel(bottomAx, ax.YLabel.String, 'FontSize', ax.YLabel.FontSize, 'FontName', ax.YLabel.FontName);
        title(topAx, ax.Title.String, 'FontSize', ax.Title.FontSize, 'FontName', ax.Title.FontName);
    catch
    end
    
    % 删除原坐标区
    try
        delete(ax);
    catch
    end
    
    % 恢复原单位（新坐标区使用归一化单位）
    
end