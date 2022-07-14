--crearea tabelelor
--filiala biblioteca
create table Filiala_biblioteca
(
    id_filiala     int
        constraint Filiala_biblioteca_pk
            primary key,
    nume_filiala   varchar(50)  not null,
    adresa_filiala varchar(100) not null
);
/create unique index FILIALA_ID_FILIALA_BIBLIOTECA_UINDEX
    on FILIALA_BIBLIOTECA (id_filiala)
/
alter table FILIALA_BIBLIOTECA
    modify ID_FILIALA number(8)
/
alter table FILIALA_BIBLIOTECA
modify id_filiala not null
/

--carte
create table carte
(
    id_carte      int
        constraint CARTE_PK
            primary key,
            id_filiala int not null,
    autor         varchar2(50) not null,
    editura       varchar2(50) not null,
    data_tiparire date         not null,
    constraint carte_filiala_biblioteca__FK
        foreign key(id_filiala)  references FILIALA_BIBLIOTECA(id_filiala)
)/
alter table carte modify id_carte number(8) not null/
alter table carte modify id_filiala number(8)/
alter table CARTE
    add pret float default NULL
/
alter table carte add nume varchar2(50) not null/
/
alter table CARTE
    add disponibilitate varchar2(1)
/

alter table CARTE
    add achizitie varchar2(1)
/
create unique index carte_id_carte_UINDEX
    on carte (id_carte)/


--carte imprumut
create table carte_imprumut
(
    id_carte number(8) not null,
    id_serviciu number(8) not null,
    constraint CARTE_IMPRUMUT_CARTE__FK
        foreign key (id_carte) references CARTE(id_carte),
    constraint CARTE_IMPRUmut_serviciu__FK
        foreign key (id_serviciu) references serviciu(id_serviciu)
)/


create unique index CARTE_IMPRUMUT_ID_CARTE_UINDEX
    on CARTE_IMPRUMUT (ID_CARTE)
/

alter table CARTE_IMPRUMUT
    add constraint CARTE_IMPRUMUT_PK
        primary key (ID_CARTE)
/
/




/

--carte achizitie
create table carte_achizitie
(
    id_carte   number(8) not null,
    id_serviciu   number(8) not null
        constraint CARTE_ACHIZITIE_PK
            primary key,
    pret_total float     not null,
    constraint CARTE_ACHIZITIE_CARTE__FK
        foreign key (id_carte) references CARTE(id_carte),
    constraint CARTE_ACHIZITIE_serviciu__FK
        foreign key (id_serviciu) references serviciu(id_serviciu)
)
/

create unique index CARTE_ACHIZITIE_ID_CARTE_UINDEX
    on carte_achizitie (id_carte)
/






--departament
create table departament
(
    denumire_departament      varchar2(50)
        constraint DEPARTAMENT_PK
            primary key,
            id_filiala int not null ,
    posturi_ocupate int,
    posturi_total   int not null,
    zile_concediu   int not null,
    constraint departament_filiala_biblioteca__FK
        foreign key(id_filiala)  references FILIALA_BIBLIOTECA(id_filiala)

)
/
alter table departament modify id_filiala number(8)/
alter table DEPARTAMENT
    drop primary key
/

alter table DEPARTAMENT
    add constraint DEPARTAMENT_PK
        primary key (ID_FILIALA, DENUMIRE_DEPARTAMENT)
/
create table angajat
(
    id_angajat    int
        constraint ANGAJAT_PK
            primary key,

    id_filiala     int not null,
    nume          varchar2(50) not null,
    prenume       varchar2(50) not null,
    cnp           varchar2(50) not null,
    telefon       varchar2(50) not null,
    salariu       float        not null,
    data_angajare date         not null,
    adresa varchar2(100) not null,
     constraint angajat_filiala_biblioteca__FK

        foreign key (id_filiala) references FILIALA_BIBLIOTECA(ID_FILIALA)

)/
create unique index ANGAJAT_CNP_UINDEX
    on ANGAJAT (CNP)
