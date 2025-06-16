# mechanical_ventilation

#### 介绍
呼吸力学模型相关代码与实测数据，涉及参数估计、模型仿真与评估

#### 软件架构
主要基于python与matlab代码实现

#### 安装教程

1.  基于网页https://gitee.com/lizwtest/mechanical_ventilation 下载本项目或执行git clone https://gitee.com/lizwtest/mechanical_ventilation.git your_path。
2.  运行exe目录内可执行文件无其它依赖，运行pipeline目录内程序要求系统已安装python 3.10 和matlab R2023a或更高版本。
3.  基于MATLAB/Simulink进行含分数阶项的模型进行仿真时需正确安装开源vfoderiv3模块（https://ww2.mathworks.cn/matlabcentral/fileexchange/38801-fractional-variable-order-derivative-simulink-toolkit）。

#### 使用说明

1.  先执行run('your_path/pipeline/pre_setting.m')设置计算环境后，再根据计算需要执行main.m主流程run('your_path/pipeline/main.m')，最终给出计算中的最优模型结果。
2.  data目录下*.rar文件解压后为基于呼吸机Dräger Evita V300测得的HL7格式的原始数据，*.txt为提取不同呼吸模式和时间段的气压P(t)、流速V'(t)、呼吸气量V(t)格式化数据。pipeline目录下*.py为python代码、*.m为matlab代码、*.slx为Simulink模型文件，其中main.m为主流程代码。

#### 作者

lizongwei lizongweilzw@163.com


