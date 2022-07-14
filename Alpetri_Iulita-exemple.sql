--11
--a
select e.id_client,e.nume, e.prenume,
       decode (floor(months_between(sysdate, f.data_inceput)), 0, 'Valabil ',
                                                            1, 'Valabil',
                                                            2, 'Valabil',
                                                            3, 'Valabil', 'Expirat')"Valabil/expirat"
from client e
join permis f on e.id_client= f.id_client
where lower(e.PERMIS)='y' and lower(e.nume)= lower((select nume
                                                    from client
                                                    where id_client= 7))   --are acelasi nume ca si clientul cu id 7

order by e.prenume
select * from client
--b
-- pt angajatii cu servicii in 2022 angajatii cu cele mai multe servicii
select e.id_angajat, e.nume, e.prenume, nvl(e."Adresa", sysdate)
from angajat e join consultatie f on e.id_angajat= f.id_angajat
                join serviciu g on g.id_serviciu= f.id_serviciu
    where to_char(g.data_serviciu, 'YYYY')= '2022' and e.data_angajare in (select distinct min(data_angajare)
                                                                           from angajat )
order by e.nume desc/
select * from angajat
--c- clienti sub 30 de ani si care au o macar o achizitie de 30 lei in 2022
select e.id_client, e.prenume, e.nume
    from client e
join consultatie f on e.id_client= f.id_client
where e.varsta< 30 and e.id_client in (select x.id_client
                                       from client x
                                       join consultatie y on y.id_client= x.id_client
                                       join serviciu z on z.id_serviciu= y.id_serviciu
                                       join achizitie a on z.id_serviciu = a.id_serviciu
                                       where a.pret_final> 30 and to_char(z.data_serviciu, 'YYYY')= '2022' )/

--d
--sa se afiseze info(denumire departament, salariu maxim, si ultima data de anagajare pt fiecare departament), care a fct ultima angajare acum 3 ani
with informatii as (select g.denumire_departament, max(f.salariu) sal_max, max(f.data_angajare) max_data_angajare
                    from angajat f join rel_departament_angajat g on f.id_angajat = g.id_angajat
                    group by g.denumire_departament
                    )


select * from informatii
         where add_months(max_data_angajare, 36)< sysdate



 -- e
 -- cati angajati cu adresa introdusa sunt din constanta, cati din bucuresti
select sum(Constanta) "Angajati Constanta" , sum(Bucuresti) "Angajati Bucuresti"
from (select e.id_angajat , case instr(lower(e."Adresa"), 'constanta') when 0 then 0 else 1 end Constanta,
                            case instr(lower(e."Adresa"), 'bucuresti') when 0 then 0 else 1 end Bucuresti
      from angajat e
      where e."Adresa" is not null)



--12
--a
update angajat
    set salariu= salariu+ salariu* 120/100
where id_angajat in(
    select id_angajat
    from rel_departament_angajat
    where denumire_departament in( select denumire_departament
                                   from departament
                                   where zile_concediu = (select min(zile_concediu)
                                                          from departament))
    )

    /
--b
update carte_achizitie
set pret_total= pret_total- (10/100) * pret_total
where months_between(( select data_tiparire
        from carte
        where carte.id_carte= carte_achizitie.id_carte), current_date)> 12
or (select editura
    from carte
    where  editura in (
        select editura from carte where data_tiparire in (select min(data_tiparire) from carte)
        ))= (select editura from carte where carte.id_carte= carte_achizitie.id_carte)

--c
--Sa se stearga toate cartile achizitionate si toate cartile editurii celei mai putin populare edituri care are cele mai putine carti.-- te m ai uiti odata
delete from carte
where disponibilitate in 'N'   or  editura in (select editura
                                                   from carte
                                                   having count(editura) <10
                                                   group by editura)





