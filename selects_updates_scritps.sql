-- capitulo 3

postgres=> select * from mesas;

postgres=> select mesa_codigo, data_criacao from mesas;

postgres=> select * from mesas where mesa_codigo = '00002';

postgres=> update produtos set produto_valor = 4 where id = 2;

postgres=> update produtos set data_criacao = '31/12/2016';

postgres=> select data_criacao from produtos;

postgres=> delete from mesas where id = 2;

-- capitulo 4

postgres=# create or replace function 
            retorna_nome_funcionario(func_id int) 
            returns text as 
            $$              
            declare 
            nome     text;   
            situacao text;
            begin
			
              select funcionario_nome,
                     funcionario_situacao
                into nome, situacao
                from funcionarios
               where id = func_id;	
	           
               if situacao = 'A' then
                 return nome || ' Usuário Ativo';                 
               else                  
                 return nome || ' Usuário Inativo';                 
               end if;  
			   
            end
            $$ 
            language plpgsql;
			
postgresql=> select retorna_nome_funcionario(1);



postgresql=> create or replace function 
            rt_valor_comissao(func_id int)
            returns real as 
            $$
            declare             
              valor_comissao real;
             
            begin              
              select funcionario_comissao
                into valor_comissao
                from funcionarios
               where id = func_id;               
               return valor_comissao;
            end
            $$
            LANGUAGE plpgsql;

postgresql=> select rt_valor_comissao(1);


create or replace function 
             calc_comissao(data_ini timestamp,
                           data_fim timestamp)
             returns void as $$
             declare 
            
            -- declaração das variáveis que iremos
            -- utilizar. Já na declaração elas
            -- recebem o valor zero. Pois assim
            -- garanto que elas estarão zeradas
            -- quando for utiliza-las.
            
               total_comissao  real := 0;
               porc_comissao   real := 0;
			   
			-- declarando uma variavel para armazenar 
			-- os registros dos loop
			   reg             record;
               
            --cursor para buscar a % de comissão do funcionario
            
              cr_porce CURSOR (func_id int) IS 
                  select rt_valor_comissao(func_id);

             begin
            
            -- realiza um loop e busca todas as vendas
            --  no pereíodo informado
            
                for reg in( 
                  select vendas.id id,
                         funcionario_id,
                         venda_total
                    from vendas
                   where data_criacao >= data_ini
                     and data_criacao <= data_fim 
                     and venda_situacao = 'A')loop         
            
            -- abertura, utilização e fechamento do cursor
            
                  open cr_porce(reg.funcionario_id);
                  fetch cr_porce into porc_comissao;
                  close cr_porce;
                  
                             
                  total_comissao := (reg.venda_total * 
                                    porc_comissao)/100;
                 
            -- insere na tabela de comissoes o valor 
            -- que o funcionario ira receber de comissao
            -- daquela venda
            
                  insert into comissoes(
                                        funcionario_id,
                                        comissao_valor,
                                        comissao_situacao,
                                        data_criacao,
                                        data_atualizacao) 
                  values(reg.funcionario_id,
                         total_comissao,
                         'A',
                         now(),
                         now());
            
            -- update na situacao da venda 
            -- para que ela não seja mais comissionada
            
                  update vendas set venda_situacao = 'C'
                   where id = reg.id;
            
            -- devemos zerar as variáveis para reutiliza-las
            
                   total_comissao := 0;
                   porc_comissao  := 0;
                  
            -- termino do loop
            
                end loop;                                    
             
             end
             $$ language plpgsql;

postgresql=> select calc_comissao('01/01/2016 00:00:00','01/01/2016 00:00:00');

postgresql=> select comissao_valor,
                    data_criacao
               from comissoes;

postgresql=> drop function calc_comissoes();    

-- capitulo 5

   select venda_id,
          funcionario_id,
          venda_total
    from  vendas
   where data_criacao >= 'data_ini'
     and data_criacao <= 'data_fim'
     and produto_situacao = 'A'
	 