/
create unique index ANGAJAT_telefon_UINDEX
    on ANGAJAT (telefon)/
comment on column angajat.salariu is '>2100'
/
alter table angajat
    modify ID_ANGAJAT number(8) not null
/
--relatie departament angajat
create table rel_departament_angajat
(
    id_relatie           number(8) not null
        constraint REL_DEPARTAMENT_ANGAJAT_PK
            primary key,
    id_angajat           number(8) not null,
    denumire_departament varchar2(50) not null,
    id_filiala           number(8) not null,
    column_5             int,
    constraint REL_DEPARTAMENT_ANGAJAT_ANGAJAT__FK
        foreign key (id_angajat) references ANGAJAT(id_angajat),
    constraint REL_DEPARTAMENT_ANGAJAT_DEPARTAMENT__FK
        foreign key (denumire_departament, id_filiala) references DEPARTAMENT(denumire_departament, id_filiala)
)
/




--client
/
create table client
(
    id_client number(8)
constraint CLIENT_PK
            primary key,
    nume      varchar2(50) not null
        ,
    prenume   varchar2(50) not null,

    permis    char(1)      not null,
    varsta int not null
)
/
alter table client modify id_client not null/

--serviciu
create table serviciu
(
    id_serviciu   int
        constraint SERVICIU_PK
            primary key,

    data_serviciu date         not null,
    tip           varchar2(50) not null
)
/
alter table serviciu modify id_serviciu number(8) not null/
alter table serviciu set unused column tip/
alter table serviciu drop unused columns /





create table imprumut
(
    id_serviciu     number(8)
        constraint IMPRUMUT_PK
            primary key,

    data_predare date,
    data_penalizare date         not null,
    pret_penalizare float default null,
    constraint imprumut_serviciu__FK
        foreign key (id_serviciu) references serviciu(id_serviciu)
)
/
alter table imprumut modify id_serviciu not null/
/
create table achizitie
(
    id_serviciu   number(8)
        constraint ACHIZITIE_PK
            primary key,


    constraint achizitie_serviciu__fk
        foreign key (id_serviciu) references serviciu(id_serviciu)
)/
alter table achizitie modify id_serviciu not null
/
alter table achizitie add pret_final float not null/
--consultatie
create table consultatie
(

    id_client      number(8) not null,
    id_angajat     number (8) not null,
    id_serviciu    number(8) not null,
    PRIMARY KEY(id_client, id_angajat, id_serviciu),
    nr_receptie    int not null,
    constraint consultatie_angajat__FK
        foreign key (id_angajat) references ANGAJAT(id_angajat),
    constraint consultatie_client__FK
        foreign key (id_client) references CLIENT(id_client),
   constraint consultatie_serviciu__FK
        foreign key (id_serviciu) references SERVICIU(id_serviciu)
)
/
create table permis
(
    id_client     number(8) not null
        constraint PERMIS_PK
            primary key,
    nr_permis     int     not null,
    data_inceput  date    not null,
    data_expirare date    not null,
    constraint PERMIS_CLIENT__FK
        foreign key (id_client) references CLIENT(id_client)
)
/
alter table carte drop column pret
/

create unique index PERMIS_NR_PERMIS_UINDEX
    on permis (nr_permis)
/



--2- Inserarea de date

insert into FILIALA_BIBLIOTECA(id_filiala, nume_filiala, adresa_filiala) VALUES (1, 'Bibilioteca Facultatii de psihologie', 'Str. I. L. Caragiale, nr. 87, Bucuresti')/
insert into FILIALA_BIBLIOTECA(id_filiala, nume_filiala, adresa_filiala) VALUES (2, 'Biblioteca facultatii de Matematica si Informatica', 'str Academiei, Bucuresti')/

