-- Create Tables
create table mesas (
     id               int not null primary key,
     mesa_codigo      varchar(20),
     mesa_situacao    varchar(1) default 'A',
     data_criacao     timestamp,
     data_atualizacao timestamp);

# tabela para gravar registro dos funcionários
create table funcionarios(
     id                    int not null primary key,
     funcionario_codigo    varchar(20),
     funcionario_nome      varchar(100),
     funcionario_situacao  varchar(1) default 'A',
     funcionario_comissao  real,
     funcionario_cargo     varchar(30),
     data_criacao          timestamp,
     data_atualizacao      timestamp);   

# tabela para gravar registro das vendas
create table vendas(
     id               int not null primary key,
     funcionario_id   int references funcionarios (id),
     mesa_id          int references mesas(id),
     venda_codigo     varchar(20),
     venda_valor      real,
     venda_total      real,
     venda_desconto    real,
     venda_situacao   varchar(1) default 'A',
     data_criacao     timestamp,
     data_atualizacao timestamp);

# tabela para gravar registro dos produtos
create table produtos(
     id               int not null primary key,
     produto_codigo   varchar(20),
     produto_nome     varchar(60),
     produto_valor    real,
     produto_situacao varchar(1) default 'A',
     data_criacao     timestamp,
     data_atualizacao timestamp);    

# tabela para gravar registro dos itens das vendas
create table itens_vendas(
     id                int not null primary key,
     produto_id        int not null references produtos(id),
     vendas_id int not null references vendas(id),
     item_valor        real,
     item_quantidade   int,
     item_total       real,
     data_criacao      timestamp,
     data_atualizacao  timestamp);     

# tabela para gravar registro do cálculo das comissões
create table comissoes(
     id                int not null primary key,
     funcionario_id    int references funcionarios(id),
     comissao_valor    real,
     comissao_situacao varchar(1) default 'A',
     data_criacao      timestamp,
     data_atualizacao  timestamp);
	 
alter table comissoes add column data_pagamento timestamp;

-- Sequences				    
create sequence mesa_id_seq;
create sequence vendas_id_seq;
create sequence itens_vendas_id_seq;
create sequence produtos_id_seq;
create sequence funcionario_id_seq;
create sequence comissoes_id_seq;


-- Set Sequences
alter table mesas 
alter column id set default nextval('mesa_id_seq');
alter table vendas 
alter column id set default nextval('vendas_id_seq');
alter table itens_vendas 
alter column id set default nextval('itens_vendas_id_seq');
alter table produtos 
alter column id set default nextval('produtos_id_seq');
alter table funcionarios 
alter column id set default nextval('funcionario_id_seq');
alter table comissoes 
alter column id set default nextval('comissoes_id_seq'); 

