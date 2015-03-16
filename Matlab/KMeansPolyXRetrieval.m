function [] = KMeansPolyXRetrieval()

% KMeans Polynomial Kernel canonical correlation Analysis 
%
% Usage:
%	Input: None
%	Ouput: KMeansPolyCCA.mat file containing results of Different languages obtained after cross-modal similarity measures.
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

% Poly-2

K_y_tr = (I_arr_tr*I_arr_tr'+1).^2;

% Kernelize Image Features - Testing %

% Poly-2

K_y_te = (I_arr_te*I_arr_te'+1).^2;

% Kernelize English Text - Training %

% Poly-2

K_x = (en_arr_tr*en_arr_tr'+1).^2;

% KCCA -English Training %

[U_en_tr,V_Ien_tr]= KCCA(K_x,K_y_tr,1);

% Kernelize English Text - Testing %

%Poly-2
K_x = (en_arr_te*en_arr_te'+1).^2;

% KCCA -English Testing %

[U_en_te,V_Ien_te]= KCCA(K_x,K_y_te,1);

% Kernelize German Text - Training %

%Poly-2 

K_x = (de_arr_tr*de_arr_tr'+1).^2;

% KCCA -German Training %

[U_de_tr,V_Ide_tr]= KCCA(K_x,K_y_tr,1);

% Kernelize German Text - Testing %

%Poly-2

K_x = (de_arr_te*de_arr_te'+1).^2;

% KCCA -German Testing %

[U_de_te,V_Ide_te]= KCCA(K_x,K_y_te,1);

% Kernelize Spanish Text - Training %

% Poly-2 

K_x = (es_arr_tr*es_arr_tr'+1).^2;

% KCCA - Spanish Training %

[U_es_tr,V_Ies_tr]= KCCA(K_x,K_y_tr,1);

% Kernelize Spanish Text - Testing %

%Poly-2

K_x = (es_arr_te*es_arr_te'+1).^2;

% KCCA - Spanish Testing %

[U_es_te,V_Ies_te]= KCCA(K_x,K_y_te,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Cross-Modal Retrieval Using Centroid Space (Optimized for Wikipedia (Text-Image) Dataset)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = statset('Display','final');

% Image Query - Text Retrieval  - English
%p=zeros([2173 1]);
%x=[U_en_tr p p p p p p];
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
%x=[V_Ien_tr p p p p p p];
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
%p=zeros([2173 1]);
%x=[U_en_tr p p p p p p];
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
%x=[V_Ien_tr p p p p p p];
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
%x=[U_en_tr p p p p p p];
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
%x=[V_Ien_tr p p p p p p];
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

save('KMeansPolyCCA.mat','rev_ICorr*','rev_IMin*','rev_ICheb*');
