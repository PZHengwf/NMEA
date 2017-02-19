clear;
fname = input("Enter file name with path  ",'s');
fid = fopen(fname);
rname = regexprep(fname,'.txt','');
pdf_name = strcat(rname,'_GPS.pdf');
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
	j = 1;
	i = 0;
	k = 0;
	while (~feof(fid) && j<=size(D,2))
		line = fgets(fid);
		if strfind(line,'GPGSV')
			X = strsplit(line,',');
			if str2num(X{3})==3
				k = k+1;
				V(k) = str2num(X{4});
			endif
		endif
		if(j<=size(D,2) && D(j) == 180)
			i = i+1;
			T(i) = 0;
			t = t+1;
			TM(t) = i;
			j=j+1;
		elseif strfind(line,'GPGSA,A,3,')
			A = strsplit(line,',');
			fix = fix+1;
			i = i+1;
			j=j+1;
			if k > 0
				s = V(k);
				T(i) = s;
				k = 0;
				clear V;
			endif
			s = size(A,2);
			U(i) = s-6;
		endif
	end
	fclose(fid);
	I = [1:i];
	v=mean(T);
	for q = 1:t
		T(TM(q)) = NaN;
	end
	I = [1:i];
	u=mean(U);
	for i = q:t
		U(TM(q)) = NaN;
	end
	plot(I,T,'bx',I,U,'gx');
	hold on
	for i = 1:t
		T(TM(i)) = 0;
		U(TM(i)) = 0;
		plot(I(TM(i)),T(TM(i)),'rx',I(TM(i)),U(TM(i)),'rx');
	end	
	tt = strcat('Satellites In View (Average) - ',num2str(v),'\n','  Satellites In Use (Average) - ',num2str(u));
	title(tt);
	xlabel('Iterations');
	ylabel('No. of Satellites');
	legend('Satellites in View','Satellites in Use','Timeout');
	hold off
	print(gcf,pdf_name);
	close all;
	disp('PDF created successfully.')
else 
	disp('File name not valid.')
endif