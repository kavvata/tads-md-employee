select e.emp_no                                                                        as "num_funcionario",
       e.birth_date                                                                    as "data_nascimento",
       e.gender                                                                        as "sexo",
       concat(concat(e.first_name, ' '), e.last_name)                                  as "nome_funcionario",
       e.hire_date                                                                     as "data_contratado",
       d.dept_no                                                                       as "num_departamento",
       d.dept_name                                                                     as "departamento",
       de.from_date                                                                    as "lotado_em",
       de.to_date                                                                      as "lotado_ate",
       t.title                                                                         as "cargo",
       t.from_date                                                                     as "titulado_em",
       t.to_date                                                                       as "titulado_ate",
       s.salary                                                                        as "salario",
       s.from_date                                                                     as "data_ajuste_salario",
       IF(dm.emp_no is not null, concat(concat(c.first_name, ' '), c.last_name), null) as "chefia",
       dm.from_date                                                                    as "data_entrada_chefia",
       dm.to_date                                                                      as "data_saida_chefia"
from employees e
         join dept_emp de on e.emp_no = de.emp_no
         join titles t on t.emp_no = e.emp_no
         join departments d on de.dept_no = d.dept_no
         left join salaries s on t.emp_no = s.emp_no and (
            (s.to_date >= t.from_date and s.to_date <= t.to_date)
            or (t.from_date >= s.from_date and t.to_date <= s.to_date)
         )
         left join dept_manager dm
                   on dm.dept_no = de.dept_no and
                      ((dm.from_date <= s.from_date and dm.to_date >= s.from_date))
         left join (select first_name, last_name, emp_no from employees) c on c.emp_no = dm.emp_no
order by e.emp_no, t.from_date, dm.from_date;
