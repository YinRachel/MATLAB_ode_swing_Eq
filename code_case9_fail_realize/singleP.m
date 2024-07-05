define_constants;  % 定义常数
mpc = loadcase('case9');  % 加载案例

% 时间区间 [0, 20]
t = linspace(0, 20, 201);

% 参数 d, B12, V1, V2, P1, m 需要给出它们的值
d = 0.15;
B12 = 0.5;
V1 = 1;
V2 = 1;
P1m = 0.9;  % 发电机功率输入的固定值
P2m = 0.8;
P3m = 0.6;
m = 0.4;

results = struct();
y_one = [1; 1]; % 初始条件
y_two = [0.12; 0.12]; % 初始条件
y_three = [0.13; 0.13]; % 初始条件
bus_phases = [0, 0, 0];

usol1 = zeros(1, length(t));
usol2 = zeros(1, length(t));
usol3 = zeros(1, length(t));
all_branch_pf_qf = zeros(9,length(t));
all_bus_phases = zeros(9,length(t));

index_at_10 = find(t == 10);  % 查找 t 中值为 10 的元素的索引
for i = 1:index_at_10 - 1
    % 使用ode45求解摆动方程，每次只前进一小步
    [t_span, y1] = ode45(@(t, y) getDynamicDelta(t, y, d, B12, V1, V2, P1m, m, bus_phases(end,1)), [t(i), t(i+1)], y_one);
    [t_span, y2] = ode45(@(t, y) getDynamicDelta(t, y, d, B12, V1, V2, P2m, m, bus_phases(end,2)), [t(i), t(i+1)], y_two);
    [t_span, y3] = ode45(@(t, y) getDynamicDelta(t, y, d, B12, V1, V2, P3m, m, bus_phases(end,3)), [t(i), t(i+1)], y_three);

    % 更新初始条件为最新的状态
    y_one = y1(end, :).';
    y_two = y2(end, :).';
    y_three = y3(end, :).';

    % 存储每步结果
    usol1(i) = y1(end, 1);
    usol2(i) = y2(end, 1);
    usol3(i) = y3(end, 1);

    % 计算当前电网相位
    PG1 = pgFunction(B12, V1, V2, y1(end, 1), bus_phases(end,1));
    PG2 = pgFunction(B12, V1, V2, y2(end, 1), bus_phases(end,2));
    PG3 = pgFunction(B12, V1, V2, y3(end, 1), bus_phases(end,3));

    % 更新 bus_phases
    %bus_phases = get_bus_phases(PG1, PG2, PG3);
    bus_phases(i+1, :) = get_bus_phases(PG1, PG2, PG3);
    all_branch_pf_qf(:,i) = allBranchPFFunc(PG1, PG2, PG3);
    all_bus_phases(:,i) = get_all_bus_phases(PG1, PG2, PG3);
end

for i = index_at_10:length(t)-1

    % 使用ode45求解摆动方程，每次只前进一小步
    [t_span, y1] = ode45(@(t, y) getDynamicDelta(t, y, d, B12, V1, V2, P1m, m, bus_phases(end,1)), [t(i), t(i+1)], y_one);
    [t_span, y2] = ode45(@(t, y) getDynamicDelta(t, y, d, B12, V1, V2, P2m, m, bus_phases(end,2)), [t(i), t(i+1)], y_two);
    [t_span, y3] = ode45(@(t, y) getDynamicDelta(t, y, d, B12, V1, V2, P3m, m, bus_phases(end,3)), [t(i), t(i+1)], y_three);

    % 更新初始条件为最新的状态
    y_one = y1(end, :).';
    y_two = y2(end, :).';
    y_three = y3(end, :).';

    % 存储每步结果
    usol1(i) = y1(end, 1);
    usol2(i) = y2(end, 1);
    usol3(i) = y3(end, 1);

    % 计算当前电网相位
    PG1 = pgFunction(B12, V1, V2, y1(end, 1), bus_phases(end,1));
    PG2 = pgFunction(B12, V1, V2, y2(end, 1), bus_phases(end,2));
    PG3 = pgFunction(B12, V1, V2, y3(end, 1), bus_phases(end,3));

    % 更新 bus_phases
    %bus_phases = get_bus_phases(PG1, PG2, PG3);
    bus_phases(i+1, :) = get_bus_phases_fail(PG1, PG2, PG3);
    all_branch_pf_qf(:,i) = allBranchPFFunc_fail(PG1, PG2, PG3);
    all_bus_phases(:,i) = get_all_bus_phases_fail(PG1, PG2, PG3);
end


%plot(t, all_branch_pf_qf);
%plot(t, usol1);
plot(t,all_bus_phases)

load_loss = sum(all_branch_pf_qf(:,100)-all_branch_pf_qf(:,101));
disp(load_loss)

%title('Generator 1 Angle over Time');
%xlabel('Time (s)');
%ylabel('Angle (radians)');
