function s=star(p)

if     p < 0.001
    s = '***';
elseif p < 0.01
    s = '**';
elseif p < 0.05
    s = '*';
elseif p < 0.1
    s='.';
else
    s='';
end
    

end