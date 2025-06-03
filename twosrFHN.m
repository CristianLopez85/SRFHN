function [x,v] = twosrFHN(a,b,h,g,x1)

%   twosrFHN by CL

x=zeros(1,length(x1));
v=zeros(1,length(x1));
for i=1:length(x1)-1
    v1=v(i);
    k1=-(a+b)*x(i)+(a+1)*x(i).^2- x(i).^3 + x1(i);

    v2=(v(i)+k1*h/2);
    k2=(-(a+b)*(x(i)+v1*h/2)+(a+1)*(x(i)+v1*h/2).^2 - (x(i)+v1*h/2).^3 -g*v2+x1(i));

    v3=(v(i)+k2*h/2);
    k3=(-(a+b)*(x(i)+v2*h/2)+(a+1)*(x(i)+v2*h/2).^2 - (x(i)+v2*h/2).^3 -g*v3+x1(i+1));

    v4=(v(i)+k3*h);
    k4=(-(a+b)*(x(i)+v3*h) + (a+1)*(x(i)+v3*h).^2 - (x(i)+v3*h).^3 -g*v4+x1(i+1));


    v(i+1)=v(i)+(h/6)*(k1+2*k2+2*k3+k4);
    x(i+1)=x(i)+(h/6)*(v1+2*v2+2*v3+v4);  % final signal
end