postgres=> insert into produtos (produto_codigo,
                                 produto_nome,
                                 produto_valor,
                                 produto_situacao,
                                 data_criacao,
                                 data_atualizacao)
                          values ('2832',
                                  'SUCO DE LIMÃO',
                                   15,
                                  'C',
                                  '02/02/2016',
                                  '02/02/2016');

postgres=> select * 
             from produtos
            where produto_situacao = 'A'
              and produto_situacao = 'C';

postgres=> select * 
             from produtos
            where produto_situacao = 'A'
               or produto_situacao = 'C';

postgres=> select * 
             from produtos
            where not produto_nome = 'SUCO DE LIMÃO';

postgres=> select * 
             from produtos
            where produto_situacao = 'A' 
               or (produto_situacao = 'C' 
                   and data_criacao = '02/02/2016');

select id,
       funcionario_id,
       venda_total
  from vendas
 where data_criacao >= 'data_ini'
   and data_criacao <= 'data_fim'
   and venda_situacao = 'A';

select id,
       funcionario_id,
       venda_total
  from vendas
 where data_criacao >= '01/01/2016'
   and data_criacao < '02/02/2016'
   and venda_situacao = 'A';


postgres=# select funcionario_codigo || funcionario_nome 
               from funcionarios
              where id = 1;

select (funcionario_codigo ||' '|| funcionario_nome)
  from funcionarios
  where id = 1;

select (funcionario_codigo ||8|| funcionario_nome)
  from funcionarios
  where id = 1;


postgres=# select char_length(funcionario_nome)
               from funcionarios
              where id = 2;

postgres=# select upper(funcionario_nome)
               from funcionarios;

postgres=# select upper('livro postgresql');

postgres=# select initcap('livro postgresql');

postgres=# select lower(funcionario_nome)
              from funcionarios;

postgres=# select overlay(funcionario_nome placing '000000' 
                           from 3 for 5) 
               from funcionarios 
              where id = 1;

postgres=# select substring(funcionario_nome from 3 for 5)
               from funcionarios
              where id = 1;

postgres=# select position('CIUS' in funcionario_nome) 
               from funcionarios
              where id = 1; 		

postgres=# select age(timestamp '04/11/1988');

postgresq=# select age(timestamp '07/05/2016', 
                       timestamp '12/05/2007');

postgres=# select count(*)
             from funcionarios;

postgres=# select sum(venda_total)
             from vendas;

postgres=# select avg(produto_valor)
             from produtos;

postgres=# select max(produto_valor), min(produto_valor)
             from produtos;


postgres=> insert into vendas (id, 
                               funcionario_id,
                               mesa_id,
                               venda_codigo,
                               venda_valor,
                               venda_total,
                               venda_desconto,
                               venda_situacao,
                               data_criacao,
                               data_atualizacao)
                        values (10000,
                                1,
                                1,
                                '10201',
                                '51',
                                '51',
                                '0',
                                'A',
                                '01/01/2016',
                                '01/01/2016');
                                 
postgres=> insert into itens_vendas (produto_id,
                                     vendas_id,
                                     item_valor,
                                     item_quantidade,
                                     item_total,
                                     data_criacao,
                                     data_atualizacao)
                             values (4,
                                     10000,
                                     15,
                                     2,
                                     30,
                                     '01/01/2016',
                                     '01/01/2016');
                                     
postgres=> insert into itens_vendas (produto_id,
                                     vendas_id,
                                     item_valor,
                                     item_quantidade,
                                     item_total,
                                     data_criacao,
                                     data_atualizacao)
                             values (3,
                                     10000,
                                     7,
                                     3,
                                     21,
                                     '01/01/2016',
                                     '01/01/2016');                                        
