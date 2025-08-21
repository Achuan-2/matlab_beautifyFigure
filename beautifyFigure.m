function beautifyFigure(opts)
    % BEAUTIFYFIGURE 美化 MATLAB 图形以适用于论文出版。
    %
    % 用法：
    %   beautifyFigure()                                    % 自动美化当前图形。
    %   beautifyFigure(hFig=fig)                           % 美化指定句柄的图形。
    %   beautifyFigure(hFig=fig, filename="foo")           % 美化并保存图形。
    %   beautifyFigure(hFig=fig, figSize=[7, 5])           % 指定尺寸。
    %   beautifyFigure(hFig=fig, figSize=[0, 0])           % 不修改尺寸。
    %   beautifyFigure(sizeObject="figure", figSize=[10, 8]) % 设置整个图形尺寸。
    %   beautifyFigure(sizeObject="axes", figSize=[7, 5])    % 设置坐标轴尺寸。
    %   beautifyFigure(filename="foo", exportFormats=["pdf"]) % 只导出PDF格式。
    %   beautifyFigure(fontSize=8)                         % 统一设置字体大小为 8 pt。
    %   beautifyFigure(lineWidth=1.5)                      % 统一设置线宽为 1.5 pt。
    %
    % 参数：
    %   "hFig" - 图形句柄，默认是当前图形。
    %   "filename" - 保存文件的名称（不包含扩展名），如果提供，则保存美化后的图形。
    %   "figSize" - 尺寸，格式为 [宽, 高]，单位为厘米。设置为 [0, 0] 时不修改尺寸。
    %   "sizeObject" - figSize作用的对象，"axes"表示设置坐标轴尺寸，"figure"表示设置整个图形尺寸。
    %   "exportFormats" - 导出格式，可选值为 ["pdf", "fig", "png", "svg"] 的组合，默认为 ["pdf", "fig", "png"]。
    %   "fontSize" - 字体大小（单位：pt），用于坐标轴刻度、标签、标题、图例、颜色条、文本等，默认 6。
    %   "lineWidth" - 线宽（单位：pt），用于坐标轴边框/刻度、线对象、散点边框、区域/柱状/盒须图边界、颜色条等，默认 1。
    
    arguments
        opts.hFig = gcf; % 默认获取当前图形句柄
        opts.filename string = ""; % 默认文件名为空
        opts.figSize (1, 2) double = [4, 4]; % 默认尺寸为 [4, 4] 厘米
        opts.sizeObject string {mustBeMember(opts.sizeObject, ["axes", "figure"])} = "axes"; % 默认设置坐标轴尺寸
        opts.exportFormats string = ["pdf", "fig", "png"]; % 默认导出格式
    opts.fontSize (1,1) double {mustBePositive} = 6; % 统一字体大小（pt）
    opts.lineWidth (1,1) double {mustBePositive} = 1; % 统一线宽（pt）
    end
    
    % 设置图形单位为厘米
    set(opts.hFig, 'Units', 'centimeters');
    
    % 将图形背景设置为白色
    set(opts.hFig, 'Color', 'w');
    
    % 设置默认字体为 Arial
    set(opts.hFig, 'defaultTextFontName', 'Arial');
    set(opts.hFig, 'defaultAxesFontName', 'Arial');
    % 设置默认字体大小（便于新创建对象继承）
    set(opts.hFig, 'defaultTextFontSize', opts.fontSize);
    set(opts.hFig, 'defaultAxesFontSize', opts.fontSize);
    % 设置默认线宽（便于新创建对象继承）
    set(opts.hFig, 'defaultLineLineWidth', opts.lineWidth);
    set(opts.hFig, 'defaultAxesLineWidth', opts.lineWidth);
    
    % 获取图形中的所有坐标轴
    axesHandles = findall(opts.hFig, 'Type', 'axes');
    
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
            set(lines(j), 'LineWidth', opts.lineWidth, 'MarkerSize', 6);
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
    end
    
    % 设置所有text对象的字体
    textHandles = findall(opts.hFig, 'Type', 'text');
    
    for i = 1:length(textHandles)
        set(textHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
    end
    
    % 设置所有annotation对象的字体（包括textbox, textarrow等）
    annotationHandles = findall(opts.hFig, 'Type', 'hggroup', '-property', 'FontName');
    
    for i = 1:length(annotationHandles)
        if isprop(annotationHandles(i), 'FontName')
            set(annotationHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
        end
    end
    
    % 查找并设置textbox annotation对象
    textboxHandles = findall(opts.hFig, 'Type', 'textbox');
    
    for i = 1:length(textboxHandles)
        set(textboxHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
    end
    
    % 查找并设置textarrow annotation对象
    textarrowHandles = findall(opts.hFig, 'Type', 'textarrow');
    
    for i = 1:length(textarrowHandles)
        set(textarrowHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial');
    end
    
    % 调整图例属性
    legendHandles = findall(opts.hFig, 'Type', 'legend');
    
    for i = 1:length(legendHandles)
        set(legendHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial', 'EdgeColor', [0 0 0]);
    end
    
    % 调整颜色条属性
    colorbarHandles = findall(opts.hFig, 'Type', 'colorbar');
    
    for i = 1:length(colorbarHandles)
        set(colorbarHandles(i), 'FontSize', opts.fontSize, 'FontWeight', 'normal', 'FontName', 'Arial', 'LineWidth', opts.lineWidth);
    end
    
    % 调整坐标轴和图形尺寸，根据sizeObject参数决定调整目标
    if ~isempty(axesHandles) && ~isequal(opts.figSize, [0, 0])
        if opts.sizeObject == "axes"
            % 设置坐标轴尺寸（原有逻辑）
            ax = axesHandles(1);
            ax.Units = 'Centimeters';
            sizeDiff = opts.figSize - ax.Position(3:4);
            opts.hFig.Units = 'centimeters';
            opts.hFig.Position(3:4) = opts.hFig.Position(3:4) + sizeDiff;
            ax.Position(3:4) = opts.figSize;
        elseif opts.sizeObject == "figure"
            % 设置整个图形尺寸
            opts.hFig.Units = 'centimeters';
            opts.hFig.Position(3:4) = opts.figSize;
        end
    end
    
    % 如果提供了文件名，则根据指定格式保存图形
    if opts.filename ~= ""
        % 保存为 FIG 文件
        if ismember("fig", opts.exportFormats)
            savefig(opts.hFig, strcat(opts.filename, '.fig'));
        end
        % 保存为 SVG 文件
        if ismember("svg", opts.exportFormats)
            saveas(opts.hFig, strcat(opts.filename, '.svg'));
        end
        % 保存为 PDF 文件
        if ismember("pdf", opts.exportFormats)
            exportgraphics(opts.hFig, strcat(opts.filename, '.pdf'), 'ContentType', 'vector', 'BackgroundColor', 'none', 'Resolution', 300);
        end
        % 保存为 PNG 文件
        if ismember("png", opts.exportFormats)
            exportgraphics(opts.hFig, strcat(opts.filename, '.png'), 'Resolution', 300);
        end
    end
    
end
