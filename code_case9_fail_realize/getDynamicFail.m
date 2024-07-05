define_constants;  % Matpower 常数定义
mpc = loadcase('case9');  % 加载案例

t = 0:1:20;  % 时间向量
line_to_disconnect = 3;  % 选择要断开的线路编号
power_flow_results = struct('bus', {}, 'branch', {}, 'gen', {}, 'success', {});

for i = 1:length(t)
    if t(i) == 10  % 在第10秒断开一条线路
        mpc.branch(line_to_disconnect, BR_STATUS) = 0;  % 设置线路状态为断开
    end
    
    % 模拟发电机功率变化（如果有的话）
    % 示例：修改发电机功率
    % mpc.gen(1, PG) = initial_power * (1 + 0.01 * t(i));  % 功率随时间线性增加
    
    % 运行潮流分析
    results = runpf(mpc, mpoption('verbose', 0, 'out.all', 0));
    
    % 存储结果
    power_flow_results(i).bus = results.bus;
    power_flow_results(i).branch = results.branch;
    power_flow_results(i).gen = results.gen;
    power_flow_results(i).success = results.success;
end