postgres=> insert into vendas (id, 
                               funcionario_id,
                               mesa_id,
                               venda_codigo,
                               venda_valor,
                               venda_total,
                               venda_desconto,
                               venda_situacao,
                               data_criacao,
                               data_atualizacao)
                        values (10001,
                                1,
                                1,
                                '10201',
                                '20',
                                '20',
                                '0',
                                'A',
                                '01/01/2016',
                                '01/01/2016');
                                
postgres=> insert into itens_vendas (produto_id,
                                     vendas_id,
                                     item_valor,
                                     item_quantidade,
                                     item_total,
                                     data_criacao,
                                     data_atualizacao)
                             values (1,
                                     10001,
                                     10,
                                     2,
                                     20,
                                     '01/01/2016',
                                     '01/01/2016');  
                                     
postgres=> insert into vendas (id, 
                               funcionario_id,
                               mesa_id,
                               venda_codigo,
                               venda_valor,
                               venda_total,
                               venda_desconto,
                               venda_situacao,
                               data_criacao,
                               data_atualizacao)
                        values (10002,
                                1,
                                1,
                                '10002',
                                '45',
                                '45',
                                '0',
                                'A',
                                '01/01/2016',
                                '01/01/2016');
                                 
postgres=> insert into itens_vendas (produto_id,
                                     vendas_id,
                                     item_valor,
                                     item_quantidade,
                                     item_total,
                                     data_criacao,
                                     data_atualizacao)
                             values (4,
                                     10002,
                                     15,
                                     3,
                                     45,
                                     '01/01/2016',
                                     '01/01/2016');

postgres=# create or replace function 
            retorna_nome_produto(prod_id int) 
            returns text as 
            $$              
            declare 
            nome     text;   
            begin
              select produto_nome                     
                into nome
                from produtos
               where id = prod_id;                
                 return nome;
            end
            $$ 
            language plpgsql;

postgres=# select retorna_nome_produto(produto_id) , sum(iten_total)
             from itens_vendas
            group by produto_id;

postgres=# select retorna_nome_produto(produto_id) PRODUTO, 
                  sum(item_total) VL_TOTAL_PRODUTO
             from itens_vendas
            group by produto_id
            order by vl_total_produto, produto;

postgres=# select retorna_nome_produto(produto_id) PRODUTO, 
                  sum(item_total) VL_TOTAL_PRODUTO
             from itens_vendas
            group by produto_id
            order by vl_total_produto desc, produto;

postgres=#   select retorna_nome_produto(produto_id), 
                    count(id) QTDE
               from itens_vendas
              group by produto_id;

postgres=#   select retorna_nome_produto(produto_id) produto, 
                    count(id) qtde
               from itens_vendas
              group by produto_id
             having count(produto_id) >= 2
              order by qtde;


postgres=> insert into funcionarios(funcionario_codigo,
                                    funcionario_nome,
                                    funcionario_situacao,
                                    funcionario_comissao,
                                    funcionario_cargo,
                                    data_criacao)
                             values('0100',
                                    'VINICIUS SOUZA',
                                    'A',
                                     2,
                                    'GARÇOM',
                                    '01/03/2016');


postgres=> insert into funcionarios(funcionario_codigo,
                                    funcionario_nome,
                                    funcionario_situacao,
                                    funcionario_comissao,
                                    funcionario_cargo,
                                    data_criacao)
                             values('0101',
                                    'VINICIUS SOUZA MOLIN',
                                    'A',
                                     2,
                                    'GARÇOM',
                                    '01/03/2016');


postgres=> insert into funcionarios(funcionario_codigo,
                                    funcionario_nome,
                                    funcionario_situacao,
                                    funcionario_comissao,
                                    funcionario_cargo,
                                    data_criacao)
                             values('0102',
                                    'VINICIUS RANKEL C',
                                    'A',
                                     2,
                                    'GARÇOM',
                                    '01/03/2016');


