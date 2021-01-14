%the leader model
function [Q_leader, c_leader] = leader(lambda_e, lambda_s, T, N)
	%length of z_t, y_t;
	len_zt = 2;
    %y_t(1) is the len of [Ee, Es, Pe, Ps, u1, u2, u3, u4, I1, I2, I3, I4] 
    %y_t(2) is the len of [Ee, Es, Pe, Ps, u1, u2, u3, u4, u5, u6, I1, I2, I3, I4, I5, I6]
	y_t = [12,16] ;
    
    %z �� y Ԫ��ֻ��������ǰ����λ�õľ��� ��������ѭ����ֵ
    z = cell(length(N),1);
    start = 0;
    for mm = 1 : length(N)      
            z{mm} = start + 1 : start + len_zt * T * N(mm);
            start = z{mm}(end);
    end
    y = cell(length(N),1);
    start = len_zt * sum(N) * T;
    for mm = 1 : length(N)      
            y{mm} = start + 1 : start + y_t(mm) * N(mm) * T;
            start = y{mm}(end); 
    end
    
    
    %��ʼ��Q matrix
    nu = len_zt * sum(N) ;
    for mm = 1 : length(N)  
        nu = nu  + y_t(mm) * N(mm);
    end
    Q_leader = zeros(nu * T, nu * T);
    
    %��Q����ֵ
    %ǰ�涨��� z �� y Ԫ�����ڴ˴�ѭ����ֵ
    for mm = 1 : length(N)
        for nn = 1 : T * N(mm)   
            Q_leader(z{mm}(1 + (nn - 1) * len_zt), y{mm}(3 +  (nn - 1) * y_t(mm))) = -1 ;%Ce ��
            Q_leader(z{mm}(2 + (nn - 1) * len_zt), y{mm}(4 +  (nn - 1) * y_t(mm))) = -1 ;%Cs �� 
        end
    end
    %c matrix
    c_leader = zeros(nu * T, 1);
    for mm = 1 : length(N)
        for nn = 1 : T * N(mm)         
            c_leader(y{mm}(3 +  (nn - 1) * y_t(mm)), 1) = lambda_e(rem(nn, T) + 1);
            c_leader(y{mm}(4 +  (nn - 1) * y_t(mm)), 1) = lambda_s(rem(nn, T) + 1);
        end
    end
end