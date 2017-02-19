clear;
fname = input("Enter file name with path  ",'s');
fid = fopen(fname);
rname = regexprep(fname,'.txt','');
pdf_name = strcat(rname,'_TTFF.pdf');
fix=0;
i=0;
t=0;
if fid ~= -1
	while ~feof(fid)
		line = fgets(fid);
		if strfind(line,'TTFF')
			C = strsplit(line,':');
			i = i+1;
			con = strcmp(strtrim(C{2}),'Timeout');
			if con == 0
				D(i) = str2num(C{2});
			else
				D(i) = 180;
				flag = 1;
			endif
		endif
	end
	fclose(fid);
	fid = fopen(fname);
	j=1;
	i=0;
	while (~feof(fid) && j<=size(D,2))
		line = fgets(fid);
		if(j<=size(D,2) && D(j) == 180)
			i = i+1;
			T(i) = 0;
			t = t+1;
			TM(t) = i;
			j=j+1;
		elseif strfind(line,'TTFF')
			A = strsplit(line,':');
			con = strcmp(strtrim(A{2}),'Timeout');
			if con == 0
			fix = fix+1;
			i = i+1;
			j=j+1;
			T(i) = str2num(A{2});
			endif
		endif
	end
	fclose(fid);
	I = [1:i];
	a=mean(T);
	for i = 1:t
		T(TM(i)) = NaN;
	end
	
	plot(I,T,'bx');
	hold on
	lim = get(gca,'YLim');
	max = lim(2);
	for i = 1:t
		T(TM(i)) = max;
		plot(I(TM(i)),T(TM(i)),'rx');
	end
	a = mean(T);
	t = strcat('Average Time To First Fix - ',num2str(a));
	title(t);
	xlabel('Iterations');
	ylabel('Time To First Fix (TTFF)');
	legend('TTFF','Timeout');
	hold off
	print(gcf,pdf_name);
	close all;
	disp('PDF created successfully.')
else 
	disp('File name not valid.')
endif