postgres=> insert into funcionarios(funcionario_codigo,
                                    funcionario_nome,
                                    funcionario_situacao,
                                    funcionario_comissao,
                                    funcionario_cargo,
                                    data_criacao)
                             values('0103',
                                    'BATISTA SOUZA LUIZ',
                                    'A',
                                     2,
                                    'GARÇOM',
                                    '01/03/2016');


postgres=> insert into funcionarios(funcionario_codigo,
                                    funcionario_nome,
                                    funcionario_situacao,
                                    funcionario_comissao,
                                    funcionario_cargo,
                                    data_criacao)
                             values('0104',
                                    'ALBERTO SOUZA CARDOSO',
                                    'A',
                                     2,
                                    'GARÇOM',
                                    '01/03/2016');

postgres=> insert into funcionarios(funcionario_codigo,
                                    funcionario_nome,
                                    funcionario_situacao,
                                    funcionario_comissao,
                                    funcionario_cargo,
                                    data_criacao)
                             values('0105',
                                    'CARLOS GABRIEL ALMEIDA',
                                    'A',
                                     2,
                                    'GARÇOM',
                                    '01/03/2016');


postgres=> insert into funcionarios(funcionario_codigo,
                                    funcionario_nome,
                                    funcionario_situacao,
                                    funcionario_comissao,
                                    funcionario_cargo,
                                    data_criacao)
                             values('0106',
                                    'RENAN SIMOES SOUZA',
                                    'A',
                                     2,
                                    'GARÇOM',
                                    '01/03/2016');

postgresql=# select funcionario_nome
               from funcionarios
              where funcionario_nome like 'VINICIUS%';

postgresql=# select funcionario_nome
               from funcionarios
              where funcionario_nome like '%SOUZA%';

postgresql=# select funcionario_nome
               from funcionarios
              where funcionario_nome = 'VINICIUS%';

postgresql=# select funcionario_nome
               from funcionarios
              where funcionario_nome = 'VINICIUS SOUZA';			  
-- capitulo 6


postgres=> create table logs_produtos(
		     id                    int not null primary key, 
		     data_alteracao        timestamp,
		     alteracao             varchar(10),
		     id_old                int,
			 produto_codigo_old    varchar(20),
			 produto_nome_old      varchar(60),
			 produto_valor_old     real,
			 produto_situacao_old  varchar(1) default 'A',
			 data_criacao_old      timestamp,
			 data_atualizacao_old  timestamp,
			 id_new                int,
			 produto_codigo_new    varchar(20),
			 produto_nome_new      varchar(60),
			 produto_valor_new     real,
			 produto_situacao_new  varchar(1) default 'A',
			 data_criacao_new      timestamp,
			 data_atualizacao_new  timestamp );
			 
postgres=> create sequence logs_produto_id_seq;

postgres=> alter table logs_produtos
           alter column id set default 
           nextval('logs_produto_id_seq');			 


create or replace function gera_log_produtos() 
returns trigger as

$$

