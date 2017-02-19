fname = input("Enter file name with path  ",'s');
fid = fopen(fname);
rname = regexprep(fname,'.txt','');
pdf_name = strcat(rname,'_tcxo.pdf');
i=0;
if fid ~= -1
	while ~feof(fid)
		line = fgets(fid);
		if strfind(line,'PGLOR')
			if strfind(line,',STA,')
				C = strsplit(line,',');
				i = i+1;
				D(i) = str2num(C{7});
				T(i) = str2num(C{4});
			endif
		endif
	end
	T = T(:);
	D = D(:);
	j = 2;
	flag = 0;
	for i = 2:size(T,1)
		if T(i,1) == 0
			plot(T(j:i-1,:),D(j:i-1,:),'bx');
			t = strcat('TCXO Graph between ',num2str(T(j)),' and ',num2str(T(i-1)));
			title(t);
			ylabel('TCXO Drift');
			xlabel('Time');
			if flag == 0
				print(gcf,pdf_name);
				flag = 1;
			else
				print(gcf,'-append',pdf_name);
			endif
			j=i+1;
		endif
		if i == size(T,1)
			plot(T(j:i,:),D(j:i,:),'bx');
			t = strcat('TCXO Graph between ',num2str(T(j)),' and ',num2str(T(i-1)));
			title(t);
			ylabel('TCXO Drift');
			xlabel('Time');
			if flag == 0
				print(gcf,pdf_name);
				flag = 1;
			else
				print(gcf,'-append',pdf_name);
			endif
		endif
	end
	close all
	fclose(fid);
	disp('PDF created successfully.')
else 
	disp('File name not valid.')
endif