--13- sequence
create sequence contor
start with 10
increment by 1
nocache nocycle/
insert into client(id_client, nume, prenume, permis) values (contor.nextval, 'Branzoi', 'Izabela', 'N' )/
insert into client (id_client, nume, prenume, permis) VALUES (contor.nextval, 'Georgescu', 'Mihai', 'N')/
insert into client (id_client, nume, prenume, permis) VALUES (contor.nextval, 'Crivoi', 'Gheorghe', 'N')/
insert into client (id_client, nume, prenume, permis) values (contor.nextval, 'Puscas', 'Madalin', 'N')/

select * from client/

--14
create or replace view vizualizare as(
        select distinct
    e.id_serviciu,
    e.data_serviciu,
    f.data_predare,
    f.data_penalizare,
    f.pret_penalizare
    from serviciu e
    join imprumut f on f.id_serviciu= e.id_serviciu
    where extract(month from e.data_serviciu) = 5

    )/
select * from vizualizare order by id_serviciu/
                    delete from vizualizare where id_serviciu= 2/








--15
create index ind_angajat on angajat(nume, prenume)/
select e.id_angajat, e.nume, e.prenume
from angajat e
where lower(e.NUME)= 'alpetri' and lower(e.prenume)= 'iulita'

drop index ind_angajat






--16
--outer join 4 tabele
select e.PRET_FINAL, e.id_serviciu, f.data_serviciu, h.nume, h.prenume, i.id_carte
    from achizitie e
 full outer join serviciu f on e.id_serviciu = f.id_serviciu
full outer join consultatie g on e.id_serviciu= g.id_serviciu
full outer join client h on h.id_client= g.id_client
full outer join carte_achizitie i on e.id_serviciu= i.id_serviciu





--division 1 - Afisati id-ul, numele si prenumele angajatilor care lucfreaza in cel putin un departament cu angajatul cu id=1.
select e.id_angajat, nume||' '||prenume "Nume intreg"
from rel_departament_angajat e join angajat f on f.id_angajat= e.id_angajat
where denumire_departament in(select denumire_departament
                                from rel_departament_angajat
                                where id_angajat=1 ) and e.id_angajat!= 1

group by e.id_angajat, nume|| ' '||prenume
having count(*)= (select  count(denumire_departament)
                  from rel_departament_angajat
                  where id_angajat= 1)




-- division 2- Afisati i-ul, numele si prenumele angajatilor care lucreaza in exact
--aceleasi departamente ca angajatul cu id=1.
select e.id_angajat, nume||' '||prenume "Nume intreg"
from rel_departament_angajat e join angajat f on f.id_angajat= e.id_angajat
where denumire_departament in(select denumire_departament
                                from rel_departament_angajat
                                where id_angajat=1 ) and e.id_angajat!= 1
minus
select e.id_angajat,nume || ' '|| prenume "Numele intreg"
from rel_departament_angajat e join angajat f on f.id_angajat= e.id_angajat
where denumire_departament not in( select denumire_departament
                                   from rel_departament_angajat
                                    where id_angajat= 1)




select * from rel_departament_angajat where id_angajat=1
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) VALUES (23, 1, 'Gogulescu', 'Elena', '87324653', '0789546724', 2300, '13-may-2022')

insert into rel_departament_angajat(id_relatie, id_angajat, denumire_departament, id_filiala) values (9, 23, 'Curatenie', 1)




--17. Optimizarea unei cereri, aplicând regulile de optimizare ce derivă din proprietățile operatorilor algebrei relaționale. Cererea va fi exprimată prin expresie algebrică, arbore algebric și limbaj (SQL), atât anterior cât și ulterior optimizării.
--sa se afiseze numele si prenumele clientilor care au cumparat cel putin  3  carti
select e.nume||' '||e.prenume
from client e join consultatie f on e.id_client= f.id_client
group by e.nume||' '||e.prenume
having (select count(*)
        from carte_achizitie
        group by f.id_serviciu
        having f.id_serviciu= id_serviciu
        )= 1





