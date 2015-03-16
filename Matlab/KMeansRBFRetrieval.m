function [] = KMeansRBFRetrieval()

% KMeans RBF Kernel canonical correlation Analysis 
%
% Usage:
%	Input: None
%	Ouput: KMeansRBFCCA.mat file containing results of Different languages obtained after cross-modal similarity measures.
%
%
% ©2015 Aditya Mogadala (aditya.mogadala@kit.edu), Karlsruhe Institute of Technology


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change .mat files for different topics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('Topics10/English-10.mat');
load('Topics10/German-10.mat');
load('Topics10/Spanish-10.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Learn Correlated Space of Text and Image Features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Kernelize Image Features - Training %

%RBF 

n2sq = sum(I_arr_tr'.^2,1);
n2 = size(I_arr_tr',2);
D1 = (ones(n2,1)*n2sq)' + ones(n2,1)*n2sq -2*I_arr_tr*I_arr_tr';
K_y_tr = exp(-D1/(2*500^2));

% Kernelize Image Features - Testing %

%RBF

n2sq = sum(I_arr_te'.^2,1);
n2 = size(I_arr_te',2);
D1 = (ones(n2,1)*n2sq)' + ones(n2,1)*n2sq -2*I_arr_te*I_arr_te';
K_y_te = exp(-D1/(2*500^2));


%options.PrjX = 1;
%options.PrjY = 1;
%options.RegX = 0;
%options.RegY = 0;


% Kernelize English Text - Training %

%RBF 

n1sq = sum(en_arr_tr'.^2,1);
n1 = size(en_arr_tr',2);
D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*en_arr_tr*en_arr_tr';
K_x = exp(-D/(2*500^2));


% KCCA -English Training %

[U_en_tr,V_Ien_tr]= KCCA(K_x,K_y_tr,1);


% Kernelize English Text - Testing %

%RBF 

n1sq = sum(en_arr_te'.^2,1);
n1 = size(en_arr_te',2);
D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*en_arr_te*en_arr_te';
K_x = exp(-D/(2*500^2));

% KCCA -English Testing %

[U_en_te,V_Ien_te]= KCCA(K_x,K_y_te,1);

% Kernelize German Text - Training %

%RBF 

n1sq = sum(de_arr_tr'.^2,1);
n1 = size(de_arr_tr',2);
D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*de_arr_tr*de_arr_tr';
K_x = exp(-D/(2*500^2));


% KCCA -German Training %

[U_de_tr,V_Ide_tr]= KCCA(K_x,K_y_tr,1);


% Kernelize German Text - Testing %

%RBF 

n1sq = sum(de_arr_te'.^2,1);
n1 = size(de_arr_te',2);
D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*de_arr_te*de_arr_te';
K_x = exp(-D/(2*500^2));

% KCCA -German Testing %

[U_de_te,V_Ide_te]= KCCA(K_x,K_y_te,1);



% Kernelize Spanish Text - Training %

%RBF 

n1sq = sum(es_arr_tr'.^2,1);
n1 = size(es_arr_tr',2);
D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*es_arr_tr*es_arr_tr';
K_x = exp(-D/(2*500^2));

% KCCA - Spanish Training %

[U_es_tr,V_Ies_tr]= KCCA(K_x,K_y_tr,1);


% Kernelize Spanish Text - Testing %

%RBF 

n1sq = sum(es_arr_te'.^2,1);
n1 = size(es_arr_te',2);
D = (ones(n1,1)*n1sq)' + ones(n1,1)*n1sq -2*es_arr_te*es_arr_te';
K_x = exp(-D/(2*500^2));

% KCCA - Spanish Testing %

[U_es_te,V_Ies_te]= KCCA(K_x,K_y_te,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Cross-Modal Retrieval Using Centroid Space (Optimized for Wikipedia (Text-Image) Dataset)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


opts = statset('Display','final');

% Image Query - Text Retrieval  - English

x=U_en_tr;
[r,c]=size(x);
y=V_Ien_te;
[r1,c1]=size(y);
if c1 > c
    p=zeros([2173 1]);
    count=c1-c;
    for i=1:count;
      x= [x p];
    end
elseif c > c1
    p=zeros([693 1]);
    count=c-c1;
    for i=1:count;
      y= [y p];
    end
end
size(x)
size(y)
[IDX1,C1] = kmeans(x,10,'Distance','cosine','Replicates',50,'Options',opts);
[Indval,Ind] = pdist2(C1,x,'minkowski',10,'Smallest',1);

[ICorrI_en,DCorrI] = knnsearch(C1(Ind,:),y,'k',10,'distance','correlation');
rev_ICorrI_en=ICorrI_en';
[IMinI_en,DMinI] = knnsearch(C1(Ind,:),y,'k',10,'distance','minkowski','p',10);
rev_IMinI_en=IMinI_en';
[IChebI_en,DChebI] = knnsearch(C1(Ind,:),y,'k',10,'distance','chebychev');
rev_IChebI_en=IChebI_en';

% Text Query - Image Retrieval  - English

x=V_Ien_tr;
[r,c]=size(x);
y=U_en_te;
[r1,c1]=size(y);
if c1 > c
    p=zeros([2173 1]);
    count=c1-c;
    for i=1:count;
      x= [x p];
    end
elseif c > c1
    p=zeros([693 1]);
    count=c-c1;
    for i=1:count;
      y= [y p];
    end
end
size(x)
size(y)
[IDX,C] = kmeans(x,10,'Distance','correlation','Replicates',50,'Options',opts);
[Indval1,Ind1] = pdist2(C,x,'correlation','Smallest',1);

[ICorrT_en,DCorrT] = knnsearch(C(Ind1,:),y,'k',10,'distance','correlation');
rev_ICorrT_en=ICorrT_en';
[IMinT_en,DMinT] = knnsearch(C(Ind1,:),y,'k',10,'distance','minkowski','p',10);
rev_IMinT_en=IMinT_en';
[IChebT_en,DChebT] = knnsearch(C(Ind1,:),y,'k',10,'distance','chebychev');
rev_IChebT_en=IChebT_en';


% Image Query - Text Retrieval  - German
x=U_de_tr;
[r,c]=size(x);
y=V_Ide_te;
[r1,c1]=size(y);
if c1 > c
    p=zeros([2173 1]);
    count=c1-c;
    for i=1:count;
      x= [x p];
    end
elseif c > c1
    p=zeros([693 1]);
    count=c-c1;
    for i=1:count;
      y= [y p];
    end
end
size(x)
size(y)
[IDX1,C1] = kmeans(x,10,'Distance','cosine','Replicates',50,'Options',opts);
[Indval,Ind] = pdist2(C1,x,'minkowski',10,'Smallest',1);

[ICorrI_de,DCorrI] = knnsearch(C1(Ind,:),y,'k',10,'distance','correlation');
rev_ICorrI_de=ICorrI_de';
[IMinI_de,DMinI] = knnsearch(C1(Ind,:),y,'k',10,'distance','minkowski','p',10);
rev_IMinI_de=IMinI_de';
[IChebI_de,DChebI] = knnsearch(C1(Ind,:),y,'k',10,'distance','chebychev');
rev_IChebI_de=IChebI_de';

% Text Query - Image Retrieval  - German
x=V_Ide_tr;
[r,c]=size(x);
y=U_de_te;
[r1,c1]=size(y);
if c1 > c
    p=zeros([2173 1]);
    count=c1-c;
    for i=1:count;
      x= [x p];
    end
elseif c > c1
    p=zeros([693 1]);
    count=c-c1;
    for i=1:count;
      y= [y p];
    end
end
size(x)
size(y)
[IDX,C] = kmeans(x,10,'Distance','correlation','Replicates',50,'Options',opts);
[Indval1,Ind1] = pdist2(C,x,'correlation','Smallest',1);

[ICorrT_de,DCorrT] = knnsearch(C(Ind1,:),y,'k',10,'distance','correlation');
rev_ICorrT_de=ICorrT_de';
[IMinT_de,DMinT] = knnsearch(C(Ind1,:),y,'k',10,'distance','minkowski','p',10);
rev_IMinT_de=IMinT_de';
[IChebT_de,DChebT] = knnsearch(C(Ind1,:),y,'k',10,'distance','chebychev');
rev_IChebT_de=IChebT_de';


% Image Query - Text Retrieval  - Spanish
%p=zeros([2173 1]);
x=U_es_tr;
[r,c]=size(x);
y=V_Ies_te;
[r1,c1]=size(y);
if c1 > c
    p=zeros([2173 1]);
    count=c1-c;
    for i=1:count;
      x= [x p];
    end
elseif c > c1
    p=zeros([693 1]);
    count=c-c1;
    for i=1:count;
      y= [y p];
    end
end
size(x)
size(y)
[IDX1,C1] = kmeans(x,10,'Distance','cosine','Replicates',50,'Options',opts);
[Indval,Ind] = pdist2(C1,x,'minkowski',10,'Smallest',1);

[ICorrI_es,DCorrI] = knnsearch(C1(Ind,:),y,'k',10,'distance','correlation');
rev_ICorrI_es=ICorrI_es';
[IMinI_es,DMinI] = knnsearch(C1(Ind,:),y,'k',10,'distance','minkowski','p',10);
rev_IMinI_es=IMinI_es';
[IChebI_es,DChebI] = knnsearch(C1(Ind,:),y,'k',10,'distance','chebychev');
rev_IChebI_es=IChebI_es';

% Text Query - Image Retrieval  - Spanish
x=V_Ies_tr;
[r,c]=size(x);
y=U_es_te;
[r1,c1]=size(y);
if c1 > c
    p=zeros([2173 1]);
    count=c1-c;
    for i=1:count;
      x= [x p];
    end
elseif c > c1
    p=zeros([693 1]);
    count=c-c1;
    for i=1:count;
      y= [y p];
    end
end
size(x)
size(y)
[IDX,C] = kmeans(x,10,'Distance','correlation','Replicates',50,'Options',opts);
[Indval1,Ind1] = pdist2(C,x,'correlation','Smallest',1);

[ICorrT_es,DCorrT] = knnsearch(C(Ind1,:),y,'k',10,'distance','correlation');
rev_ICorrT_es=ICorrT_es';
[IMinT_es,DMinT] = knnsearch(C(Ind1,:),y,'k',10,'distance','minkowski','p',10);
rev_IMinT_es=IMinT_es';
[IChebT_es,DChebT] = knnsearch(C(Ind1,:),y,'k',10,'distance','chebychev');
rev_IChebT_es=IChebT_es';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save cross-modal retrieval results to a .mat file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save('KMeansRBFCCA.mat','rev_ICorr*','rev_IMin*','rev_ICheb*');