Begin

  if TG_OP = 'INSERT' then 

    insert into logs_produtos (			  
               alteracao
              ,data_alteracao
			  ,id_new
			  ,produto_codigo_new   
			  ,produto_nome_new     
			  ,produto_valor_new    
			  ,produto_situacao_new 
			  ,data_criacao_new     
			  ,data_atualizacao_new
         	) 

       values (
         	   TG_OP 
         	  ,now()
			  ,new.id
			  ,new.produto_codigo   
			  ,new.produto_nome     
			  ,new.produto_valor    
			  ,new.produto_situacao 
			  ,new.data_criacao     
			  ,new.data_atualizacao 

         	  );
         return new;


  elsif TG_OP = 'UPDATE' then

	  insert into logs_produtos (			  
	               alteracao
	              ,data_alteracao
	              ,id_old
	         	  ,produto_codigo_old   
				  ,produto_nome_old     
				  ,produto_valor_old    
				  ,produto_situacao_old 
				  ,data_criacao_old     
				  ,data_atualizacao_old 
				  ,id_new
				  ,produto_codigo_new   
				  ,produto_nome_new     
				  ,produto_valor_new    
				  ,produto_situacao_new 
				  ,data_criacao_new     
				  ,data_atualizacao_new
	         	) 

	       values (
	         	   TG_OP 
	         	  ,now()
	         	  ,old.id
				  ,old.produto_codigo  
				  ,old.produto_nome    
				  ,old.produto_valor   
				  ,old.produto_situacao
				  ,old.data_criacao    
				  ,old.data_atualizacao
				  ,new.id
				  ,new.produto_codigo   
				  ,new.produto_nome     
				  ,new.produto_valor    
				  ,new.produto_situacao 
				  ,new.data_criacao     
				  ,new.data_atualizacao 

	         	  );
	         return new;

    elsif TG_OP = 'DELETE' then 
    
	  insert into logs_produtos (			  
	               alteracao
	              ,data_alteracao
	              ,id_old
	         	  ,produto_codigo_old   
				  ,produto_nome_old     
				  ,produto_valor_old    
				  ,produto_situacao_old 
				  ,data_criacao_old     
				  ,data_atualizacao_old 
	         	) 

	       values (
	         	   TG_OP 
	         	  ,now()
	         	  ,old.id
				  ,old.produto_codigo  
				  ,old.produto_nome    
				  ,old.produto_valor   
				  ,old.produto_situacao
				  ,old.data_criacao    
				  ,old.data_atualizacao

	         	  );
	         return new;

    end if;    

end;

$$ language 'plpgsql';


postgres=>  create trigger tri_log_produtos
            after insert or update or delete on produtos
            for each row execute 
            procedure gera_log_produtos();    

postgres=> \d produtos;


postgres=> insert into produtos (produto_codigo,
                                 produto_nome,
                                 produto_valor,
                                 produto_situacao,
                                 data_criacao,
                                 data_atualizacao)
                         values ('1512',
                                 'LAZANHA',
                                 46,
                                 'A',
                                 '01/01/2016',
                                 '01/01/2016');

postgres=> insert into produtos (produto_codigo,
                                 produto_nome,
                                 produto_valor,
                                 produto_situacao,
                                 data_criacao,
                                 data_atualizacao)
                         values ('1613',
                                 'PANQUECA',
                                 38,
                                 'A',
                                 '01/01/2016',
                                 '01/01/2016');

postgres=> insert into produtos (produto_codigo,
                                 produto_nome,
                                 produto_valor,
                                 produto_situacao,
                                 data_criacao,
                                 data_atualizacao)
                         values ('733',
                                 'CHURRASCO',
                                 72,
                                 'A',
                                 '01/01/2016',
                                 '01/01/2016');     

postgres=> 
        select alteracao
              ,data_alteracao
			  ,id_new
			  ,produto_codigo_new   
			  ,produto_nome_new     
			  ,produto_valor_new    
			  ,produto_situacao_new 
			  ,data_criacao_new     
			  ,data_atualizacao_new 
         from logs_produtos; 

postgres=> 
      update produtos set produto_valor = 99
       where produto_nome = 'CHURRASCO';

postgres=> select * 
             from logs_produtos;

postgres=> delete from produtos where produto_nome = 'PANQUECA';

postgres=> select * 
             from logs_produtos;			 

postgres=> alter table produtos 
           disable trigger tri_log_produtos;


postgres=> insert into produtos (produto_codigo,
                                 produto_nome,
                                 produto_valor,
                                 produto_situacao,
                                 data_criacao,
                                 data_atualizacao)
                         values ('912',
                                 'SORVETE',
                                  6,
                                 'A',
                                 '01/01/2016',
                                 '01/01/2016'); 

postgres=> select * 
             from logs_produtos;


postgres=> alter table produtos 
           enable trigger tri_log_produtos;

postgres=> update produtos set produto_valor = 10
            where produto_nome = 'SORVETE'; 

postgres=> select * 
             from logs_produtos;

postgres=> drop trigger tri_log_produtos on produtos;

