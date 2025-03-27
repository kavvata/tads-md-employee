select e.emp_no                                                                        as "num_funcionario",
       e.birth_date                                                                    as "data_nascimento",
       e.gender                                                                        as "sexo",
       e.hire_date                                                                     as "data_contratado",
       concat(concat(e.first_name, ' '), e.last_name)                                  as "nome_funcionario",
       d.dept_no                                                                       as "num_departamento",
       d.dept_name                                                                     as "departamento",
       t.title                                                                         as "cargo",
       t.from_date                                                                     as "de",
       IF(t.to_date = '9999-01-01', now(), t.to_date)                                  as "ate",
       s.salary                                                                        as "salario",
       s.from_date                                                                     as "data_ajuste_salario",
       IF(dm.emp_no is not null, concat(concat(c.first_name, ' '), c.last_name), null) as "chefia",
       dm.from_date                                                                    as "data_entrada_chefia",
       dm.to_date                                                                      as "data_saida_chefia"
from employees e
         join titles t on t.emp_no = e.emp_no
         join dept_emp de on e.emp_no = de.emp_no
         join departments d on de.dept_no = d.dept_no
         join salaries s on e.emp_no = s.emp_no
         left join dept_manager dm
                   on dm.dept_no = de.dept_no and dm.from_date <= de.to_date and
                      (dm.to_date >= s.from_date and dm.from_date <= s.from_date)
         left join (select first_name, last_name, emp_no from employees) c on c.emp_no = dm.emp_no
order by e.emp_no, t.from_date, s.from_date, dm.from_date;
