function [bus_phases] = get_all_bus_phases_fail(PG1,PG2,PG3)
    define_constants;  % 定义常数
    mpc = loadcase('case9');  % 加载案例

% 设置发电机输出功率
    mpc.gen(:, PG) = [PG1; PG2; PG3];
    mpc.branch(3,BR_STATUS) = 0;
% 设置潮流计算的选项
    mpopt = mpoption('pf.alg', 'NR', 'pf.tol', 1e-8, 'pf.nr.max_it', 30, 'out.all', 0);
    results = runpf(mpc, mpopt);
    %bus_phases = array2table(results.bus(selected_rows, [BUS_I, VA]), 'VariableNames', {'Bus_Number', 'Phase_Angle_Degrees'});
    bus_phases = results.bus(:, VA);
end