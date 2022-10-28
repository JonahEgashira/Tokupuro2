% ���v���@�ۑ�@
% start from 2022/02  
% ch1 = Torque
% ch2 = EMG 

% LP = ? Hz
% Notch = on
% HP = ? Hz
% Sens HI (x1000)

%�팱�Җ�
defaultanswer = {'Masumoto'};
subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
subject_name = char(subject(1));

%�T���v�����O���g��
fs = 1000;

%��͂���f�[�^�imat�t�@�C���j��I�����A�ǂݍ���
[fname pname]=uigetfile('*.mat','��͂���f�[�^��I�����Ă�������')
  FP=[fname pname]
  if fname==0;return;end
   %fname���t�@�C�����^pname�̓t�@�C���̂���ꏊ�i�f�B���N�g���j
   load([pname fname]);
 
%�t�B���^�����O
data_filtered = data;
%�n���J�b�g�t�B���^
[b50,a50] = butter(3,[49 51]/500,'stop');
[b100,a100] = butter(3,[99 101]/500,'stop');
[b150,a150] = butter(3,[149 151]/500,'stop')
[b200,a200] = butter(3,[199 201]/500,'stop');
[b250,a250] = butter(3,[249 251]/500,'stop');
[b300,a300] = butter(3,[299 301]/500,'stop');
[b350,a350] = butter(3,[349 351]/500,'stop');
[b400,a400] = butter(3,[399 401]/500,'stop');
[b450,a450] = butter(3,[449 451]/500,'stop');
data_filtered = filtfilt(b50,a50,data_filtered);
data_filtered = filtfilt(b100,a100,data_filtered);
data_filtered = filtfilt(b150,a150,data_filtered);
data_filtered = filtfilt(b200,a200,data_filtered);
data_filtered = filtfilt(b250,a250,data_filtered);
data_filtered = filtfilt(b300,a300,data_filtered);
data_filtered = filtfilt(b350,a350,data_filtered);
data_filtered = filtfilt(b400,a400,data_filtered);
data_filtered = filtfilt(b450,a450,data_filtered);
 
 %�v���f�[�^�̒�`
 Force = data_filtered(:,1);
 EMG = data_filtered(:,2);
 %EMG��1000��V��1V�Ȃ̂ŁA�}�C�N���{���g�P�ʂɕϊ��i1000�{�j
 %����Y��������\��������̂ŕ��ς�����
 EMG = (EMG-mean(EMG))*1000; 


 %�S�g�����i��Βl���j
 rEMG = abs(EMG);
 
 %���ԍs����쐬
 time = 0:1/fs:length(Force)/fs-1/fs;
 
 %���g�`��`��
 figure = figure('Position',[1 1 500 700])
 subplot(2,1,1)
 plot(time,Force);
 ylabel('Force (V)','FontName','Arial','Fontsize',12);
 xlabel('time (s)','FontName','Arial','Fontsize',12);
 
 subplot(2,1,2)
 plot(time,rEMG);
 ylabel('rEMG (\muV)','FontName','Arial','Fontsize',12);
 xlabel('time (s)','FontName','Arial','Fontsize',12);
  
 uiwait; %�����̃A�N�V����������܂Ńv���O�������X�g�b�v
 

%��͑Ώۋ�Ԃ�ݒ�
%���肵��2�b�Ԃ̃f�[�^���v�Z
defaultanswer = {'5','7'};
startend = inputdlg({'start','end'},'��͋�Ԃ�2�b��ݒ肵�Ă�������',1,defaultanswer);
start_time = str2num(char(startend(1)));
end_time = str2num(char(startend(2)));

%��͑Ώۋ�Ԃ�2�b���̃f�[�^��؂�o��
Force = Force(start_time*fs+1:end_time*fs);
rEMG = rEMG(start_time*fs+1:end_time*fs);

%2�b�Ԃ̐ϕ��U�����v��
iEMG = sum(rEMG);


%�t�@�C���̕ۑ�
output_filename = sprintf('%s_EMGvsForce',subject_name);
save(output_filename,'iEMG');


%�@Low-pass fileter��High-pass filter�̒l���m�F���ċL�����悤�B
%�Afor�����g���āA20%, 40% 60%, 80%���ꂼ��̃f�[�^����iEMG���v�Z���āA�ЂƂ̍s��Ɋi�[���悤�B
%�B�Ō�ɁA�������u�́i%MVC�j�v�A�c�����uiEMG(��V�j�v�̃O���t��`�悵�Ă݂悤
%�C��A�����A��A���A���v�l������Ă݂悤�B
%�D�i�\�Ȃ�jLow-pass filter��High-pass filter�ɂ��āA�v���O�������Ōォ�炩������@��T�����B