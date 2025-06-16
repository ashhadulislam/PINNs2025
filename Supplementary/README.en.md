# mechanical_ventilation

#### Description

Code related to the respiratory mechanics model and actual measurement data, involving parameter estimation, model simulation and evaluation.

#### Software Architecture
Mainly implemented based on Python and Matlab code.

#### Installation

1.  Download this project from the webpage https://gitee.com/lizwtest/mechanical_ventilation or execute git clone https://gitee.com/lizwtest/mechanical_ventilation.git your_path.
2.  The executable files in the exe directory can run without any other dependencies, while the programs in the pipeline directory require the system to have Python 3.10 and Matlab R2023a or higher versions installed.
3.  When simulating models with fractional order terms based on MATLAB/Simulink, the open-source vfoderiv3 module needs to be correctly installed(https://ww2.mathworks.cn/matlabcentral/fileexchange/38801-fractional-variable-order-derivative-simulink-toolkit).

#### Instructions

1.  In matlab, first execute run('your_path/pipeline/pre_setting.m') to set up the computing environment, then proceed to execute the main process run('your_path/pipeline/main.m') according to the computing needs, and finally provide the optimal model results in the calculation.
2.  The *.rar files in the data directory, once decompressed, are raw data in HL7 format measured based on the Dräger Evita V300 ventilator. The *.txt files are formatted data of pressure P(t), flow rate V'(t), and respiratory volume V(t) extracted from different respiratory modes and time periods. In the pipeline directory, *.py files are Python codes, *.m files are Matlab codes, and *.slx files are Simulink model files, among which main.m is the main process code.

#### Author

lizongwei lizongweilzw@163.com