postgres=> \d produtos
			 
-- capitulo 7
postgres=# select funcionario_nome
             from funcionarios
            where id in (select funcionario_id
                           from vendas);
						   
postgres=# select funcionario_nome
             from funcionarios
            where id in (select funcionario_id
                           from vendas
                          where date_part('year', data_criacao) = '2016');

postgres=# select distinct funcionario_nome
             from funcionarios
            where id in (select funcionario_id
                           from vendas)
            order by funcionario_nome;

postgres=# select distinct funcionario_nome
             from funcionarios, vendas
            where funcionarios.id = vendas.funcionario_id
            order by funcionario_nome;

postgres=# select distinct funcionario_nome
             from funcionarios, vendas  
            order by funcionario_nome;

postgres=# select distinct funcionario_nome 
             from funcionarios 
            inner join vendas 
               on (funcionarios.id = vendas.funcionario_id)
            order by funcionario_nome;

postgres=# select distinct funcionario_nome
             from funcionarios
             join vendas
               on (funcionarios.id = vendas.funcionario_id)
            order by funcionario_nome;  

postgres=# select funcionario_nome, v.id
             from funcionarios f
             left join vendas v
               on f.id = v.funcionario_id
            order by funcionario_nome desc;
			
postgres=# select v.id, v.venda_total, funcionario_nome
             from vendas v
            right join funcionarios f
               on v.funcionario_id = f.id
            order by v.venda_total;

postgres# create or replace view vendas_do_dia as
                select distinct produto_nome
                     , sum(vendas.venda_total)
                  from produtos, itens_vendas, vendas
                 where produtos.id = itens_vendas.produto_id
                   and vendas.id   = itens_vendas.vendas_id
                   and vendas.data_criacao = '01/01/2016'
                 group by produto_nome; 

postgres# select * from vendas_do_dia;
				 
postgres=# select * 
             from vendas_do_dia
            where produto_nome = 'PASTEL';

postgresq# create or replace view produtos_vendas as
               select produtos.id PRODUTO_ID
                    , produtos.produto_nome PRODUTO_NOME
                    , vendas.id VENDA_ID
                    , itens_vendas.id ITEM_ID
                    , itens_vendas.item_valor ITEM_VALOR
                    , vendas.data_criacao DATA_CRIACAO
                 from produtos, vendas, itens_vendas
                where vendas.id   = itens_vendas.vendas_id
                  and produtos.id = itens_vendas.produto_id
                order by data_criacao desc;

postgres=# select *
             from produtos_vendas;

postgres=# select produto_nome
             from produtos_vendas
            where data_criacao = '01/01/2016';

postgres=# create or replace view produtos_estoque as
               select * 
                 from produtos;
				 
postgres=# select produto_nome
             from produtos_estoque;

-- capitulo 8
postgres=> create user nomedousuario superuser;

postgres=> alter user nomedousuario password 'senha2'

$> psql -U nomedousuario postgres -h localhost

postgres=> create database newbase;

postgres=# \c nomedousuario newbase;

newbase=# \l;

$> pg_dump --host localhost --port 5432 --username postgres --format tar --file nomearquivo.backup postgres

$> pg_restore --host localhost --port 5432 --username nomedousuario --dbname newbase nomearquivo.backup

newbase=# \d;


COPY funcionarios
( 
   funcionario_codigo,
   funcionario_nome,
   funcionario_situacao,
   funcionario_comissao,
   funcionario_cargo,
   data_criacao,
   data_atualizacao
)    
FROM '/local_do_arquivo/funcionarios.csv'
DELIMITER ';'
CSV HEADER;

postgres=# select * from funcionarios where funcionario_cargo = 'GARÇOM';

postgres=# create index idx_cargo on funcionarios(funcionario_cargo);

posgtres=# drop index idx_cargo;


postgres=# create index idx_cargo on 
              funcionarios(funcionario_cargo);