insert into carte(id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values (1, 1, 'Gabriel Purcarus', 'Polirom', '17-JUN-2018', 'Corectopia', 'Y', 'Y' )/
insert into carte (id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values (2, 1, 'Nathaniel Hawthorne', 'Raobooks', '3-AUG-2019', 'Litera stacojie', 'N', 'Y') /
insert into carte (id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values (3, 1, 'Peter Thiel', 'Introspectiv','13-MAY-2009', 'Zero to one', 'Y', 'Y' )/
insert into carte(id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values (4, 1, 'Richard Nisbett', 'Introspectiv', '30-JAN-2021', 'Mindware', 'Y', 'Y')/
insert into carte(id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values (5, 1, 'Warren Buffett', 'Curtea veche', '4-APR-2009', 'Secretele succesului', 'N', 'N')/
insert into carte (id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values (6, 1, 'Stephen Hawking', 'Humanitas', '6-NOV-2002', 'Scurta teorie a timpului', 'Y', 'N')/
insert into carte (id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values(7, 1, 'Ilf si Petrov', 'Polirom', '3-JUL-2016', 'Vitelul de aur', 'N', 'Y')/
insert into carte(id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values (8, 1, 'Marin Preda', 'Biblioteca pentru toti', '5-SEP-2014', 'Cel mai iubit dintre pamanteni', 'N', 'N' ) /
insert into carte(id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values (9, 1, 'Camil Petrescu', 'Minerva', '5-JUN-2003', 'Patul lui procust', 'Y', 'Y')/
insert into carte(id_carte, id_filiala, autor, editura, data_tiparire, nume, disponibilitate, achizitie) values(10, 1, 'Marin Preda', 'Cartea romaneasca', '12-JAN-2004','Delirul', 'Y', 'N' )/

select * from carte/
insert into departament(denumire_departament, id_filiala, posturi_ocupate, posturi_total, zile_concediu) VALUES ('Receptie', 1, 4, 6, 7)/
insert into departament(denumire_departament, id_filiala, posturi_ocupate, posturi_total, zile_concediu) values ('Management', 1, 5, 5, 14)/
insert into departament(denumire_departament, id_filiala, posturi_ocupate, posturi_total, zile_concediu) values('HR', 1, 1, 3, 10 )/
insert into departament(denumire_departament, id_filiala, posturi_ocupate, posturi_total, zile_concediu) values ('Imprumut', 1,5, 4, 7 )/
insert into departament(denumire_departament, id_filiala, posturi_ocupate, posturi_total, zile_concediu) values ('Curatenie', 1, 6, 3, 7)/

insert into departament(denumire_departament, id_filiala, posturi_ocupate, posturi_total, zile_concediu) VALUES ('Receptie', 2, 3, 1, 10)/
select * from departament
/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values (1, 1, 'Alpetri', 'Iulita', '67578785948', '0734569765', 2100, '13-MAY-2021')/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values (2, 1, 'Leustean', 'Andreea', '6548127476', '0745378920', 2500, '17-JUN-2021') /
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values (3, 1, 'Iancu', 'Cristina', '86534985638', '0789456798', 2300, '5-DEC-2020')/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values(4, 1, 'Popescu', 'Ion', '635823659832', '0789345618', 2300, '16-MAR-2020')/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values (5, 1, 'Andreea', 'Florescu', '6437848756', '0789345667', 2700, '15-MAR-2018')/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values (6, 1, 'Georgescu', 'Tudor', '376348568745', '0789345278', 3000, '6-JUN-2018' )/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values(7, 1, 'Lazar', 'Alina', '6453757387', '0789456378', 2700, '14-APR-2020')/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values (8, 1, 'Reban', 'George', '76532876', '0789654789', 2500, '6-NOV-2021')/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values(9, 1, 'Branzoi', 'Ana', '7643287', '0789567894', 3100, '17-AUG-2020')/
insert into angajat(id_angajat, id_filiala, nume, prenume, cnp, telefon, salariu, data_angajare) values(10, 1, 'Burnichi', 'Alexandru', '7653856', '0789546728', 2100, '15-JUL-2020')/
/
select * from angajat/
insert into rel_departament_angajat(id_relatie, id_angajat, denumire_departament, id_filiala) VALUES (1, 1, 'Curatenie', 1)/
insert into rel_departament_angajat(id_relatie, id_angajat, denumire_departament, id_filiala) VALUES (2, 10, 'Curatenie', 1)/
insert into rel_departament_angajat(id_relatie, id_angajat, denumire_departament, id_filiala) VALUES (3, 3, 'Curatenie', 1)/
insert into rel_departament_angajat(id_relatie, id_angajat, denumire_departament, id_filiala) values (4, 5, 'Receptie', 1)/
insert into rel_departament_angajat(id_relatie, id_angajat, denumire_departament, id_filiala) values (5, 4, 'Receptie', 1)/
insert into rel_departament_angajat(id_relatie, id_angajat, denumire_departament, id_filiala)  values (6, 6, 'HR', 1)/
insert into rel_departament_angajat(id_relatie, id_angajat, denumire_departament, id_filiala)  values (7, 9, 'Imprumut', 1)/
select * from rel_departament_angajat
/
insert into client(id_client, nume, prenume, permis) VALUES (1, 'Ghizila', 'Elena', 'N')/
insert into client(id_client, nume, prenume, permis) values (2, 'Carol', 'Mihai', 'Y')/
insert into client(id_client, nume, prenume, permis) values (3, 'Mantu', 'Stelian', 'Y')/
insert into client(id_client, nume, prenume, permis) values (4, 'Barbu', 'Robert', 'N')/
insert into client(id_client, nume, prenume, permis) values(5, 'Cojocaru', 'Violeta', 'N')/
select * from client/
insert into permis(id_client, nr_permis, data_inceput, data_expirare) values(3, '6348732', '12-JUN-2022', '12-JUN-2023')/
insert into permis(id_client, nr_permis, data_inceput, data_expirare) values(2, 73293, '13-APR-2022', '13-APR-2023')/

select * from permis/
insert into serviciu(id_serviciu, data_serviciu) VALUES (1, '15-JUN-2022')/
insert into serviciu(id_serviciu, data_serviciu) values(2, '8-MAY-2022')/
insert into serviciu(id_serviciu, data_serviciu) values (3, '7-APR-2022')/
insert into serviciu(id_serviciu, data_serviciu) values (4, '5-JUN-2022')/
insert into serviciu(id_serviciu, data_serviciu) values(5, '15-APR-2022')/
select * from serviciu/

insert into imprumut(id_serviciu, data_predare, data_penalizare, pret_penalizare) VALUES (1, '30-JUN-2022', '15-JUL-2022', 0)/
insert into imprumut(id_serviciu, data_predare, data_penalizare, pret_penalizare) VALUES (2, '15-JUN-2022', '8-JUN-2022', 5)/

insert into carte_imprumut(id_carte, id_serviciu) VALUES (5, 1)/
insert into carte_imprumut(id_carte, id_serviciu) values (6, 1)/
insert into carte_imprumut(id_carte, id_serviciu) values (8, 1)/
insert into carte_imprumut(id_carte, id_serviciu) values (10, 2)/

insert into carte_achizitie(id_carte, id_serviciu, pret_total) VALUES (1, 3, 15)/
insert into carte_achizitie(id_carte, id_serviciu, pret_total) values (3, 3, 20)/
insert into carte_achizitie(id_carte, id_serviciu, pret_total) VALUES (9, 4, 20)/

insert into achizitie(id_serviciu, pret_final) values (3, 35)/
insert into achizitie(id_serviciu, pret_final) values (4, 20)/
select * from carte
/
insert into consultatie(id_client, id_angajat, id_serviciu, nr_receptie) VALUES (1, 3, 1, 3)/
insert into consultatie(id_client, id_angajat, id_serviciu, nr_receptie) values (2, 3, 2, 2)/
insert into consultatie(id_client, id_angajat, id_serviciu, nr_receptie) values(3, 4, 3, 1)/
insert into consultatie(id_client, id_angajat, id_serviciu, nr_receptie) values (4, 1, 4, 1)/
select * from client/