postgres=# create index idx_codigo on 
             funcionarios using hash (funcionario_codigo);

postgres=# create index concurrentyle idx_nome on 
              funcionarios btree (funcionario_nome);

postgres=# create index idx_funcionario_id_codigo on 
              funcionarios(id, funcionario_codigo);

postgres=# select *
             from funcionarios
            where id > 10
              and funcionario_codigo < '1000';		

postgres=# create unique index idx_unique_codigo on 
                 funcionarios(funcionario_codigo);

postgres=# select funcionario_codigo
             from funcionarios;

postgres=# insert into funcionarios(funcionario_codigo, funcionario_nome)
            values('0001', 'DANIEL VINICIUS SOUZA');

postgres=# analyze verbose;

postgres=# analyze verbose funcionarios;

postgres=# analyze verbose funcionario(funcionario_cargo);

postgres=# reindex table funcionarios;

-- capitulo 9

postgresql=# alter table produtos 
               add column produto_categoria text[];
			   
postgresql=# 

insert into produtos (produto_codigo,
                      produto_nome,
                      produto_valor,
                      produto_situacao,
                      data_criacao,
                      data_atualizacao,
                      produto_categoria)
              values ('03251',
                      'ESFIRRA',
                       5,
                      'A',
                      '01/01/2016',
                      '01/01/2016',
                      '{"CARNE", "SALGADO", "ASSADO" , "QUEIJO"}');			   


postgresql=# select produto_categoria
               from produtos
              where produto_nome like 'ESFIRRA';

postgresql=# select produto_categoria[2]
               from produtos
              where produto_nome like 'ESFIRRA';			  


postgresql=# select produto_categoria[2:4]
               from produtos
              where produto_nome like 'ESFIRRA';

postgresql=# alter table produtos 
               add column produto_estoque json;


postgresql=#
 insert into produtos(produto_codigo,
                      produto_nome,
                      produto_valor,
                      produto_situacao,
                      data_criacao,
                      data_atualizacao,
                      produto_categoria,
                      produto_estoque)
            values('6234',
                   'COCA-COLA',
                   6,
                   'A',
                   '01/01/2016',
                   '01/01/2016',
                   '{"REFRIGERANTE", 
                     "LATA", 
                     "BEBIDA" , 
                     "COLA"}',
                   '{ "info_estoque": 
                      { "tem_estoque": "SIM", 
                        "quantidade": 17, 
                        "ultima_compra": "01/01/16" } 
                    }'
                   );       

postgresql=# select produto_estoque 
               from produtos 
              where produto_nome like 'COCA-COLA';

postgresql=#
  select produto_estoque->'info_estoque'->>'quantidade' 
         as quantidade 
    from produtos  
   where produto_nome like 'COCA-COLA';

postgresql=#
  select produto_estoque->'info_estoque'->'ultima_compra' 
         as ultima_compra 
    from produtos  
   where produto_nome like 'COCA-COLA';

postgresql=#
  select produto_estoque->'info_estoque'->>'ultima_compra' 
         as ultima_compra 
    from produtos  
   where produto_nome like 'COCA-COLA';


postgresql=#
 insert into produtos(produto_codigo,
                      produto_nome,
                      produto_valor,
                      produto_situacao,
                      data_criacao,
                      data_atualizacao,
                      produto_categoria,
                      produto_estoque)
            values('77978',
                   'GATORADE',
                   6,
                   'A',
                   '01/01/2016',
                   '01/01/2016',
                   '{"ISOTONICO", 
                     "GARRAFA", 
                     "BEBIDA" }',
                   '{ "info_estoque": 
                      { "tem_estoque": "SIM", 
                        "quantidade": 17, 
                        "ultima_compra": "01/01/16" },
                       "ultima_venda": "02/01/2016" 
                    }'
                   );   

postgresql=# 
   select produto_estoque 
     from produtos 
    where produto_estoque->>'ultima_venda' = '02/01/2016';